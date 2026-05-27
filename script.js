(() => {
  const header = document.getElementById("siteHeader");
  const burger = document.getElementById("burger");
  const nav = document.getElementById("primaryNav");

  const onScroll = () => {
    header.classList.toggle("is-scrolled", window.scrollY > 10);
  };
  document.addEventListener("scroll", onScroll, { passive: true });
  onScroll();

  burger?.addEventListener("click", () => {
    const open = nav.classList.toggle("is-open");
    burger.setAttribute("aria-expanded", String(open));
    burger.setAttribute("aria-label", open ? "Закрыть меню" : "Открыть меню");
  });

  nav?.querySelectorAll("a").forEach((link) =>
    link.addEventListener("click", () => {
      if (nav.classList.contains("is-open")) {
        nav.classList.remove("is-open");
        burger.setAttribute("aria-expanded", "false");
      }
    })
  );

  const dateEl = document.getElementById("gregorianDate");
  if (dateEl) {
    const fmt = new Intl.DateTimeFormat("ru-RU", {
      day: "numeric",
      month: "long",
      year: "numeric",
    });
    dateEl.textContent = fmt.format(new Date());
  }
})();
