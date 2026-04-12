import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "overlay",
    "flavorPanel",
    "brandPanel",
    "teaTypePanel",
    "caffeinePanel"
  ]

  connect() {
    this.closeOnEscape = this.closeOnEscape.bind(this)
    document.addEventListener("keydown", this.closeOnEscape)
  }

  disconnect() {
    document.removeEventListener("keydown", this.closeOnEscape)
  }

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

    this.hideAllPanels()
    panel.classList.remove("hidden")
  }

  hideAllPanels() {
    this.flavorPanelTarget.classList.add("hidden")
    this.brandPanelTarget.classList.add("hidden")
    this.teaTypePanelTarget.classList.add("hidden")
    this.caffeinePanelTarget.classList.add("hidden")
  }

  close() {
    this.overlayTarget.classList.add("hidden")
    this.hideAllPanels()
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  stop(event) {
    event.stopPropagation()
  }
}
