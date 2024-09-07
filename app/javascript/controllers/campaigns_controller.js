import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Campaign controller connected"); // This should log in the console when the controller is connected

    // Apply styles or effects
    this.applyStyles();
  }

  applyStyles() {
    let campaignDetails = this.element.querySelector('.campaign-details');
    if (campaignDetails) {
      campaignDetails.style.backgroundColor = '#f5f5f5';
      campaignDetails.style.padding = '20px';
      campaignDetails.style.borderRadius = '8px';
      console.log("Styles applied to campaign-details");
    } else {
      console.log("No campaign-details element found");
    }
  }
}
