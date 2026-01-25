import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit() {
    // フォームを送信
    this.element.requestSubmit()
  }
}
