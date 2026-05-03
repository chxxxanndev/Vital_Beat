# HRLsys – Heart Rate Log System (v1.0)

## 📋 Project Overview

HRLsys is a web-based health monitoring application that allows users to track and analyze their heart rate data. This version focuses on the **Authentication Gateway**, providing a secure and modern system for user registration and login.

---

## 🛠 Tech Stack

* **Programming Language:** Ruby (3.x)
* **Framework:** Ruby on Rails (7.x)
* **Database:** MySQL 8.0
* **Authentication:** `has_secure_password` with BCrypt
* **Frontend:** Bootstrap 5, FontAwesome 6, Animate.css, Hotwire/Turbo

---

## 🔗 Database Connection Module (Main Requirement)

The system connects Ruby to MySQL using:

* **File:** `config/database.yml`
* **Adapter:** `mysql2`
* **ORM:** ActiveRecord (Rails built-in)

### Explanation:

Rails uses the `mysql2` adapter to establish a connection between the Ruby application and the MySQL database. The `database.yml` file contains the credentials and configuration. ActiveRecord manages queries and connection pooling automatically.

### Example Usage:

```ruby
User.create(name: "John", email: "john@example.com", password: "123456")
User.find_by(email: "john@example.com")
```

---

## 🔐 Security Features

* **Password Hashing:** Uses BCrypt to store `password_digest` instead of plain-text passwords
* **Salted Hashing:** Adds random salt for stronger security
* **Authentication:** `.authenticate` method verifies credentials securely
* **Session Management:** Server-side session handling

---

## 🏗 System Architecture (MVC)

### Models

* `User` – Handles database interaction, validation, and password encryption

### Views

* `users/new` – Registration UI
* `sessions/new` – Login UI
* `layouts/application` – Global layout

### Controllers

* `UsersController` – Handles user registration
* `SessionsController` – Handles login/logout
* `PasswordResetsController` – Handles password recovery

---

## 🧩 Key Features

* Split-screen responsive UI
* Real-time validation using Turbo
* Smooth animations using Animate.css
* Secure login and registration system

---

## 🗄 Database Structure

* Defined using migrations in `db/migrate/`
* Current structure available in `db/schema.rb`

---

## 🚀 Local Setup Instructions

1. Install dependencies:

```bash
bundle install
```

2. Configure database:
   Update `config/database.yml` with your MySQL credentials.

3. Create and migrate database:

```bash
rails db:create
rails db:migrate
```

4. Run the server:

```bash
rails server
```

5. Open in browser:

```
http://localhost:3000
```

---

## ✅ Proof of Functionality

The system successfully:

* Connects to MySQL database
* Creates user accounts (INSERT)
* Retrieves user data for login (SELECT)
* Stores encrypted passwords

---

## 📂 Project Structure (Simplified)

```
app/
 ├── controllers/   # Application logic (login, signup)
 ├── models/        # Database interaction (User model)
 ├── views/         # UI (HTML/ERB)
config/
 ├── database.yml   # Database connection configuration
 └── routes.rb      # URL routing
db/
 ├── migrate/       # Database history
 └── schema.rb      # Current database structure
Gemfile             # Project dependencies
README.md           # Documentation
```

---

## 📌 Development Notes

* `config/database.yml` → Handles database connection
* `app/models/user.rb` → Handles database operations
* `db/schema.rb` → Reflects current database design
* `db/migrate/` → Tracks database changes

---

## 📈 Development Phases

* Phase 1: Authentication System ✅
* Phase 2: Heart Rate Logging (Next)
* Phase 3: Dashboard & Data Visualization
* Phase 4: PDF Export Reports

---

## 🧠 Summary

This project demonstrates how a Ruby on Rails application connects to a MySQL database using ActiveRecord. It follows the MVC architecture, secures user data using BCrypt hashing, and provides a responsive user interface.

---
