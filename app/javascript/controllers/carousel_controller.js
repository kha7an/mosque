import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["slide", "dot", "counter"];

  connect() {
    this.index = 0;
    this.onTouchStart = this.onTouchStart.bind(this);
    this.onTouchEnd = this.onTouchEnd.bind(this);
    this.element.addEventListener("touchstart", this.onTouchStart, { passive: true });
    this.element.addEventListener("touchend", this.onTouchEnd, { passive: true });
  }

  disconnect() {
    this.element.removeEventListener("touchstart", this.onTouchStart);
    this.element.removeEventListener("touchend", this.onTouchEnd);
  }

  next() {
    this.show((this.index + 1) % this.slideTargets.length);
  }

  prev() {
    this.show((this.index - 1 + this.slideTargets.length) % this.slideTargets.length);
  }

  goTo(event) {
    this.show(event.params.index);
  }

  show(index) {
    this.index = index;
    this.slideTargets.forEach((el, i) => el.classList.toggle("is-active", i === index));
    this.dotTargets.forEach((el, i) => el.classList.toggle("is-active", i === index));
    if (this.hasCounterTarget) {
      this.counterTarget.textContent = `${index + 1} / ${this.slideTargets.length}`;
    }
  }

  onTouchStart(event) {
    this.touchStartX = event.changedTouches[0].screenX;
  }

  onTouchEnd(event) {
    const delta = event.changedTouches[0].screenX - this.touchStartX;
    if (Math.abs(delta) < 40) return;
    delta < 0 ? this.next() : this.prev();
  }
}
