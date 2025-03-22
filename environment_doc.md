# Flutter Environment Setup and Configuration Documentation

This document provides a detailed explanation of how the Flutter environment is set up and configured in this project, along with how the Fitness Freaks application accesses and utilizes these configurations.

## Table of Contents

1. [Flutter Version Management (FVM)](#flutter-version-management-fvm)
2. [Project Structure](#project-structure)
3. [Clean Architecture Implementation](#clean-architecture-implementation)
4. [iOS-First Design Approach](#ios-first-design-approach)
5. [Dependency Management](#dependency-management)
6. [Platform-Specific Configurations](#platform-specific-configurations)
7. [Disk Space Optimization](#disk-space-optimization)
8. [Development Workflow](#development-workflow)
9. [Setup Process for This Project](#setup-process-for-this-project)

## Flutter Version Management (FVM)

Flutter Version Management (FVM) is used to manage multiple Flutter SDK versions on a per-project basis. This ensures consistent development environments across team members and allows working on multiple projects with different Flutter version requirements.

### Isolated Environment Configuration

One of the key advantages of our setup is that **the entire Flutter environment is contained within this project folder**. This ensures:

1. **Complete Portability**: The project can be moved to a different drive or machine while maintaining all configurations. This is particularly useful for team members who may switch between devices or for backup purposes.

2. **No Global Flutter Installation Required**: New team members don't need a pre-existing Flutter setup. They can simply clone the repository and start working without worrying about Flutter version mismatches.

3. **External Storage Compatibility**: All Flutter operations run from the external SSD without requiring internal disk space. This is crucial for developers with limited internal storage, allowing them to work efficiently without running into disk space issues.

4. **Independence from Global Flutter Installations**: Updates to system-wide Flutter won't affect this project. This means that if a new version of Flutter is released, it won't disrupt ongoing development work.

### How FVM is Configured

- FVM is installed within the project via: `dart pub global activate fvm`
- Project-specific Flutter version is set using: `fvm use stable`
- All Flutter commands are executed through FVM to ensure the correct version is used: `fvm flutter <command>`
- The FVM config file `.fvm/fvm_config.json` tracks which Flutter version is being used

### FVM Directory Structure

```
Flutter Latest Env Projects/
├── .fvm/
│   ├── flutter_sdk/ -> symlink to cached Flutter SDK
│   └── fvm_config.json
├── environment/
│   └── ... (environment-specific configuration files)
├── fvm/
│   └── versions/
│       └── stable/ (actual Flutter SDK files)
└── fitness_freaks/
    └── ... (project files)
```

The critical aspect of this setup is that all Flutter SDK files, caches, and dependencies are stored within this folder structure on the external SSD, eliminating any need for internal disk space usage for Flutter development.

### Benefits of Using FVM

1. **Isolation**: Each project can use its specific Flutter SDK version, preventing conflicts between projects.

2. **Consistency**: All team members work with the same Flutter version, ensuring that the application behaves the same way across different development environments.

3. **Multiple Projects**: Easy management of projects requiring different Flutter versions, allowing developers to switch contexts without hassle.

4. **Disk Space Optimization**: Cached SDKs are reused across projects, minimizing the overall disk space required for Flutter development.

### How Our App References the FVM Flutter SDK

- The application references the Flutter SDK through the `.fvm/flutter_sdk` symlink, ensuring that it always uses the correct version.
- Flutter commands are always prefixed with `fvm` to ensure the correct version is used, preventing any accidental usage of a different version.

- IDE configurations (VS Code, Android Studio) are set to use the local FVM Flutter SDK, ensuring that the development environment is consistent.

In the `local.properties` file for Android:

```properties
flutter.sdk=/Volumes/Acasis TB4/Flutter Latest Env Projects/.fvm/flutter_sdk
```

## Project Structure

The project follows a clean architecture approach with a clear separation of concerns:

```
fitness_freaks/
├── android/               # Android-specific code
├── ios/                   # iOS-specific code
├── lib/
│   ├── core/              # Core utilities, constants, and services
│   │   ├── constant/      # App-wide constants
│   │   ├── di/            # Dependency injection
│   │   ├── error/         # Error handling
│   │   ├── network/       # Network services
│   │   └── presentation/  # Core presentation components
│   ├── features/          # Feature modules
│   │   ├── fitness/       # Fitness tracking feature
│   │   │   ├── data/      # Data layer
│   │   │   │   ├── datasources/  # Remote and local data sources
│   │   │   │   ├── models/       # Data models
│   │   │   │   └── repositories/ # Repository implementations
│   │   │   ├── domain/    # Domain layer
│   │   │   │   ├── entities/     # Business entities
│   │   │   │   ├── repositories/ # Repository interfaces
│   │   │   │   └── usecases/     # Business logic use cases
│   │   │   └── presentation/ # Presentation layer
│   │   │       ├── bloc/      # State management
│   │   │       ├── pages/     # UI screens
│   │   │       ├── providers/ # Riverpod providers
│   │   │       └── widgets/   # Reusable UI components
│   │   ├── homepage/     # Homepage feature
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── user/         # User authentication and profile feature
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   ├── firebase_options.dart  # Firebase configuration
│   └── main.dart          # Entry point
├── test/                  # Test directory
├── integration_test/      # Integration tests
├── .env                   # Environment variables
├── firebase.json         # Firebase configuration
├── pubspec.yaml           # Project dependencies
└── environment_doc.md     # This documentation
```

## Clean Architecture Implementation

The project implements a clean architecture pattern with three main layers:

### 1. Domain Layer

The domain layer contains:

- **Entities**: Pure Dart classes representing business objects (`User`, `Workout`, etc.)
- **Repository Interfaces**: Abstract classes defining operations on entities.
- **Use Cases**: Classes implementing business logic.

Example of an Entity:

```dart
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  // ...
}
```

Example of a Repository Interface:

```dart
abstract class UserRepository {
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, User>> updateUser(User user);
  // ...
}
```

### 2. Data Layer

The data layer contains:

- **Models**: Classes that extend domain entities, adding serialization/deserialization.
- **Data Sources**: Classes responsible for fetching data from remote API or local storage.
- **Repository Implementations**: Classes implementing the repository interfaces.

Example of a Model:

```dart
class UserModel extends User {
  const UserModel({
    required String id,
    required String name,
    required String email,
    // ...
  }) : super(id: id, name: name, email: email, ...);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // JSON parsing logic
  }

  Map<String, dynamic> toJson() {
    // Convert to JSON
  }
}
```

### 3. Presentation Layer

The presentation layer contains:

- **Notifiers/Providers**: Riverpod providers for state management.
- **Pages**: Screens of the application.
- **Widgets**: Reusable UI components.

## iOS-First Design Approach

The application follows an iOS-first design approach, heavily leveraging Cupertino widgets:

1. Using `CupertinoApp` instead of `MaterialApp` as the root widget.

2. Using Cupertino-specific widgets (`CupertinoPageScaffold`, `CupertinoNavigationBar`, etc.).

3. Following iOS design patterns and behaviors.

4. Using iOS-styled animations and transitions.

Example from `main.dart`:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      ),
      // ...
    );
  }
}
```

## Dependency Management

### Key Dependencies

1. **State Management**:

   - `flutter_riverpod` and `riverpod_annotation` for state management.

   - Code generation with `riverpod_generator` and `build_runner`.

2. **Networking**:

   - `dio` for HTTP requests.

   - Error handling with `dartz` for functional programming concepts.

3. **Data Persistence**:

   - `shared_preferences` for local storage.

4. **UI/UX**:

   - `cupertino_icons` for iOS-style icons.

   - `flutter_localizations` for internationalization.

5. **Utilities**:

   - `equatable` for value equality.

### Dependency Injection

Dependencies are injected using Riverpod providers, which are defined in `lib/core/di/providers.dart`:

```dart
@riverpod
Dio dio(DioRef ref) {
  return Dio(BaseOptions(
    baseUrl: 'https://api.fitnessfreaks.example.com',
    // Other configurations
  ));
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepositoryImpl(
    remoteDataSource: ref.watch(userRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
```

## Platform-Specific Configurations

### iOS Configuration

iOS-specific configurations are located in the `ios/` directory:

- Podfile for iOS dependencies.
- Info.plist for app settings.
- Runner.xcworkspace for Xcode project.

### Android Configuration

Android-specific configurations are located in the `android/` directory:

- build.gradle for Android dependencies and build settings.
- AndroidManifest.xml for app settings.
- local.properties for SDK paths.

NDK configuration in `local.properties`:

```properties
ndk.dir=/Users/nikhilsharma/Library/Android/sdk/ndk/25.1.8937393
```

## Disk Space Optimization

To address disk space limitations on the internal drive, several optimizations have been implemented:

### External SSD Configuration

1. **Gradle Cache Relocation**:

   - The Gradle cache is moved to the external SSD (Acasis TB4) to reduce internal disk usage.

   - This is configured in `gradle.properties` with the `org.gradle.caching.dir` property.

2. **Android SDK Location**:

   - Android SDK is configured to use a location on the external SSD.

   - This is specified in `local.properties` with the `sdk.dir` property pointing to the external drive.

3. **Flutter Temporary Directories**:

   - Flutter's temporary directories are relocated to the external SSD.

   - This includes build caches, downloaded artifacts, and compilation outputs.

### FVM Optimization

FVM helps with disk space optimization by:

1. **Single SDK Installation**: Only one copy of each Flutter version is cached globally.

2. **Symlinks Over Copies**: Projects use symlinks to the cached SDK instead of duplicating files.

3. **Isolated Dependencies**: Each project maintains its own dependencies without affecting others.

### Project-Specific Considerations

For the Fitness Freaks project:

1. **Asset Optimization**: Images and other assets are optimized for size.

2. **Dependency Management**: Only necessary dependencies are included to minimize package bloat.

3. **Generated Code Management**: Generated files are cleaned regularly using `--delete-conflicting-outputs`.

## Development Workflow

### Environment Setup

1. **Setup FVM**:

   ```bash
   dart pub global activate fvm
   ```

2. **Install Flutter SDK**:

   ```bash
   fvm install stable
   ```

3. **Use specific Flutter version**:

   ```bash
   fvm use stable
   ```

### Building and Running

1. **Get dependencies**:

   ```bash
   fvm flutter pub get
   ```

2. **Generate code** (for Riverpod annotations):

   ```bash
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run the app**:

   ```bash
   fvm flutter run
   ```

### Best Practices

1. Always use `fvm flutter` instead of just `flutter` to ensure the correct SDK version.

2. Run code generation after changing any annotated code.

3. Follow clean architecture principles when adding new features.

4. Maintain iOS-first design principles while ensuring Android compatibility.

5. Use Cupertino widgets for UI components.

## Conclusion

This project uses a well-structured, clean architecture approach with FVM for version management. The iOS-first design approach with Cupertino widgets creates a native iOS feel, while the use of Riverpod for state management and dependency injection provides a robust and testable application architecture.

The separation of concerns across domain, data, and presentation layers allows for maintainable, extensible code that can evolve with the project requirements.

## Setup Process for This Project

The following steps were taken to set up this environment from scratch:

1. **Environment Setup**:

   ```bash
   # Create base directories
   mkdir -p "Flutter Latest Env Projects/environment"
   cd "Flutter Latest Env Projects"

   # Install FVM locally in the environment directory
   cd environment
   dart pub global activate fvm
   cd ..

   # Install latest stable Flutter version via FVM
   fvm install stable

   # Create project directory
   mkdir -p fitness_freaks
   cd fitness_freaks

   # Configure project to use the installed Flutter version
   fvm use stable
   ```

2. **Project Creation**:

   ```bash
   # Create a new Flutter project with specified organization
   fvm flutter create . --org com.fitnessfreaks --platforms=ios,android
   ```

3. **Clean Architecture Setup**:

   ```bash
   # Create clean architecture folder structure
   mkdir -p lib/core lib/data/datasources lib/data/models lib/data/repositories \
     lib/domain/entities lib/domain/repositories lib/domain/usecases \
     lib/presentation/bloc lib/presentation/pages lib/presentation/widgets
   ```

4. **Dependencies Installation**:

   ```bash
   # Update pubspec.yaml to add required dependencies
   # Then run:
   fvm flutter pub get
   ```

5. **Code Generation Setup**:

   ```bash
   # Configure code generation for Riverpod
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Android Configuration**:

   ```bash
   # Configure Android local.properties to point to external locations
   # Update SDK and NDK paths to point to external drive locations when possible
   ```

7. **iOS Configuration**:

   ```bash
   # Configure iOS project
   cd ios
   pod install
   cd ..
   ```

8. **iOS-First UI Implementation**:

   ```bash
   # Update main.dart to use Cupertino widgets
   # Implement iOS-styled navigation and components
   ```

This setup process ensures that the entire Flutter environment, including the SDK, dependencies, and project files, is contained within the "Flutter Latest Env Projects" folder on the external SSD, addressing the disk space constraints on the internal drive.

### Purpose of Each Folder

1. **.fvm/**: This folder contains the configuration for Flutter Version Management (FVM). It includes a symlink to the Flutter SDK being used and a configuration file that tracks the version.

2. **environment/**: This folder is intended for environment-specific configuration files. It can include settings for different environments (development, staging, production) to ensure that the application behaves correctly in each context.

3. **fvm/**: This directory is managed by FVM and contains cached versions of the Flutter SDK. The `versions/` subdirectory holds the actual SDK files for different versions, allowing for easy switching between them.

4. **fitness_freaks/**: This is the main application directory where all the code for the Fitness Freaks app resides. It is structured to follow clean architecture principles, separating concerns into different layers.

   - **android/**: Contains Android-specific code, configurations, and resources needed for building the Android version of the app.

   - **ios/**: Contains iOS-specific code, configurations, and resources needed for building the iOS version of the app.

   - **lib/**: This is where the main application code is located. It is further divided into several subfolders:

     - **core/**: Contains core utilities, constants, and services that are used throughout the application.
     - **data/**: This layer handles data management, including models for serialization and repositories for data access.
     - **domain/**: Contains business logic, including entities, repository interfaces, and use cases that define the application's core functionality.
     - **presentation/**: This layer is responsible for the UI components, including state management, pages, and reusable widgets.

   - **test/**: This directory is dedicated to unit and widget tests, ensuring that the application is thoroughly tested and reliable.

   - **pubspec.yaml**: This file contains the project's dependencies and metadata, defining the packages required for the application to function.

   - **environment_doc.md**: This documentation file provides detailed information about the environment setup and configuration, serving as a guide for developers working on the project.

### Conclusion

This setup process ensures that the entire Flutter environment, including the SDK, dependencies, and project files, is contained within the "Flutter Latest Env Projects" folder on the external SSD, addressing the disk space constraints on the internal drive. By organizing the project in this manner, we achieve a clean architecture that promotes maintainability, scalability, and ease of collaboration among team members. The use of FVM further enhances the development experience by allowing for version control of the Flutter SDK, ensuring that all developers work with the same tools and configurations.
