
---

# Event Admission Platform with Tito Integration

This is a Ruby on Rails 8 application that integrates with [Tito](https://ti.to/docs/api/admin/3.0) to manage and sync ticket data in real time. The platform uses background jobs (Sidekiq), webhook processing, and secure signature validation to ensure up-to-date ticket information.

---

## Features

* Sync all Tito tickets into the local database
* Handle real-time updates using Tito webhooks
* Verify webhook signatures using HMAC SHA256
* Background processing via Sidekiq
* JWT-based authentication for user registration and login
* Email confirmation and Devise-based user management
* View authenticated user profile and ticket details
* Dockerize app

## Features

### Tito Integration

* Sync all Tito tickets into the local database
* Handle real-time updates using Tito webhooks
* Verify webhook signatures using HMAC SHA256
* Background processing via Sidekiq
* Dockerized for local development

### User Portal (API Only)

* JWT-based authentication for registration & login
* Email confirmation via Devise
* View profile & ticket details

### Admin Portal (Web UI)

* Traditional web interface for managing tickets
* Devise-based authentication (session-based)
* Ticket listing, details view, and soft deletion with pagination


---

## Technologies Used

* **Ruby on Rails 8**
* **PostgreSQL**
* **Sidekiq**
* **Redis**
* **Devise + devise-jwt**
* **HTTParty**
* **ActiveModelSerializers**
* **Pagy** for pagination
* **Paranoia** gem for soft deletion
* **Swagger + rswag** for API documentation
* **Docker / Docker Compose**
* **VCR / RSpec / FactoryBot / Shoulda-Matchers** for test coverage

---

## Getting Started

### 1. Prerequisites

Make sure you have:

* Docker & Docker Compose installed
* A [Tito](https://ti.to/) account with:

  * API Token
  * Account Slug
  * Event Slug
  * Webhook security token

---

### 2. Clone the Repository

```bash
git clone https://github.com/HebaMamdouh93/event-admission-system.git
cd event-admission-system
```

---

### 3. Environment Variables

```bash
touch .env
cp .env.example .env
```

Make sure `.env` includes:

```dotenv
TITO_API_TOKEN=your_tito_api_token
TITO_ACCOUNT_SLUG=your_account
TITO_EVENT_SLUG=your_event
TITO_WEBHOOK_SECURITY_TOKEN=your_webhook_token
DEVISE_JWT_SECRET_KEY=your_devise_jwt_secret
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

## User Authentication & Portal

### 1. Registration

* A user must have a valid Tito ticket (with the same email) to register.
* Registration fails with a clear error message if no matching ticket is found.
* Verified using Tito API.

### 2. Email Verification

* Devise confirmable is enabled.
* Users must confirm their email before logging in.

### 3. Login/Logout

* Uses JWT-based login with `devise-jwt`.
* Tokens are returned upon login and must be sent in the `Authorization` header.

### 4. View Profile

* `GET /api/v1/profile`
* Requires authentication.
* Returns user info and associated tickets.

### 5. View Ticket Details

* `GET /api/v1/tickets/:id`
* Requires authentication.
* Returns details of a specific ticket belonging to the current user.

---

##  Admin Portal (Web Interface)

### 1. Admin Authentication

* Uses standard Devise (session-based)
* Admins are created manually or via seeds

**Create default admin via seed:**

```ruby
# db/seeds.rb
Admin.find_or_create_by!(email: "admin@example.com") do |admin|
  admin.password = "pass@1234"
  admin.password_confirmation = "pass@1234"
end

docker exec -it event-admission-system_web_1 bash
rails db:seed
```

### 2. Admin Login

* Visit: `http://localhost:3000/admins/sign_in`
* Admin credentials: `admin@example.com` / `pass@1234`

### 3. Admin Dashboard

* After login, redirected to `/admin/dashboard`
* Lists all non-deleted tickets
* Uses `pagy` for pagination
* Logout link provided at the top

### 4. Ticket Management

#### View All Tickets

* Table view with ticket ID, name, email, and state
* Paginated using `pagy`

#### View Ticket Details

* Click "Details" link on any ticket row to view full info
* Includes: ticket ID, status, name, email, phone

#### Soft Delete Ticket

* Clicking "Delete" action
* Uses `paranoia` gem to soft-delete (via `deleted_at`)
* Ticket is hidden from admin list but preserved in DB

---

## Soft Deletion with `paranoia`

```ruby
# app/models/ticket.rb
acts_as_paranoid
```

Tickets are never truly deleted — instead `deleted_at` is set.

To see deleted records (for debugging):

```ruby
Ticket.with_deleted
```

---

## Pagination with Pagy

```ruby
# controller
@pagy, @tickets = pagy(Ticket.order(created_at: :desc))

# view
<%= pagy_nav(@pagy) %>
```
---

## Swagger API Documentation

Interactive documentation is available at:

```
GET http://localhost:3000/api-docs
```

You can browse and test all available endpoints with request/response examples.

---

## Local Email Testing (Confirmation, Password Reset)

We use **MailHog** for testing Devise emails locally.



### Configure in `config/environments/development.rb`

```ruby
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = { address: 'mailhog', port: 1025 }
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

### Access Email UI

* Open `http://localhost:8025`
* You’ll see all Devise-related emails captured here.

---

## Syncing Tickets Manually

Trigger a full ticket sync via:

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

* Use tools like [ngrok](https://ngrok.com/) to expose local server to Tito for webhook testing.
* Add `byebug` in code and attach to container with:

  ```bash
  docker attach <container_id>
  ```

---
