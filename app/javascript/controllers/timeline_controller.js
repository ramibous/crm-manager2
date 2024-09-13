import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["timeline", "seeMoreButton"];

  connect() {
    try {
      this.itemsPerPage = 3;
      this.currentPage = 1;

      const timelineItemsRaw = this.data.get("timelineItemsValue");

      if (timelineItemsRaw) {
        this.timelineItems = JSON.parse(timelineItemsRaw);
        this.totalItems = parseInt(this.data.get("totalItemsValue"), 10);
        console.log("Timeline items loaded:", this.timelineItems);
      } else {
        
        this.timelineItems = [];
        this.totalItems = 0;
      }

      this.loadTimelineItems();

      if (this.hasSeeMoreButtonTarget) {
        this.checkSeeMoreButton();
      } else {
       
      }

    } catch (error) {
      
    }
  }

  loadTimelineItems() {
    if (!this.timelineItems || this.timelineItems.length === 0) {
      
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

        this.timelineTarget.appendChild(timelineItem);
      }
    });

    this.currentPage++;
    this.checkSeeMoreButton();
  }

  seeMore() {
    this.loadTimelineItems();
  }

  checkSeeMoreButton() {
    if (!this.timelineItems || this.timelineItems.length === 0) {
     
      if (this.hasSeeMoreButtonTarget) {
        this.seeMoreButtonTarget.style.display = "none";
      } else {
       
      }
    } else {
      const shouldHideButton = this.currentPage * this.itemsPerPage >= this.totalItems;
      if (this.hasSeeMoreButtonTarget) {
        this.seeMoreButtonTarget.style.display = shouldHideButton ? "none" : "block";
      } else {
        
      }
    }
  }
}
