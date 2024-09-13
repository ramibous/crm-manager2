import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["timeline", "seeMoreButton"];

  connect() {
    try {
      this.itemsPerPage = 3;
      this.currentPage = 1;

      const timelineItemsRaw = this.data.get("timelineItemsValue");

      if (timelineItemsRaw) {
        this.timelineItems = JSON.parse(timelineItemsRaw);  // Parse timeline items data
        this.totalItems = parseInt(this.data.get("totalItemsValue"), 10);
      } else {
        console.error("No timeline items found");
        this.timelineItems = [];
        this.totalItems = 0;
      }

      this.loadTimelineItems();  // Load first batch of items

      if (this.hasSeeMoreButtonTarget) {
        this.checkSeeMoreButton();  // Check button status
      } else {
        console.error("See More button target not found");
      }

    } catch (error) {
      console.error("Error connecting controller", error);
    }
  }

  loadTimelineItems() {
    if (!this.timelineItems || this.timelineItems.length === 0) {
      console.error("No timeline items to load.");
      return;
    }

    const startIndex = (this.currentPage - 1) * this.itemsPerPage;
    const endIndex = this.currentPage * this.itemsPerPage;
    const itemsToLoad = this.timelineItems.slice(startIndex, endIndex);

    itemsToLoad.forEach(item => {
      if (!this.timelineTarget.innerHTML.includes(item.description)) {
        const timelineItem = document.createElement("div");
        timelineItem.classList.add("timeline-item");

        const iconDiv = document.createElement("div");
        iconDiv.classList.add("timeline-icon");

        const contentDiv = document.createElement("div");
        contentDiv.classList.add("timeline-content");

        const dateSpan = document.createElement("span");
        dateSpan.classList.add("timeline-date");
        dateSpan.textContent = new Date(item.date).toLocaleString('en-GB', {
          day: '2-digit',
          month: 'short',
          year: 'numeric',
          hour: '2-digit',
          minute: '2-digit'
        });

        const descP = document.createElement("p");
        descP.textContent = item.description;

        contentDiv.appendChild(dateSpan);
        contentDiv.appendChild(descP);

        timelineItem.appendChild(iconDiv);
        timelineItem.appendChild(contentDiv);

        this.timelineTarget.appendChild(timelineItem);  // Add the item to the timeline
      }
    });

    this.currentPage++;  // Increment the page counter

    this.checkSeeMoreButton();  // Check if we should hide the "See More" button
  }

  seeMore() {
    this.loadTimelineItems();  // Load more items on click
  }

  checkSeeMoreButton() {
    if (this.hasSeeMoreButtonTarget && this.seeMoreButtonTarget) {
      // Hide the button if there are no more items
      if (this.currentPage * this.itemsPerPage >= this.totalItems) {
        console.log("Hiding See More button");
        this.seeMoreButtonTarget.style.display = "none";  // Hide button
      } else {
        console.log("See More button should be visible");
      }
    } else {
      console.error("See More button target not found in checkSeeMoreButton");
    }
  }
}
