# Capyapy Dashboard

A modern Flutter web dashboard for managing mock API projects, data models, endpoints, and billing.
Built with GoRouter for navigation and BLoC for state management.

## Backend Status

Currently, the backend is in development using Spring Boot and will be available soon.

## Features

- Responsive dashboard UI for desktop and mobile
- Project management: create, view, edit, delete projects
- Data models and endpoints management
- Billing and settings pages
- Sidebar navigation (desktop)
- GoRouter-based navigation
- BLoC state management

## Screenshots

<!-- Add screenshots here -->

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (3.x or later)
- Dart SDK

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/capyapy_dashboard.git
   cd capyapy_dashboard
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

To run the app locally:

```bash
flutter run -d chrome
```

## Project Structure

```
lib/
  core/         # App-wide constants, router, theme, utils
  data/         # Models, datasources, repositories
  domain/       # Entities, repositories, usecases
  presentation/ # UI pages, widgets, BLoC
  main.dart     # App entry point
```

## Navigation

- Uses [GoRouter](https://pub.dev/packages/go_router) for declarative routing
- Example route: `/project/:id` for project details
- Sidebar navigation for desktop, tab navigation for mobile

## State Management

- Uses [flutter_bloc](https://pub.dev/packages/flutter_bloc) for managing state
- Each major feature (dashboard, projects, project details) has its own BLoC

## Screenshots

<img src="screenshots/dashboard_01.png" width="500" />
<img src="screenshots/dashboard_02.png" width="500" />
<img src="screenshots/projects_01.png" width="500" />
<img src="screenshots/projects_02.png" width="500" />
<img src="screenshots/projects_create_01.png" width="500" />
<img src="screenshots/projects_create_02.png" width="500" />
<img src="screenshots/projects_create_03.png" width="500" />
<img src="screenshots/projects_create_04.png" width="500" />
<img src="screenshots/projects_create_05.png" width="500" />
<img src="screenshots/projects_dashboard_01.png" width="500" />
<img src="screenshots/projects_data_models_01.png" width="500" />
<img src="screenshots/projects_data_models_02.png" width="500" />
<img src="screenshots/projects_data_models_edit_add_01.png" width="500" />
<img src="screenshots/projects_endpoints_01.png" width="500" />
<img src="screenshots/projects_endpoints_add_edit_01.png" width="500" />
<img src="screenshots/projects_endpoints_stats_01.png" width="500" />
<img src="screenshots/projects_settings_01.png" width="500" />
<img src="screenshots/projects_settings_02.png" width="500" />
<img src="screenshots/billing_01.png" width="500" />
<img src="screenshots/billing_02.png" width="500" />
<img src="screenshots/settings_01.png" width="500" />
<img src="screenshots/settings_02.png" width="500" />

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would
like to change.

## License

[MIT](LICENSE.md)

## Contact

will make it available soon!!!!
