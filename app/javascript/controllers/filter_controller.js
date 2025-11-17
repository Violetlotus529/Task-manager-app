import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["allMode", "fieldset"]

  connect() {
    this.toggle()
  }

  toggle() {
    const allChecked = this.hasAllModeTarget && this.allModeTarget.checked
    if (this.hasFieldsetTarget) {
      this.fieldsetTarget.disabled = !!allChecked
    }
  }
}