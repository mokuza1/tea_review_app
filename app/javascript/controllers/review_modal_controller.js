import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  close(event) {
    if (event.target === this.element) {
      const frame = document.getElementById("review_modal")
      frame.innerHTML = ""
    }
  }

  stop(event) {
    event.stopPropagation()
  }
}