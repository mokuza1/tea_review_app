import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["overlay"]

  close() {
    this.element.remove()
  }

  closeBackground(event) {
    if (event.target === this.overlayTarget) {
      this.close()
    }
  }

  connect() {
    this.keyHandler = (event) => {
      if (event.key === "Escape") {
        this.close()
      }
    }

    document.addEventListener("keydown", this.keyHandler)
  }

  disconnect() {
    document.removeEventListener("keydown", this.keyHandler)
  }

}