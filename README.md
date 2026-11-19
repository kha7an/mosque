# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# mosque

## Деплой на VPS

`script/deploy` собирает production-образ для amd64 из Git-коммита на машине запуска,
передаёт его по SSH и обновляет контейнер Rails в `/opt/mosque`. PostgreSQL,
фотографии и HTTPS остаются на текущих томах. Rails применяет миграции при старте.
При первом деплое временный bind-mount расписания заменяется файлом
`config/recurring.yml` из образа. Включите исправленное расписание в первый коммит для деплоя.

Сначала закоммитьте изменения, которые должны попасть на сервер. Для запуска нужны
Docker с Buildx, SSH-доступ к VPS и проверенный ключ хоста в `known_hosts`.
На VPS нужен Docker Compose версии 2.24.4 или выше.

```bash
script/deploy       # текущий коммит HEAD
script/deploy main  # коммит на локальной ветке main
```

Для запуска из CI задайте `DEPLOY_SSH` и `DEPLOY_URL` при необходимости,
настройте SSH-ключ и `known_hosts`, затем вызовите `script/deploy` после тестов.
По умолчанию используется текущий VPS с адресом `152.228.118.179`.

При неудачном старте или ошибке проверки публичного `/up` скрипт пробует
поднять предыдущий образ. Миграции базы
при этом не откатываются. Изменения схемы должны быть совместимы с предыдущим релизом.
