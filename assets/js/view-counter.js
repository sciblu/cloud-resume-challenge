const API_URL = window.location.hostname === "localhost" 
  ? "http://localhost:3001/counter" 
  : "https://api-counter.lahdigital.dev/count";

const STORAGE_KEY = "visitor_counted";
const SEVEN_DAYS_MS = 7 * 24 * 60 * 60 * 1000; // 7 days in milliseconds

// Check if visitor has already been counted within the last 7 days
function hasRecentVisit() {
  const lastCounted = localStorage.getItem(STORAGE_KEY);
  if (!lastCounted) return false;
  
  const now = Date.now();
  const elapsed = now - parseInt(lastCounted);
  return elapsed < SEVEN_DAYS_MS;
}

// Mark visitor as counted with current timestamp
function markVisited() {
  localStorage.setItem(STORAGE_KEY, Date.now().toString());
}

// Fetch and display current count (no increment)
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

// Increment count via POST and update display
async function incrementCount() {
  try {
    const response = await fetch(API_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      }
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
  
  if (hasRecentVisit()) {
    // Visited within last 7 days - just show the count
    console.log("Recent visitor - displaying count only");
    getCount();
  } else {
    // New visitor or 7+ days since last count - increment and mark
    console.log("New/returning visitor - incrementing count");
    incrementCount();
    markVisited();
  }
});
