import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "list", "hidden"]
  static values = { url: String }

  connect() {
    this.timeout = null
  }

  search() {
    const query = this.inputTarget.value.trim()

    // brand_id を一旦リセット
    this.hiddenTarget.value = ""

    if (query.length < 1) {
      this.clearList()
      return
    }

    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`)
        .then(res => res.json())
        .then(data => this.renderList(data))
    }, 200)
  }

  renderList(brands) {
    this.listTarget.innerHTML = ""

    brands.forEach(brand => {
      const li = document.createElement("li")
      li.textContent = brand.name
      li.dataset.id = brand.id
      li.classList.add("cursor-pointer", "p-2", "hover:bg-gray-100")

      li.addEventListener("click", () => {
        this.selectBrand(brand)
      })

      this.listTarget.appendChild(li)
    })
  }

  selectBrand(brand) {
    this.inputTarget.value = brand.name
    this.hiddenTarget.value = brand.id
    this.clearList()
  }

  clearList() {
    this.listTarget.innerHTML = ""
  }
}
