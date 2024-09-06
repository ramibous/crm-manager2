import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["navbar"];

  connect() {
    this.lastScrollTop = 0;
    window.addEventListener('scroll', this.handleScroll.bind(this));
  }

  disconnect() {
    window.removeEventListener('scroll', this.handleScroll.bind(this));
  }

  handleScroll() {
    let scrollTop = window.pageYOffset || document.documentElement.scrollTop;

    if (scrollTop > this.lastScrollTop) {
      this.navbarTarget.classList.add('hidden');
    } else {
      this.navbarTarget.classList.remove('hidden');
    }

    this.lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
  }
}
