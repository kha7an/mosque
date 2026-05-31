const MOBILE_NAV_BREAKPOINT = 760;

const initHeader = () => {
  const header = document.getElementById("siteHeader");
  const burger = document.getElementById("burger");
  const navClose = document.getElementById("navClose");
  const nav = document.getElementById("primaryNav");
  const backdrop = document.getElementById("navBackdrop");

  if (!header) return;

  const onScroll = () => {
    header.classList.toggle("is-scrolled", window.scrollY > 10);
  };
  document.removeEventListener("scroll", onScroll);
  document.addEventListener("scroll", onScroll, { passive: true });
  onScroll();

  const syncNavA11y = () => {
    if (!nav) return;
    if (window.innerWidth > MOBILE_NAV_BREAKPOINT) {
      nav.removeAttribute("aria-hidden");
      return;
    }
    nav.setAttribute("aria-hidden", nav.classList.contains("is-open") ? "false" : "true");
  };

  const closeNav = () => {
    if (!nav?.classList.contains("is-open")) return;
    nav.classList.remove("is-open");
    document.body.classList.remove("nav-open");
    backdrop?.setAttribute("hidden", "");
    backdrop?.setAttribute("aria-hidden", "true");
    burger?.setAttribute("aria-expanded", "false");
    burger?.setAttribute("aria-label", "Открыть меню");
    syncNavA11y();
  };

  const openNav = () => {
    nav?.classList.add("is-open");
    document.body.classList.add("nav-open");
    backdrop?.removeAttribute("hidden");
    backdrop?.setAttribute("aria-hidden", "false");
    burger?.setAttribute("aria-expanded", "true");
    burger?.setAttribute("aria-label", "Закрыть меню");
    syncNavA11y();
  };

  burger?.addEventListener("click", () => {
    if (nav?.classList.contains("is-open")) {
      closeNav();
    } else {
      openNav();
    }
  });

  nav?.querySelectorAll("a").forEach((link) =>
    link.addEventListener("click", closeNav)
  );

  backdrop?.addEventListener("click", closeNav);
  navClose?.addEventListener("click", closeNav);

  syncNavA11y();

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") closeNav();
  });

  const onResize = () => {
    if (window.innerWidth > MOBILE_NAV_BREAKPOINT) closeNav();
    syncNavA11y();
  };
  window.removeEventListener("resize", onResize);
  window.addEventListener("resize", onResize, { passive: true });
};

const initSermons = () => {
  const filters = document.querySelector("[data-sermons-filters]");
  const grid = document.querySelector("[data-sermons-grid]");
  const modal = document.getElementById("videoModal");
  const frame = document.getElementById("videoModalFrame");
  const modalTitle = document.getElementById("videoModalTitle");

  if (!filters || !grid) return;

  const cards = () => grid.querySelectorAll("[data-video-modal]");

  const setActiveFilter = (button) => {
    filters.querySelectorAll(".chip").forEach((chip) => {
      const active = chip === button;
      chip.classList.toggle("is-active", active);
      chip.setAttribute("aria-selected", String(active));
    });
  };

  const applyFilter = (category) => {
    cards().forEach((card) => {
      const match = category === "all" || card.dataset.category === category;
      card.hidden = !match;
    });
  };

  filters.querySelectorAll("[data-filter]").forEach((button) => {
    button.addEventListener("click", () => {
      setActiveFilter(button);
      applyFilter(button.dataset.filter);
    });
  });

  const closeModal = () => {
    if (!modal || !frame) return;
    modal.hidden = true;
    document.body.classList.remove("video-modal-open");
    frame.removeAttribute("src");
    frame.title = "";
    if (modalTitle) modalTitle.textContent = "";
  };

  const openModal = (embedUrl, title) => {
    if (!modal || !frame || !embedUrl) return;
    if (modalTitle) modalTitle.textContent = title;
    frame.title = title;
    frame.src = embedUrl;
    modal.hidden = false;
    document.body.classList.add("video-modal-open");
  };

  grid.addEventListener("click", (event) => {
    const card = event.target.closest("[data-video-modal]");
    if (!card) return;
    openModal(card.dataset.embedUrl, card.dataset.videoTitle);
  });

  modal?.querySelectorAll("[data-video-modal-close]").forEach((el) => {
    el.addEventListener("click", closeModal);
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && modal && !modal.hidden) closeModal();
  });
};

const initMosque = () => {
  initHeader();
  initSermons();
};

document.addEventListener("turbo:load", initMosque);
initMosque();
