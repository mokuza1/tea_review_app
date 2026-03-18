import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // 背景クリックでモーダルを閉じる
  close(event) {
    // クリックされたのが背景（このコントローラーが付与された要素自身）であるか確認
    if (event.target === this.element) {
      const frame = document.getElementById("review_modal")
      frame.src = ""       // 追加：リクエスト先をクリア
      frame.innerHTML = "" // 中身を消去
    }
  }

  stop(event) {
    event.stopPropagation()
  }
}