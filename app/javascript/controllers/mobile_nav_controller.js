import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["header", "panel", "toggleButton", "backdrop"];
  static values = {
    breakpoint: { type: Number, default: 760 }
  };

  connect() {
    this.onScroll = this.onScroll.bind(this);
    this.onResize = this.onResize.bind(this);
    this.onKeydown = this.onKeydown.bind(this);

    document.addEventListener("scroll", this.onScroll, { passive: true });
    window.addEventListener("resize", this.onResize, { passive: true });
    document.addEventListener("keydown", this.onKeydown);

    this.mountBackdrop();
    this.syncNavA11y();
    this.onScroll();
  }

  disconnect() {
    document.removeEventListener("scroll", this.onScroll);
    window.removeEventListener("resize", this.onResize);
    document.removeEventListener("keydown", this.onKeydown);

    this.resetState();
    this.unmountBackdrop();
  }

  toggle() {
    if (this.isOpen()) {
      this.close();
      return;
    }

    this.open();
  }

  close() {
    if (!this.isOpen()) return;

    this.panelTarget.classList.remove("is-open");
    this.setNavOpen(false);
    this.toggleButtonTarget.setAttribute("aria-expanded", "false");
    this.toggleButtonTarget.setAttribute("aria-label", "Открыть меню");

    this.setBackdropVisible(false);
    this.syncNavA11y();
    this.restoreFocus();
  }

  closeOnLinkClick(event) {
    if (!event.target.closest("a")) return;
    this.close();
  }

  open() {
    this.lastFocused = document.activeElement;

    this.panelTarget.classList.add("is-open");
    this.setNavOpen(true);
    this.toggleButtonTarget.setAttribute("aria-expanded", "true");
    this.toggleButtonTarget.setAttribute("aria-label", "Закрыть меню");

    this.setBackdropVisible(true);
    this.syncNavA11y();
    this.focusPanel();
  }

  onScroll() {
    if (!this.hasHeaderTarget) return;
    this.headerTarget.classList.toggle("is-scrolled", window.scrollY > 10);
  }

  onResize() {
    if (window.innerWidth > this.breakpointValue) {
      this.close();
    }

    this.syncNavA11y();
  }

  onKeydown(event) {
    if (event.key !== "Escape") return;
    this.close();
  }

  isOpen() {
    return this.panelTarget.classList.contains("is-open");
  }

  isDesktop() {
    return window.innerWidth > this.breakpointValue;
  }

  syncNavA11y() {
    if (this.isDesktop()) {
      this.panelTarget.removeAttribute("aria-hidden");
      return;
    }

    this.panelTarget.setAttribute("aria-hidden", this.isOpen() ? "false" : "true");
  }

  resetState() {
    this.panelTarget.classList.remove("is-open");
    this.panelTarget.removeAttribute("aria-hidden");
    this.setNavOpen(false);
    this.toggleButtonTarget.setAttribute("aria-expanded", "false");
    this.toggleButtonTarget.setAttribute("aria-label", "Открыть меню");

    this.setBackdropVisible(false);
  }

  setNavOpen(open) {
    document.documentElement.classList.toggle("nav-open", open);
    document.body.classList.toggle("nav-open", open);
  }

  setBackdropVisible(visible) {
    if (!this.hasBackdropTarget) return;

    this.backdropTarget.classList.toggle("is-visible", visible);
    this.backdropTarget.setAttribute("aria-hidden", visible ? "false" : "true");
  }

  mountBackdrop() {
    if (!this.hasBackdropTarget || this.backdropPlaceholder) return;

    this.backdropPlaceholder = document.createComment("nav-backdrop");
    this.backdropTarget.before(this.backdropPlaceholder);
    document.body.appendChild(this.backdropTarget);
  }

  unmountBackdrop() {
    if (!this.hasBackdropTarget || !this.backdropPlaceholder) return;

    this.backdropPlaceholder.before(this.backdropTarget);
    this.backdropPlaceholder.remove();
    this.backdropPlaceholder = null;
  }

  focusPanel() {
    const focusable = this.panelTarget.querySelector(
      ".nav__close, a:not([hidden])"
    );
    focusable?.focus({ preventScroll: true });
  }

  restoreFocus() {
    if (this.lastFocused && typeof this.lastFocused.focus === "function") {
      this.lastFocused.focus({ preventScroll: true });
    } else {
      this.toggleButtonTarget.focus({ preventScroll: true });
    }
    this.lastFocused = null;
  }
}
