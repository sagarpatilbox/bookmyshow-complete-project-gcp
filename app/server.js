const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const app = express();
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

// In-memory events store (demo). Replace with DB for production.
const events = [
  { id: 1, title: 'Coldplay Concert', date: '2025-01-20', location: 'Mumbai, India', seats: 5000 },
  { id: 2, title: 'Comedy Night', date: '2025-01-25', location: 'Delhi, India', seats: 1500 },
  { id: 3, title: 'Art Exhibition', date: '2025-02-10', location: 'Bangalore, India', seats: 800 }
];

app.get('/api/events', (req, res) => {
  res.json(events.map(e => ({ id: e.id, title: e.title, date: e.date, location: e.location, seats: e.seats })));
});

app.post('/api/book', (req, res) => {
  const { eventId, qty } = req.body;
  const event = events.find(e => e.id === eventId);
  if (!event) return res.status(404).json({ error: 'Event not found' });
  if (event.seats < qty) return res.status(400).json({ error: 'Not enough seats' });
  event.seats -= qty;
  return res.json({ ok: true, remaining: event.seats });
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`Server started on port ${PORT}`));
