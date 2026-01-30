import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list"]
  static values = {
    url: String,
    selectedIds: String
  }

  connect() {
    // edit 画面用：既存フレーバーIDを保持
    this.selectedFlavorIds = []

    if (this.hasSelectedIdsValue) {
      this.selectedFlavorIds = this.selectedIdsValue
        .split(",")
        .map(id => parseInt(id))
    }
  }

  load(event) {
    const categoryId = event.target.value
    this.listTarget.innerHTML = ""

    if (!categoryId) return

    fetch(`${this.urlValue}/${categoryId}/flavors`)
      .then(res => res.json())
      .then(data => this.render(data))
  }

  render(flavors) {
    flavors.forEach(flavor => {
      const label = document.createElement("label")
      label.classList.add("block")

      const checkbox = document.createElement("input")
      checkbox.type = "checkbox"
      checkbox.name = "tea_product[flavor_ids][]"
      checkbox.value = flavor.id
      checkbox.classList.add("mr-2")

      // ★ edit 画面での復元ポイント
      if (this.selectedFlavorIds.includes(flavor.id)) {
        checkbox.checked = true
      }

      label.appendChild(checkbox)
      label.appendChild(document.createTextNode(flavor.name))

      this.listTarget.appendChild(label)
    })
  }
}
