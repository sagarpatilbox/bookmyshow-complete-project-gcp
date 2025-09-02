document.addEventListener("DOMContentLoaded", () => {
  const events = [
    { id: 1, title: "Coldplay Concert", date: "2025-01-20", location: "Mumbai, India" },
    { id: 2, title: "Comedy Night", date: "2025-01-25", location: "Delhi, India" },
    { id: 3, title: "Art Exhibition", date: "2025-02-10", location: "Bangalore, India" }
  ];
  const eventList = document.querySelector(".event-list");
  events.forEach(event => {
    const eventCard = document.createElement("div");
    eventCard.classList.add("event-card");
    eventCard.innerHTML = `
      <h3>${event.title}</h3>
      <p>Date: ${event.date}</p>
      <p>Location: ${event.location}</p>
      <button onclick="bookTicket(${event.id}, '${event.title}')">Book Now</button>
    `;
    eventList.appendChild(eventCard);
  });
});
function bookTicket(eventId, eventTitle) {
  fetch('/api/book', { method: 'POST', headers: {'Content-Type':'application/json'}, body: JSON.stringify({ eventId, qty: 1 }) })
    .then(r => r.json()).then(j => alert(j.error ? j.error : `You have booked a ticket for ${eventTitle}! Remaining: ${j.remaining}`))
    .catch(e => alert('Booking failed: '+e.message));
}
