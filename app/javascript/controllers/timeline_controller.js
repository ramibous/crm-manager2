// app/javascript/controllers/timeline_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["timeline", "loadMoreButton"];

  async loadMore() {
    console.log("Load More button clicked");
  
    if (this.element.dataset.timelineNextUrl) {
      const nextUrl = this.element.dataset.timelineNextUrl;
      console.log("Fetching next URL:", nextUrl);
  
      try {
        const response = await fetch(nextUrl, {
          headers: {
            "Accept": "text/javascript"
          }
        });
  
        console.log("Response status:", response.status);
  
        if (response.ok) {
          const html = await response.text();
          console.log("Full response:", html);  // Log the full response here for debugging
          this.timelineTarget.insertAdjacentHTML("beforeend", html);
  
          // Update the next URL or remove the button if there are no more pages
          const nextPageUrl = this.timelineTarget.querySelector("[data-next-url]");
          if (nextPageUrl) {
            console.log("Next page URL found:", nextPageUrl.dataset.nextUrl);
            this.element.dataset.timelineNextUrl = nextPageUrl.dataset.nextUrl;
            nextPageUrl.remove();
          } else {
            console.log("No more pages.");
            this.element.dataset.timelineNextUrl = null;
            this.loadMoreButtonTarget.remove();
          }
        } else {
          console.error("Failed to fetch next URL:", response.statusText);
        }
      } catch (error) {
        console.error("Error during fetch:", error);
      }
    } else {
      console.log("No next URL found.");
    }
  }
  
}