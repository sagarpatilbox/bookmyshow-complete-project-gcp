from locust import HttpUser, task, between
import random

class TicketUser(HttpUser):
    wait_time = between(1, 3)

    @task(3)
    def list_events(self):
        self.client.get('/api/events')

    @task(1)
    def book_event(self):
        self.client.post('/api/book', json={"eventId": 1, "qty": 1})
