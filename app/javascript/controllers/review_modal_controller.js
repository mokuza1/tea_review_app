import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  close(event) {
    if (event.target === this.element) {
      const returnPath = this.element.dataset.returnPath
      Turbo.visit(returnPath)
    }
  }

  stop(event) {
    event.stopPropagation()
  }
}