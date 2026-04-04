import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "button"]

  connect() {
    this.toggleButton()
  }

  toggleButton() {
    this.buttonTarget.disabled = !this.checkboxTarget.checked
  }
}