import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas"]

  connect() {
    console.log("SignaturePad controller connected!")  // Log when the controller connects
    this.signaturePad = new SignaturePad(this.canvasTarget)

    const readonly = this.data.get("readonly") === "true"
    const signatureData = this.data.get("signature")

    if (readonly && signatureData) {
      this.loadSignature(signatureData)
      this.disableSignaturePad()
    }

    // Ensure signature gets captured before form submission
    this.element.addEventListener('submit', this.submitSignature.bind(this))
  }

  clearSignature() {
    if (!this.isReadOnly()) {
      this.signaturePad.clear()
    }
  }

  submitSignature(event) {
    if (!this.signaturePad.isEmpty()) {
      const signatureData = this.signaturePad.toDataURL();
      const input = document.createElement('input');
      input.type = 'hidden';
      input.name = 'client[signature]';
      input.value = signatureData;
      this.element.appendChild(input); // Append the signature to the form
    }
  }
  

  isReadOnly() {
    return this.data.get("readonly") === "true"
  }

  disableSignaturePad() {
    this.signaturePad.off()
    this.canvasTarget.style.pointerEvents = 'none'
    document.getElementById("clear-signature").disabled = true
  }

  loadSignature(signatureData) {
    const image = new Image()
    image.src = signatureData
    image.onload = () => {
      this.signaturePad.clear()
      this.signaturePad.fromDataURL(signatureData)
    }
  }
}
