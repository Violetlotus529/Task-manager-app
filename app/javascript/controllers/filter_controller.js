import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["allMode", "fieldset"]

  connect() {
    console.log('[filter] connect', this.element)
    this.toggle()

    // Fallback: if Stimulus targets are not found (e.g. partial loaded outside scope),
    // attach a simple change listener to the checkbox by id so UI still updates.
    this._fallbackListener = null
    if (!this.hasFieldsetTarget) {
      const cb = document.getElementById('filter_mode_all')
      if (cb) {
        this._fallbackListener = () => {
          const fieldset = document.querySelector('[data-filter-target="fieldset"]')
          if (fieldset) fieldset.disabled = !!cb.checked
        }
        cb.addEventListener('change', this._fallbackListener)
        // apply initial state
        this._fallbackListener()
      }
    }
  }

  toggle() {
    console.log('[filter] toggle called', { hasAllModeTarget: this.hasAllModeTarget, hasFieldsetTarget: this.hasFieldsetTarget })
    const allChecked = this.hasAllModeTarget && this.allModeTarget.checked
    if (this.hasFieldsetTarget) {
      this.fieldsetTarget.disabled = !!allChecked
    }
  }

  disconnect() {
    if (this._fallbackListener) {
      const cb = document.getElementById('filter_mode_all')
      if (cb) cb.removeEventListener('change', this._fallbackListener)
      this._fallbackListener = null
    }
  }
}