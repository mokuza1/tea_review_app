import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 3000 }
  }

  connect() {
    setTimeout(() => {
      this.fadeOut()
    }, this.timeoutValue)
  }

  fadeOut() {
    this.element.classList.add("opacity-0", "transition", "duration-500")

    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}