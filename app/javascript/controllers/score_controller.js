import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["firstName", "lastName", "phone", "email", "birthday", "address", "postalCode", "notes", "score"]

  connect() {
    this.updateScore(); // Initialize the score when the page loads
  }

  updateScore() {
    const fields = [
      { element: this.firstNameTarget, required: true },
      { element: this.lastNameTarget, required: true },
      { element: this.phoneTarget, required: true },
      { element: this.emailTarget, required: false },
      { element: this.birthdayTarget, required: false },
      { element: this.addressTarget, required: false },
      { element: this.postalCodeTarget, required: false },
      { element: this.notesTarget, required: false }
    ];

    let filledRequiredFields = 0;
    let filledOptionalFields = 0;
    const totalRequired = fields.filter(field => field.required).length;
    const totalOptional = fields.length - totalRequired;

    fields.forEach(field => {
      if (field.element && field.element.value.trim() !== '') {
        if (field.required) {
          filledRequiredFields += 1;
        } else {
          filledOptionalFields += 1;
        }
      }
    });

    // Calculate the score
    const requiredFieldWeight = 50 / totalRequired;
    const optionalFieldWeight = 50 / totalOptional;

    const score = Math.round((filledRequiredFields * requiredFieldWeight) + (filledOptionalFields * optionalFieldWeight));
    this.scoreTarget.textContent = `DQ: ${score}%`;
  }
}
