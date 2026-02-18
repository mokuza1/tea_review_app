import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list"]
  static values = {
    url: String,
    selectedIds: String
  }

  connect() {
    this.selectedFlavorIds = this.hasSelectedIdsValue 
      ? this.selectedIdsValue.split(",").map(id => parseInt(id)).filter(id => !isNaN(id))
      : []

    // 初期ロード：チェックされているカテゴリのフレーバーを読み込む
    this.element.querySelectorAll('input[name="tea_product[selected_flavor_category_ids][]"]:checked').forEach(checkbox => {
      this.fetchAndRender(checkbox.value, checkbox.nextElementSibling.textContent.trim())
    })
  }

  // チェックボックスの切り替え時に呼ばれる
  toggleCategory(event) {
    const categoryId = event.target.value
    const categoryName = event.target.nextElementSibling.textContent.trim()

    if (event.target.checked) {
      this.fetchAndRender(categoryId, categoryName)
    } else {
      this.removeCategoryList(categoryId)
    }
  }

  fetchAndRender(categoryId, categoryName) {
    // すでに表示されている場合は何もしない
    if (this.listTarget.querySelector(`[data-category-group="${categoryId}"]`)) return

    fetch(`${this.urlValue}/${categoryId}/flavors`)
      .then(res => res.json())
      .then(data => this.renderGroup(categoryId, categoryName, data))
  }

  renderGroup(categoryId, categoryName, flavors) {
    const wrapper = document.createElement("div")
    wrapper.setAttribute("data-category-group", categoryId)
    wrapper.classList.add("border-l-4", "border-[#D6CEC5]", "pl-4", "mb-4")

    const title = document.createElement("p")
    title.classList.add("text-xs", "text-gray-500", "mb-2")
    title.textContent = `[ ${categoryName} ]`
    wrapper.appendChild(title)

    const flexContainer = document.createElement("div")
    flexContainer.classList.add("flex", "flex-wrap", "gap-4")

    flavors.forEach(flavor => {
      const label = document.createElement("label")
      label.classList.add("flex", "items-center", "bg-white", "px-3", "py-1", "rounded", "border", "cursor-pointer")

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
      flexContainer.appendChild(label)
    })

    wrapper.appendChild(flexContainer)
    this.listTarget.appendChild(wrapper)
  }

  removeCategoryList(categoryId) {
    const group = this.listTarget.querySelector(`[data-category-group="${categoryId}"]`)
    if (group) group.remove()
  }
}
