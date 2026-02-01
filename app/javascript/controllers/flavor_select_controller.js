import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "category"]
  static values = {
    url: String,
    selectedIds: String,
    categoryId: Number
  }

  connect() {
    this.selectedFlavorIds = []

    if (this.hasSelectedIdsValue) {
      this.selectedFlavorIds = this.selectedIdsValue
        .split(",")
        .map(id => parseInt(id))
        .filter(id => !isNaN(id))
    }

    // edit画面用：大カテゴリ復元 & 自動ロード
    if (this.hasCategoryIdValue && this.categoryTarget.value === "") {
      this.categoryTarget.value = this.categoryIdValue
      this.load({ target: this.categoryTarget })
    }
  }

  load(event) {
    const categoryId = event.target.value
    this.listTarget.innerHTML = ""

    // hidden field に同期
    const hidden = this.element.querySelector(
      'input[name="tea_product[selected_flavor_category_id]"]'
    )
    if (hidden) hidden.value = categoryId

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

      if (this.selectedFlavorIds.includes(flavor.id)) {
        checkbox.checked = true
      }

      label.appendChild(checkbox)
      label.appendChild(document.createTextNode(flavor.name))

      this.listTarget.appendChild(label)
    })
  }
}
