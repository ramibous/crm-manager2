import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["staffSelect", "clientsContainer", "selectAllCheckbox", "clientCheckbox"]

  loadClients() {
    const staffSelect = document.querySelector("#campaign_staff_id");
    const segmentSelect = document.querySelector("#segment_select");
    const clientsContainer = document.querySelector("#client-select-container");

    if (!staffSelect || !clientsContainer) {
      return;
    }

    const staffId = staffSelect.value;
    const segment = segmentSelect.value;

    if (!staffId) {
      clientsContainer.innerHTML = '<p>Please select a staff member to load clients.</p>';
      return;
    }

    fetch(`/campaigns/load_clients?staff_id=${staffId}&segment=${segment}`, {
      headers: { 'Accept': 'text/vnd.turbo-stream.html' }
    })
    .then(response => response.text())
    .then(html => {
      clientsContainer.innerHTML = html;
    })
    .catch(error => {
      clientsContainer.innerHTML = '<p>Error loading clients. Please try again.</p>';
    });
  }

  toggleSelectAll(event) {
    const isChecked = event.target.checked;
    this.clientCheckboxTargets.forEach(checkbox => {
      checkbox.checked = isChecked;
    });
  }
}
