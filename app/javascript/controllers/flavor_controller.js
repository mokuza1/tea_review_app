import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["children"]

  toggle(event) {
    const target = event.currentTarget.nextElementSibling
    target.classList.toggle("hidden")
  }
}
