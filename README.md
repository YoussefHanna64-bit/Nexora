# Nexora

Nexora is an e-commerce mobile application built with Flutter, focusing on clean architecture, BLoC state management, Stripe payments, and Google Sign-In. Engineered entirely during the limited free time outside of the rigorous ITI 9-Month training program, this project was built to turn everything learned into a complete, full-stack ecosystem.

## Features

- **Authentication & Account Recovery** — Secure login and signup flows using Email/Password and Google Sign-In, backed by JWT tokens. It also includes a Forgot Password flow via email.
- **Search & Filtering** — Browse products easily with dynamic search, category filtering, and sorting options built into clean bottom-sheet UIs.
- **Order & Address Management** — Users can save and manage multiple shipping addresses, view their full order history, and track order statuses. The backend automatically sends email confirmations when a new order is placed.
- **Verified Reviews** — Users can leave ratings and reviews, but strictly only for products they have successfully purchased.
- **Cart & Checkout via Stripe** — Add items to the cart and securely process payments using the Stripe Payment Sheet (test mode).
- **In-App Bug Reporting** — Users can submit feedback and report bugs directly from the app, which saves the data to the Node.js/MongoDB backend.
- **Localization (English & Arabic)** — Full support for both languages using Flutter's `l10n`, including proper Right-to-Left (RTL) layout for Arabic.

## Project Demo

Watch the full demo video here:

```text
https://drive.google.com/file/d/1J3UrLUhoGjDxDvQaZjxyJWjJRcd_QUro
```

## Tech Stack & Architecture

| Category | Technology |
| :--- | :--- |
| Frontend | Flutter (Clean Architecture — Domain, Data, Presentation layers) |
| State Management | BLoC / Cubit |
| Routing | GoRouter |
| Backend | Node.js / Express (50+ RESTful endpoints) |
| Database | MongoDB (via Mongoose) |
| Integrations | Stripe Payment Gateway, Google Sign-In, JWT Authentication, Cloudinary |

## Setup & Installation

```bash
# 1. Clone the repository and install dependencies

git clone <repo-url>
cd Nexora

# --- Flutter (Mobile) ---
cd Mobile
flutter pub get

# Generate environment variable accessors (envied)
dart run build_runner build --delete-conflicting-outputs

# Configure environment variables
# Copy the example env file and fill in your credentials
# cp .env.example .env

# --- Backend (Node.js) ---
cd ../Backend
npm install

# Configure environment variables
# cp .env.example .env
# Fill in: MONGODB_URI, JWT_SECRET, STRIPE_SECRET_KEY, GOOGLE_CLIENT_ID, CLOUDINARY_* keys

# 2. Run the application

# Start the backend server (development mode with hot-reload)
cd Backend
npm run dev

# In a separate terminal, run the Flutter app
cd Mobile
flutter run
```
