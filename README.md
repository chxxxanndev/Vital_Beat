# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...









# HRLsys - Heart Rate Log System (v1.0)

## 📋 Project Overview
HRLsys is a web-based health monitoring application built to help users track and analyze their heart rate data. This milestone focuses on the **Authentication Gateway**, providing a secure and modern user experience for registration and login.

## 🛠 Tech Stack
*   **Backend:** Ruby (3.x)
*   **Framework:** Ruby on Rails (7.x)
*   **Database:** MySQL 8.0
*   **Authentication:** Custom implementation using `has_secure_password` and BCrypt.
*   **Frontend UI:** 
    *   Bootstrap 5 (Layout & Components)
    *   FontAwesome 6 (Icons)
    *   Animate.css (Entry animations & feedback)
    *   Hotwire/Turbo (Fast, asynchronous page updates)

## 🔐 Key Features & Security
1.  **Split-Screen Design:** A modern 60/40 visual layout with branding on the left and interactive forms on the right.
2.  **Secure Hashing:** Utilizes the BCrypt algorithm to hash and salt passwords, ensuring that plain-text credentials are never stored in the database.
3.  **Real-time Validations:** Uses Rails model-level validations (presence, uniqueness, and length) with Turbo-powered feedback to prevent page reloads during errors.
4.  **Session Management:** Secure server-side session handling to manage user persistence.

## 🏗 System Architecture (MVC)
*   **Models:** 
    *   `User`: Manages business logic, password encryption, and database interactions.
*   **Views:** 
    *   `users/new`: Animated split-screen registration form.
    *   `sessions/new`: Animated split-screen login form.
    *   `layouts/application`: Global wrapper providing responsive CSS and icons.
*   **Controllers:** 
    *   `UsersController`: Handles the logic for creating new user accounts.
    *   `SessionsController`: Handles the logic for logging in, validating credentials, and logging out.

## 🚀 Local Setup Instructions
1.  **Clone/Open Project**
2.  **Install Dependencies:**
    ```bash
    bundle install
    ```
3.  **Database Configuration:**
    Ensure `config/database.yml` is updated with your MySQL credentials.
4.  **Migrate Database:**
    ```bash
    rails db:create
    rails db:migrate
    ```
5.  **Start Server:**
    ```bash
    rails server
    ```
6.  **Access App:** Navigate to `http://localhost:3000/signup`.


Phase 1 (Done): Secure Authentication & Split-Screen UI.
Phase 2 (Next): Create the HeartRateLog model and migration.
Phase 3: Build the Dashboard with Charts and Color-coding.
Phase 4: Add Export-to-PDF functionality for medical reports.


1. How the Database Connection works:
The File: config/database.yml
What to say: "We use the mysql2 adapter to bridge the Ruby code with our MySQL server. Rails automatically manages the connection pool to ensure efficiency."
2. The "Secret" of Password Security:
The Logic: has_secure_password in the User model.
What to say: "We don't store passwords. We store a password_digest. When a user signs up, the BCrypt gem takes the password, adds a random 'salt,' and hashes it. During login, the .authenticate method hashes the input and compares it to the digest in the database."
3. Why the page doesn't fully refresh (Turbo):
The Logic: status: :unprocessable_entity in the controller.
What to say: "By returning a 422 status code, we allow Turbo (part of the Hotwire suite) to catch the error and re-render the form. This keeps the split-screen layout intact and maintains the 'Single Page Application' feel."
4. The Animation Logic:
The Library: Animate.css.
What to say: "I used CSS classes like animate__fadeInLeft for the entrance. For error handling, I added animate__shakeX to provide a visual cue to the user when validation fails, which is a standard UI pattern for 'incorrect input'."
5. Ruby vs. Rails:
What to say: "Ruby is the object-oriented programming language. Rails is the web framework built on top of it. Rails provides the 'Rails' (structure) so I can focus on building the Heart Rate logic instead of reinventing the wheel for things like routing and database connections."

"I used a Model-View-Controller (MVC) architecture with a MySQL backend, secured the passwords using BCrypt hashing, and implemented a responsive UI using Bootstrap components."
