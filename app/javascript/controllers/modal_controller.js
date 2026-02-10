import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "flavorPanel", "brandPanel"]

  openFlavor() {
    this.overlayTarget.classList.remove("hidden")
    this.flavorPanelTarget.classList.remove("hidden")
    this.brandPanelTarget.classList.add("hidden")
  }

  openBrand() {
    this.overlayTarget.classList.remove("hidden")
    this.brandPanelTarget.classList.remove("hidden")
    this.flavorPanelTarget.classList.add("hidden")
  }

  close() {
    this.overlayTarget.classList.add("hidden")
  }
}
