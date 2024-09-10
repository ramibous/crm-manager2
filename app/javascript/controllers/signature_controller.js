import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["canvas"]

  connect() {
    this.signaturePad = new SignaturePad(this.canvasTarget)
  }

  clearSignature() {
    this.signaturePad.clear()
  }

  submitSignature(event) {
    if (this.signaturePad.isEmpty()) {
      event.preventDefault()
      alert('Please provide a signature.')
    } else {
      const signatureData = this.signaturePad.toDataURL()
      const input = document.createElement('input')
      input.type = 'hidden'
      input.name = 'client[signature]'
      input.value = signatureData
      this.element.appendChild(input)
    }
  }
}
