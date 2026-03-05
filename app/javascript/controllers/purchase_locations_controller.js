import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [
    "container",
    "template",
    "field"
  ]

  add() {

    const activeFields = this.fieldTargets.filter((field) => {
      const destroyInput = field.querySelector("input[name*='_destroy']")
      return !(destroyInput && destroyInput.value == "1")
    })

    if (activeFields.length >= 3) {
      alert("購入場所は3件まで登録できます")
      return
    }

    const content = this.templateTarget.innerHTML.replace(
      /NEW_RECORD/g,
      new Date().getTime()
    )

    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {

    const field = event.target.closest(".purchase-location-fields")

    const destroyInput = field.querySelector(
      "input[name*='_destroy']"
    )

    if (destroyInput) {
      destroyInput.value = 1
    }

    field.style.display = "none"
  }
}