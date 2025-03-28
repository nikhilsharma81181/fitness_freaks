# Core Module

The `core` module contains fundamental code that is used throughout the application, providing a foundation for the rest of the codebase. This module implements common functionality, utilities, and infrastructure that is shared between different features.

## Structure

The Core module is organized into the following directories:

```
lib/core/
│
├── adapters/          - Type adapters for data conversion
├── constants/         - App-wide constants like colors, endpoints, and themes
├── data/              - Data layer with exceptions and interfaces
│   ├── datasources/   - Data source interfaces (local and remote)
│   ├── exceptions.dart - Common exceptions
│   └── repositories/  - Base repository interfaces
│
├── di/                - Dependency injection setup
├── domain/            - Domain layer with entities and use cases
│   ├── entities/      - Core domain entities
│   ├── failures/      - Failure classes for domain error handling
│   └── usecases/      - Base use case interfaces
│
├── infrastructure/    - Infrastructure implementations
│   ├── local_storage/ - Storage implementations
│   ├── network/       - Network clients and implementations
│   └── services/      - Core services like logging
│
├── presentation/      - Shared UI components
│   ├── hooks/         - Custom Flutter Hooks
│   ├── providers/     - Riverpod providers
│   └── widgets/       - Reusable widgets
│
└── utils/             - Utility functions and helpers
```

## Key Components

### Constants

- **`colors.dart`**: Defines the application color palette as used throughout the app
- **`endpoints.dart`**: Contains API endpoints and URLs
- **`theme.dart`**: Defines app-wide theming including light and dark themes

### Data Layer

- **`datasources/local/local_storage.dart`**: Defines interfaces for local storage operations
- **`datasources/remote/http_client.dart`**: Defines interface for HTTP client operations
- **`datasources/remote/interceptors.dart`**: Defines interceptors for HTTP requests/responses
- **`datasources/remote/network_info.dart`**: Interface for network connectivity information
- **`exceptions.dart`**: Common exceptions throughout the app (e.g., ServerException, CacheException)

### Domain Layer

- **`entities/either.dart`**: Implementation of Either pattern for error handling
- **`failures/failure.dart`**: Base failure classes for error handling in the domain layer
- **`usecases/usecase.dart`**: Base use case interfaces for standardizing business logic

### Infrastructure Layer

- **`local_storage/storage_encryption.dart`**: Provides encryption for sensitive stored data
- **`local_storage/hive_storage.dart`**: Basic in-memory storage implementation
- **`network/dio_client.dart`**: Dio implementation of the HttpClient interface
- **`network/network_info_impl.dart`**: Implementation for checking network connectivity
- **`services/logger_service.dart`**: Logging service for debugging and monitoring

### Presentation Layer

- **`hooks/async_value_hook.dart`**: Custom hook for handling AsyncValue states
- **`hooks/lifecycle_hook.dart`**: Hook for app lifecycle management
- **`providers/base_notifiers.dart`**: Base state notifier classes for Riverpod
- **`widgets/`**: Reusable widgets like loading indicators, error displays, etc.

### DI (Dependency Injection)

- **`providers.dart`**: Central provider definitions for dependency injection
- **`provider_config.dart`**: Configuration for providers

### Utils

- **`image_compressor.dart`**: Utility for compressing images before upload

## Design Patterns & Architecture

### Dependency Injection

The core module uses Riverpod for dependency injection. The `di` directory contains provider definitions that instantiate and manage dependencies throughout the app.

Key providers include:
- `sharedPreferencesProvider`: For local storage access
- `connectivityProvider`: For network connectivity checking
- `httpClientProvider`: For making HTTP requests
- `localStorageProvider`: For persistent storage

### Repository Pattern

The core module defines the Repository pattern infrastructure:
- Repository interfaces in `data/repositories/`
- Data source interfaces in `data/datasources/`

This pattern separates the data layer from the domain layer, allowing for clean architecture.

### Error Handling

The core module implements a functional approach to error handling:
- Using the `Either` type to represent success/failure
- Domain failures extending from the base `Failure` class
- Data-layer exceptions extending from common exception types

### State Management

Base state management classes in `presentation/providers/base_notifiers.dart`:
- `BaseStateNotifier`: Handles loading, success, and error states
- `PaginatedStateNotifier`: Adds pagination functionality
- `SyncableStateNotifier`: Adds offline-first functionality with sync capabilities

### Interceptors

The HTTP client implementations support interceptors for:
- Request modification
- Response modification
- Error handling

## Usage

Import the core module to access its functionality:

```dart
import 'package:fitness_freaks/core/core.dart';
```

This gives you access to all the exported components of the core module.

## Dependencies

The core module depends on:
- `hooks_riverpod` and `flutter_hooks` for state management
- `dio` for HTTP requests
- `connectivity_plus` for network connectivity
- `shared_preferences` for local storage
- Various Flutter packages for UI components

## Extending the Core Module

When adding new functionality to the core module:

1. Determine if it belongs in the core module (is it used by multiple features?)
2. Place it in the appropriate directory based on its responsibility
3. Follow the established patterns and naming conventions
4. Update this README if adding significant new capabilities

## Feature Interaction

Feature modules should:
- Depend on the core module, not the other way around
- Implement interfaces defined in the core module
- Use the dependency injection system defined in the core module
