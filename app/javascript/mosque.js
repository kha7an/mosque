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
  initSermons();
};

document.addEventListener("turbo:load", initMosque);
