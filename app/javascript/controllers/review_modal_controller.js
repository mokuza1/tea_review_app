import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // 背景クリックでモーダルを閉じる
  close(event) {
    // クリックされたのが背景（このコントローラーが付与された要素自身）であるか確認
    if (event.target === this.element) {
      this.element.closest("turbo-frame").src = null // 接続先をクリア
      this.element.remove() // 要素自体を削除して完全に壁を取り払う
    }
  }

  stop(event) {
    event.stopPropagation()
  }
}