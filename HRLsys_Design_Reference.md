# HRLsys — Full System Design Reference
> VitalBeat / Heart Rate Log System — complete design notes for submission

---

## 🏷 System Identity

- **Project name:** HRLsys (VitalBeat)
- **Type:** Web-based health monitoring application
- **Purpose:** More than a diary — patients input BPM readings and the system interprets them against medical standards. Admins oversee the entire user population.
- **Core concept:**
  - **Patient flow:** Input → Analysis → Visualization
  - **Admin flow:** Observation → Management

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Language | Ruby 3.x |
| Framework | Ruby on Rails 7 |
| Database | MySQL 8.0 |
| Authentication | Custom — `has_secure_password` + BCrypt |
| Frontend | Bootstrap 5, FontAwesome 6, Animate.css |
| Async updates | Hotwire / Turbo (no full page reloads) |
| Charts | Chartkick + Groupdate |
| PDF export | Prawn gem |
| Pagination | Kaminari gem |

---

## 👤 User Roles

### Patient
A registered individual who tracks their own heart rate data.

- Register an account
- Log in / log out
- Log a BPM reading (with date, time, optional notes)
- View their full log history (color-coded by status)
- Edit or delete a log entry
- View BPM analysis — MHR calculation + zone classification
- View health trend chart (BPM over time)
- Export a PDF medical report of their logs

### Admin (Health Administrator)
A privileged user who oversees the entire system. Does **not** log their own BPM. Acts as a system-level health administrator.

- Log in to the admin panel (`/admin`)
- View all registered users (name, last log, status)
- View any patient's full log history (read-only)
- Activate or suspend a user account
- Delete a user account
- Export any patient's PDF report
- Log out

---

## 🗂 Database Schema (MySQL 8.0)

### Table: `users`
| Column | Type | Notes |
|---|---|---|
| id | int | Primary Key |
| name | string | |
| email | string | unique |
| password_digest | string | BCrypt hash — never plain text |
| role | string | `"patient"` or `"admin"` |
| age | int | used for MHR calculation |
| active | boolean | default: true — admin can deactivate |
| created_at | datetime | |
| updated_at | datetime | |

### Table: `heart_rate_logs`
| Column | Type | Notes |
|---|---|---|
| id | int | Primary Key |
| user_id | int | Foreign Key → users.id |
| bpm | int | the heart rate reading |
| mhr_percentage | float | % of Maximum Heart Rate |
| status | string | `"normal"`, `"high"`, `"low"` |
| zone | string | `"rest"`, `"fat_burn"`, `"cardio"`, `"peak"`, `"danger"` |
| recorded_at | datetime | when the reading was taken |
| notes | text | optional patient note |
| created_at | datetime | |
| updated_at | datetime | |

### Relationships
```
users         ||--o{   heart_rate_logs   : "has many"
heart_rate_logs  }o--||   users           : "belongs to"
```
- One user has many heart rate logs
- Each heart rate log belongs to one user
- No alerts table (feature removed — kept as future enhancement)

---

## 🏗 System Architecture (MVC Layers)

```
PRESENTATION LAYER (Browser)
├── Bootstrap 5 — layout and components
├── FontAwesome 6 — icons
├── Animate.css — fadeInLeft, shakeX on errors
└── Hotwire/Turbo — no full page reloads on form errors

        ↓ HTTP Request          ↑ HTTP Response

APPLICATION LAYER (Ruby on Rails 7)
├── config/routes.rb — URL traffic cop
│   ├── resources :heart_rate_logs
│   ├── resource  :session
│   ├── resources :users
│   └── namespace :admin { resources :users, :heart_rate_logs }
│
├── Controllers
│   ├── UsersController         — register new account
│   ├── SessionsController      — login, logout
│   ├── HeartRateLogsController — full CRUD for BPM entries
│   ├── HomeController          — patient dashboard
│   └── Admin::DashboardController — admin panel
│
├── Models (ActiveRecord + Business Logic)
│   ├── User              — BCrypt, role, age, active flag
│   └── HeartRateLog      — MHR calc, BPM classifier, zone logic
│
└── Views (ERB Templates)
    ├── Patient dashboard — log history table, trend chart
    ├── Auth views        — split-screen login / register
    └── Admin panel       — user list, manage access

        ↓ SQL Queries           ↑ Query Results

DATA LAYER
└── MySQL 8.0 — users table, heart_rate_logs table
```

---

## ⚙️ Analysis Engine (what makes it more than a diary)

Every BPM entry is passed through analysis logic inside the `HeartRateLog` model before being saved.

### Maximum Heart Rate (MHR) Formula
```ruby
mhr = 220 - user.age
mhr_percentage = (bpm / mhr.to_f * 100).round(1)
```

### BPM Status Classification
| Status | Condition |
|---|---|
| `low` | BPM < 60 (bradycardia) |
| `normal` | BPM 60–100 |
| `high` | BPM > 100 (tachycardia) |

### Heart Rate Zones (% of MHR)
| Zone | % of MHR |
|---|---|
| Rest | < 50% |
| Fat Burn | 50–59% |
| Cardio | 60–69% |
| Peak | 70–84% |
| Danger | 85%+ |

---

## 🔐 Authentication & Security

- Passwords are **never stored** in plain text
- `has_secure_password` in the `User` model uses BCrypt to hash and salt the password into `password_digest`
- On login, `.authenticate(password)` hashes the input and compares it to the stored digest
- Sessions are managed server-side via `session[:user_id]`
- On validation errors, Rails returns `status: :unprocessable_entity` (422) so Turbo re-renders the form without a full page reload — keeping the split-screen layout intact
- Admin routes are protected by `before_action :require_admin!` in every admin controller

---

## ✅ Full CRUD Map

### Patient — HeartRateLogsController
| CRUD | HTTP | URL | Action | What it does |
|---|---|---|---|---|
| Create | GET | `/heart_rate_logs/new` | `new` | Show log form |
| Create | POST | `/heart_rate_logs` | `create` | Save BPM entry |
| Read | GET | `/heart_rate_logs` | `index` | All my logs + chart |
| Read | GET | `/heart_rate_logs/:id` | `show` | Single log detail |
| Update | GET | `/heart_rate_logs/:id/edit` | `edit` | Edit log form |
| Update | PATCH | `/heart_rate_logs/:id` | `update` | Save changes |
| Delete | DELETE | `/heart_rate_logs/:id` | `destroy` | Remove log entry |

### Admin — Admin::UsersController
| CRUD | HTTP | URL | Action | What it does |
|---|---|---|---|---|
| Read | GET | `/admin/users` | `index` | All users list |
| Read | GET | `/admin/users/:id` | `show` | User + their logs |
| Update | GET | `/admin/users/:id/edit` | `edit` | Edit user form |
| Update | PATCH | `/admin/users/:id` | `update` | Activate / suspend |
| Delete | DELETE | `/admin/users/:id` | `destroy` | Remove user account |

> `resources :heart_rate_logs` generates all 7 patient actions automatically.
> `namespace :admin { resources :users }` generates all admin actions automatically.

---

## 📋 Use Case Summary

| Use Case | Patient | Admin |
|---|---|---|
| Register Account | ✅ | ❌ |
| Login | ✅ | ✅ |
| Log BPM Reading | ✅ | ❌ |
| View Log History | ✅ | ✅ read-only |
| Edit / Delete Log | ✅ | ❌ |
| View BPM Analysis (MHR + Zone) | ✅ | ❌ |
| View Health Trend Chart | ✅ | ❌ |
| Export PDF Report | ✅ | ✅ |
| Manage Users (activate/suspend/delete) | ❌ | ✅ |
| Logout | ✅ | ✅ |

---

## 📦 Gems List

| Gem | Purpose | Difficulty |
|---|---|---|
| `bcrypt` | Password hashing | Already done ✅ |
| `mysql2` | MySQL adapter | Already done ✅ |
| `chartkick` | Trend line charts | Easy — 1 line in view |
| `groupdate` | Group logs by day/week | Easy — pairs with chartkick |
| `prawn` | PDF generation | Moderate — learnable |
| `prawn-table` | Tables inside PDF | Moderate — pairs with prawn |
| `kaminari` | Pagination | Easy — 1 line per model |

---

## 🚀 Development Phases

### Phase 1 — ✅ DONE
- Secure authentication (BCrypt + `has_secure_password`)
- Split-screen login and registration UI
- Turbo-powered form error re-rendering (422 status)
- Session management (`session[:user_id]`)
- Animate.css entry animations + shakeX on errors

### Phase 2 — Next
- `HeartRateLog` model + migration
- MHR calculation + BPM zone classification in model
- Full CRUD controller (`HeartRateLogsController`)
- ERB views: new log form, log history table (color-coded by status)

### Phase 3 — Dashboard
- `HomeController` with patient dashboard
- Chartkick line chart (average BPM per day)
- Color-coded log history table (green/yellow/red by status)
- MHR zone badge shown per entry

### Phase 4 — Reports + Admin
- PDF export using Prawn (full log history, avg BPM, zones)
- Admin namespace + `Admin::DashboardController`
- Admin user list — view all patients, activate/suspend/delete
- Admin read-only view of any patient's log history

### Future Enhancements (not in scope)
- Email alerts via Action Mailer
- Real-time BPM updates via Action Cable / WebSockets
- Population-level trend analytics
- Doctor/nurse role

---

## 📂 Key Files to Work In

| File/Folder | What it's for |
|---|---|
| `app/controllers/heart_rate_logs_controller.rb` | Main CRUD logic |
| `app/controllers/admin/dashboard_controller.rb` | Admin panel logic |
| `app/models/heart_rate_log.rb` | MHR calc, zone, status |
| `app/models/user.rb` | BCrypt, role, validations |
| `app/views/heart_rate_logs/` | All patient-facing views |
| `app/views/admin/` | All admin views |
| `app/assets/stylesheets/` | CSS for color-coding |
| `config/routes.rb` | All URL definitions |
| `db/migrate/` | Never delete these |
| `db/schema.rb` | Never manually edit |
| `Gemfile` | Add chartkick, prawn, kaminari here |

---

## 💬 Key phrases to say to your instructor

> *"The system doesn't just store data — it interprets it. A patient logs a BPM, the system computes their percentage of Maximum Heart Rate, classifies their cardiovascular zone, and color-codes the result. The Admin observes this data at the population level and manages access — they're a Health Administrator, not just a site manager."*

> *"I used a Model-View-Controller architecture with a MySQL backend, secured passwords using BCrypt hashing, and implemented a responsive UI using Bootstrap 5 with Turbo-powered form feedback."*

> *"The 422 status code allows Turbo to catch validation errors and re-render the form without a full page reload, keeping the split-screen layout intact — this is a standard SPA pattern."*

> *"We don't store passwords. We store a password_digest. BCrypt adds a random salt and hashes it. During login, .authenticate() hashes the input and compares it to the digest."*
