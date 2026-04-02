# Alisons E-Commerce App

A complete Flutter e-commerce mobile application based on Figma designs, integrating RESTful APIs for user authentication, product listings, details, and cart functionality.

## Flutter Version Used
- **Flutter:** `3.41.0` (Stable channel)
- **Dart:** `3.11.0`

## Steps To Run The Project

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ajay-krishna-a-p/alisons-app.git
   cd alisons-app
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the Application:**
   - For **macOS natively** (Recommended for Apple Silicon):
     ```bash
     flutter run -d macos
     ```
   - For **Android or iOS Emulator**:
     ```bash
     flutter run
     ```
   - For **Google Chrome** (requires disabling CORS security locally to hit external APIs without CORS setup):
     ```bash
     flutter run -d chrome --web-browser-flag "--disable-web-security"
     ```

## State Management Used
- **`Provider`** (`package:provider`)
  Used a centralized `AppProvider` (`ChangeNotifier`) approach because it perfectly fits the scope of a simplistic e-commerce app handling user cart lifecycle and dynamic HTTP JSON lists cleanly, prioritizing readability over-engineering.

## Assumptions Made
- **Authentication**: Instead of strictly hardcoding the expired testing `token` (`ah5Ddu...`), the application was made more robust by consuming the live `POST /login` API securely with the validated testing credentials (`mobile@alisonsgroup.com` / `12345678`) to actively fetch a fully valid `token` and `id` instance before dashboard loading.
- **API Payloads**: For the Product list, the `categorySlug` defaults gracefully to ensure content renders seamlessly even if categories lack backend products.
- **Cart Management**: The cart acts within short-term memory scope (`Provider`). Restarting the application resets the local state as no local databases (e.g., Hive or SQLite) were definitively required.
- **Routing**: Employs standard `Navigator.push` patterns since deep linking or complex `go_router` logic wasn't necessitated for this specific scope.

## Known Issues / Limitations
- **API Server CORS Restriction**: The `sungod.demospro2023.in.net` APIs restrict standard Chrome requests by lacking `Access-Control-Allow-Origin` headers. You must explicitly bypass Chrome security via CLI (shown in the setup steps) if testing purely on Flutter Web.
- **iOS Simulator Bug**: Depending on your direct Xcode Installation structure, newer Simulators (e.g., `iPhone 16e` via `iOS 18+`) might flag `Unable to find a destination matching the provided destination specifier` error. Compiling code as `MacOS` natively bypasses these temporary local Xcode indexing bugs wonderfully.
