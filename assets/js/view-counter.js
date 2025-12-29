const API_URL = window.location.hostname === "localhost" 
  ? "http://localhost:3001/counter" 
  : "https://api-counter.lahdigital.dev";

const STORAGE_KEY = "lastVisitDate";

// Check if visitor has already been counted today
function hasVisitedToday() {
  const lastVisit = localStorage.getItem(STORAGE_KEY);
  if (!lastVisit) return false;
  
  const today = new Date().toDateString();
  return lastVisit === today;
}

// Mark visitor as counted for today
function markVisited() {
  const today = new Date().toDateString();
  localStorage.setItem(STORAGE_KEY, today);
}

// Fetch and display current count
async function getCount() {
  try {
    const response = await fetch(API_URL);
    const data = await response.json();
    document.querySelector("#view-count").innerText = data.count;
    return data.count;
  } catch (error) {
    console.error("Error fetching count:", error);
    return null;
  }
}

// Increment count via PATCH and update display
async function incrementCount() {
  try {
    const currentCount = await getCount();
    if (currentCount === null) return;
    
    const response = await fetch(API_URL, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ count: currentCount + 1 })
    });
    const data = await response.json();
    document.querySelector("#view-count").innerText = data.count;
  } catch (error) {
    console.error("Error incrementing count:", error);
  }
}

// Initialize on page load
document.addEventListener("DOMContentLoaded", function() {
  console.log("Initializing view counter");
  
  if (hasVisitedToday()) {
    // Returning visitor today - just show the count
    console.log("Returning visitor - displaying count only");
    getCount();
  } else {
    // New visitor today - increment and mark as visited
    console.log("New visitor - incrementing count");
    incrementCount();
    markVisited();
  }
});
