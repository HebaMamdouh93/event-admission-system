
---
# Event Admission Platform with Tito Integration

This is a Ruby on Rails 8 application that integrates with [Tito](https://ti.to/docs/api/admin/3.0) to manage and sync ticket data in real time. The platform uses background jobs (Sidekiq), webhook processing, and secure signature validation to ensure up-to-date ticket information.

---

## Features

- Sync all Tito tickets into the local database
- Handle real-time updates using Tito webhooks
- Verify webhook signatures using HMAC SHA256
- Background processing via Sidekiq
- Dockerize app

---

## Technologies Used

- **Ruby on Rails 8**
- **PostgreSQL**
- **Sidekiq**
- **Redis**
- **HTTParty**
- **Docker / Docker Compose**
- **VCR / RSpec** for test coverage

---

## Getting Started

### 1. Prerequisites

Make sure you have:

- Docker & Docker Compose installed
- A [Tito](https://ti.to/) account with:
  - API Token
  - Account Slug
  - Event Slug
  - Webhook security token

---

### 2. Clone the Repository

```bash
git clone https://github.com/HebaMamdouh93/event-admission-system.git
cd event-admission-system
````

---

### 3. Environment Variables

```bash
touch .env
cp .env.example .env
```

---

### 4. Build and Run with Docker

```bash
docker-compose build
docker-compose up
```

This starts:

* Rails server at `http://localhost:3000`
* PostgreSQL
* Redis
* Sidekiq dashboard at `http://localhost:3000/sidekiq`

---

## Webhooks Setup (Tito)

In your [Tito dashboard](https://dashboard.tito.io/), configure webhooks with:

**Endpoint URL:**

```
POST https://your-domain.com/webhooks/tito/sync_tickets
```

**Events to subscribe to:**

* `ticket.created`
* `ticket.updated`
* `ticket.completed`
* `ticket.reassigned`
* `ticket.updated`
* `ticket.unvoided`
* `ticket.voided`

**Security Token:**

Set it to match `TITO_WEBHOOK_SECURITY_TOKEN` in your `.env`.

---

## Syncing Tickets Manually

You can trigger a full ticket sync via:

```bash
docker exec -it event-admission-system_web_1 bash
rails c
SyncTitoTicketsJob.perform_now
```

Or queue it via Sidekiq:

```bash
docker exec -it event-admission-system_web_1 bash
rake tito:sync_tickets
```

---

## Running Tests

```bash
docker exec -it event-admission-system_web_1 bash
bundle exec rspec
```

---

## Development Tips

* Use tools like [ngrok](https://ngrok.com/) or [Serveo](https://serveo.net/) to test webhooks locally.
* Run `byebug` locally by attaching to the container terminal:

  ```bash
  docker attach <container_id>
  ```

---
