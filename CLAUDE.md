# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Rails 8 app for a mosque website: prayer times, video sermons (Rutube embeds), events, and a daily hadith. Admin content (cities, prayer times, events, videos) is managed through Avo at `/avo`. Public UI is server-rendered ERB with Hotwire (Turbo/Stimulus) and importmaps — no JS bundler, no SPA framework.

## Commands

```bash
bin/setup              # install deps, prepare db, start server
bin/dev                # run dev server (Procfile.dev via foreman/bin/dev)
bin/rails server

bin/rails test                    # unit/integration tests
bin/rails test:system             # Capybara/Selenium system tests (needs Chrome)
bin/rails test test/models/video_test.rb            # single file
bin/rails test test/models/video_test.rb:12         # single test by line

bin/rubocop -f github   # lint (rubocop-rails-omakase house style, no custom rules)
bin/rubocop -a           # autocorrect
bin/brakeman --no-pager # static security scan
bin/importmap audit      # JS dependency vuln scan

bin/rails db:prepare     # create/migrate dev db
RAILS_ENV=test bin/rails db:test:prepare
```

CI (`.github/workflows/ci.yml`) runs brakeman, importmap audit, rubocop, and the full test suite (including system tests) against Postgres on every PR/push to main — match that locally before pushing.

Database is Postgres (`pg` gem). Background jobs/cache/cable run on Solid Queue/Solid Cache/Solid Cable (DB-backed, no Redis).

## Architecture

**Domain logic lives in `app/services/`, namespaced by feature, not in controllers/models.** Controllers stay thin (see `PagesController`, `PrayerTimesController`). Two service patterns are used throughout:

- **Presenters** (e.g. `PrayerTimes::SchedulePresenter`, `Hadiths::DailyPresenter`) — class method `.for(...)` builds a view-ready value object/hash. Use these instead of putting display logic in models or views.
- **Pipeline services** (`PrayerTimes::*Service`) — class method `.call(...)`, single-purpose, composed together. The prayer-times import pipeline is the main example:
  - `DumrtClient` scrapes/downloads source files from dumrt.ru (shells out to `curl` via `Open3`, not `Net::HTTP`).
  - `CsvParser` / `XlsxParser` (using `roo`) turn raw files into `PrayerTimes::Row` (a `Data.define`) using `ValueParser` for date/time coercion (handles Excel serial dates/times).
  - `UpsertService` writes `Row`s into `PrayerTime` records for a `City`.
  - `ImportService` (per-city CSV) and `YearlyImportService` (whole-country XLSX, records a `PrayerTimeImport`) are the two entry points; `SyncCitiesService` refreshes the `City` list.
  - Triggered via `bin/rails prayer_times:import_year[2026]` / `prayer_times:sync_cities` rake tasks, or the recurring `PrayerTimes::ImportYearJob` (scheduled in `config/recurring.yml`, runs every Jan 1 at 3am in production via Solid Queue's recurring tasks).

**Auth** is the Rails 8 generator-style session auth, not Devise: `Authentication` concern (`app/controllers/concerns/authentication.rb`) + `Current` (`ActiveSupport::CurrentAttributes`) + `Session`/`User` models with `has_secure_password`. Controllers include `Authentication` and call `allow_unauthenticated_access` to opt out per-action (see `SessionsController`, `PasswordsController`). Avo's `current_user_method` is wired to `Current.user`, so Avo auth piggybacks on the same session.

**Avo resources** (`app/avo/resources/`) define the admin CRUD for `City`, `PrayerTime`, `Event`, `Video` — check these when changing model fields/validations so the admin UI stays in sync.

**Models** hold validations, scopes, and small presentation helpers only (e.g. `Event#category_label`, `Video#embed_url`/`rutube_id` parsing for Rutube links). Heavier logic is pushed to `app/services`.

**I18n**: app is bilingual (`config/locales/en.yml`, `ru.yml`); date/time formatting goes through `I18n.l` with custom formats (e.g. `:event_day`, `:event_month`, `:long`) rather than manual `strftime` in views/models.

**Hadith content** is static JSON (`public/hadises/*.json`), not a DB table — `Hadiths::DailyPresenter` picks a deterministic "hadith of the day" via `Zlib.crc32(date) % size` and caches the parsed file in `Rails.cache` for a day.

**Deployment**: Kamal (`config/deploy.yml`, `.kamal/`) to a Docker container; Thruster in front of Puma. Avo, Solid Queue/Cache/Cable, and Postgres all run in the same deployed app.
