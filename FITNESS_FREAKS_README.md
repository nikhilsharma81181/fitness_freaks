# Fitness Freaks - Flutter App

A fitness tracking application built with Flutter 3.29.2 using clean architecture, hooks_riverpod for state management, and Hive for local caching.

## Features Implemented

### Home Page

- Main wrapper for navigation
- Glass-like UI design with vibrant gradient backgrounds
- Custom tab bar navigation
- Workout progress card
- Weight tracking feature with graph visualization
- Activity metrics cards

### Weight Tracking

- Display weight history with line chart visualization
- Add weight entries via camera or manual input
- Image processing to extract weight from scale images
- Sync with backend
- Local caching for offline use
- Weight statistics (current, average, highest, lowest)
- Weight detail page with filtering and sorting options

### Profile Page

- User information display
- Profile photo management
- Activity statistics
- Settings options

## Project Structure

The project follows a clean architecture approach with the following structure:

```
lib/
├── core/                 # Core functionality
│   ├── constants/        # App constants (colors, endpoints)
│   ├── data/             # Base data layer components
│   ├── error/            # Error handling
│   ├── network/          # Network components
│   ├── presentation/     # Shared UI components
│   ├── storage/          # Local storage utilities
│   └── utils/            # Utility functions
│
├── features/
│   ├── auth/             # Authentication feature
│   ├── home/             # Home page and navigation
│   │   ├── presentation/
│   │       ├── pages/
│   │       │   ├── home_page.dart
│   │       │   └── main_wrapper.dart
│   │       └── widgets/
│   │           ├── app_tab_bar.dart
│   │           ├── background_gradient.dart
│   │           ├── glass_card.dart
│   │           ├── graph_metrics_view.dart
│   │           └── workout_progress_card.dart
│   │
│   ├── profile/          # User profile
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── profile_page.dart
│   │       └── widgets/
│   │           ├── profile_header.dart
│   │           ├── profile_menu_item.dart
│   │           └── profile_stats_card.dart
│   │
│   ├── user/             # User data management
│   │
│   └── weight/           # Weight tracking feature
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── pages/
│           │   └── weight_detail_page.dart
│           ├── providers/
│           │   ├── weight_notifier.dart
│           │   ├── weight_providers.dart
│           │   └── weight_state.dart
│           └── widgets/
│               ├── line_chart.dart
│               └── weight_tracking_view.dart
│
└── main.dart
```

## State Management

The application uses hooks_riverpod for state management with the following pattern:

1. **Entities**: Define the domain objects
2. **Repositories**: Define interfaces for data operations
3. **UseCases**: Implement business logic
4. **Providers**: Create and manage application state
5. **UI Components**: Consume providers and display data

## Design Features

- Custom glass-card UI with frosted effect
- Dynamic gradients based on selected tab
- Animated charts and transitions
- Responsive layout with smooth animations
- Dark theme optimized for fitness apps

## Setup Instructions

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Dependencies

- flutter_hooks: For lifecycle management and state management utilities
- hooks_riverpod: For state management
- hive/hive_flutter: For local data persistence
- fl_chart: For graph visualization
- intl: For date and number formatting
- image_picker: For camera integration

## Next Steps

1. Complete the fitness tracking feature
2. Implement workout plans and routines
3. Add social sharing capabilities
4. Enhance offline support
