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



## 📂 Project Structure

VitalBeat follows the standard **Model-View-Controller (MVC)** architecture provided by Ruby on Rails 7.

```text
VitalBeat/
├── app/
│   ├── assets/              # Frontend assets (Images & CSS)
│   │   ├── images
│   │   └── stylesheets/     # Custom CSS for split-screen & dashboard
│   ├── controllers/         # The logic/brains of the application.
│   │   ├── concerns
│   │   ├── application_controller.rb
│   │   ├── password_resets_controller.rb
│   │   ├── home_controller.rb
│   │   ├── sessions_controller.rb
│   │   └── users_controller.rb
│   ├── helpers/         
│   │   ├── application_helper.rb
│   │   ├── home_helper.rb
│   │   ├── sessions_helper.rb
│   │   └── users_helper.rb
│   ├── jobs/         
│   │   └── application_job.rb
│   ├── mailers/         
│   │   └── application_mailer.rb
│   ├── models/              # Database blueprints and validations
│   │   ├── concerns
│   │   ├── application_record.rb
│   │   └── user.rb          # Logic for BCrypt secure passwords
│   └── views/               # The User Interface (HTML.ERB)
│       ├── home/            # Dashboard view
│       │   └── index.html.erb 
│       ├── layouts/         # Global application shell (Head & Navbar)
│       │   ├── application.html.erb
│       │   ├── mailer.html.erb
│       │   └── mailer.text.erb
│       ├── password_resets
│       │   ├── edit.html.erb
│       │   └── new.html.erb
│       ├── pwa
│       │   ├── manifest.json.erb
│       │   └── service-worker.js
│       ├── sessions/        # Login interface
│       │   ├── create.html.erb
│       │   ├── destroy.html.erb
│       │   └── new.html.erb
│       └── users/           # Registration interface
│           ├── create.html.erb
│           └── new.html.erb
├── bin/                     # Application executable scripts
├── config/                  # Core settings
│   ├── environments/
│   ├── initializers/
│   ├── locales/
│   ├── database.yml         # MySQL connection settings
│   └── routes.rb            # URL-to-Logic mapping (The "Traffic Cop")
├── db/                      # Database files
│   ├── migrate/             # History of table changes
│   ├── seeds.rb
│   └── schema.rb            # Current snapshot of MySQL structure
├── lib/
├── public/                  # Static files (Icons & Error pages)
├── script/
├── storage/
├── test/
├── Gemfile                  # List of project dependencies (Bcrypt, Rails, etc.)
├── README.md                # Project documentation
├── .ruby-version            # Ruby environment specification
└── Dockerfile               # Production deployment blueprint


The folders you actively work in (important ✅)

app/controllers/ — this is where your logic lives. Every action (login, signup, show page) is handled here. As you add heart rates, you'll add heart_rates_controller.rb here.
app/models/ — your database blueprints. You have user.rb now, and you'll add heart_rate.rb soon.
app/views/ — all your HTML/ERB files. What the user actually sees. You'll add a heart_rates/ folder here.
app/assets/stylesheets/ — your CSS lives here. This is the application.css you've been editing.
config/routes.rb — the "traffic cop." Every URL in your app is defined here. Important to keep clean.
db/migrate/ — history of all your database changes. Never delete these, your instructor will likely check this.
db/schema.rb — auto-generated snapshot of your current database. Never manually edit this.
Gemfile — your dependencies list. BCrypt, Rails, MySQL adapter are all listed here.

Folders you don't touch much but should keep 🟡
config/database.yml — your MySQL connection settings. Keep it but don't share it publicly.
config/environments/ — settings for development vs production. Leave as is.
public/ — error pages (404, 500) live here. Keep them.
bin/ — Rails executable scripts. Never touch these.

Files/folders safe to ignore or delete for cleanliness 🗑️
app/helpers/ — home_helper.rb, sessions_helper.rb, users_helper.rb are all empty by default and do nothing. You can delete all except application_helper.rb unless you've added code in them.
app/jobs/application_job.rb — for background jobs like sending emails asynchronously. Not needed for your project at this stage.
app/mailers/application_mailer.rb — for sending emails. You have a password_resets_controller.rb so if password reset emails aren't working yet, this is unused. Safe to leave but not critical.
lib/ — empty in most beginner Rails projects. Safe to leave empty.
storage/ — used for file uploads (like profile pictures). Not needed for a heart rate log.
script/ — usually empty. Safe to ignore.
test/ — for automated tests. Your instructor may not require this, but don't delete it as Rails expects it to exist.
Dockerfile — only needed for deployment to a server. Not needed for a local demo tomorrow. Safe to ignore.
.ruby-version — just specifies which Ruby version to use. Keep it, it's tiny and harmless.



That is a very observant question. Including a separate User_Profiles table is a
professional best practice in database design, especially for health apps.

Here is why it is there and how to explain it to your instructor:

1. The Principle of Separation (Identity vs. Metadata)

In high-level systems, we try to keep the Users table "lean and clean."

  - The Users table is for Identity: (Email and Password). Its only job is to
    let the person into the building.
  - The User_Profiles table is for Metadata: (Full Name, Age, Weight, Gender,
    Height). Its job is to describe the person.

2. Why is this important for VitalBeat?

To do the "Smart Math" we talked about (like calculating the Maximum Heart
Rate), the system needs the user's Age.

If you put the age, weight, and bio in the Users table, that table becomes very
"heavy" and slower to search. By putting that info in a Profiles table, you
ensure that:

1.  Security is tighter: Sensitive medical metadata (age/weight) is stored
    separately from the login credentials.
2.  Performance is better: When Rails is just checking a password, it doesn't
    have to load all the health data into memory.

3. The Relationship

In the next phase of your project, you would tell Rails:

"A User has_one Profile."

🛡️ How to explain it in your Defense:

If the instructor points to that box and asks, "Why do you have a separate
Profiles table?"

Your Best Answer:

"I’ve included a separate User_Profiles table to follow the principle of Data
Normalization. By separating core authentication data (Email/Password) from
personal health metadata (Age/Weight), we improve both the security and the
performance of the system. This architecture allows us to scale the 'Health
Profile' module in the future without cluttering the primary identity table."

💡 Pro-Tip:

Even if you haven't built the User_Profiles table in MySQL yet, keeping it in
the diagram shows you are thinking like an Architect. It shows you have a plan
for where to store the user's Age and Weight once you start doing the Heart Rate
Zone calculations.

It’s a "future-proof" design choice that makes you look very smart! 🚀🔥
