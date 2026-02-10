import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    const panel = event.currentTarget
      .closest("div")
      .nextElementSibling

    panel.classList.toggle("hidden")
  }
}