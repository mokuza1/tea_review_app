import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "overlay",
    "flavorPanel",
    "brandPanel",
    "teaTypePanel",
    "caffeinePanel"
  ]

  openFlavor() {
    this.show(this.flavorPanelTarget)
  }

  openBrand() {
    this.show(this.brandPanelTarget)
  }

  openTeaType() {
    this.show(this.teaTypePanelTarget)
  }

  openCaffeine() {
    this.show(this.caffeinePanelTarget)
  }

  show(panel) {
    this.overlayTarget.classList.remove("hidden")

    this.flavorPanelTarget.classList.add("hidden")
    this.brandPanelTarget.classList.add("hidden")
    this.teaTypePanelTarget.classList.add("hidden")
    this.caffeinePanelTarget.classList.add("hidden")

    panel.classList.remove("hidden")
  }

  close() {
    this.overlayTarget.classList.add("hidden")
  }
}