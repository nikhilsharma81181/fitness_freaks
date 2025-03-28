# FitnessFreaks iOS App Documentation

## Table of Contents
1. [Introduction](#introduction)
2. [Architecture Overview](#architecture-overview)
3. [App Flow](#app-flow)
4. [UI Components](#ui-components)
5. [Features](#features)
6. [Data Management](#data-management)
7. [API Integration](#api-integration)
8. [Design System](#design-system)
9. [Weight Tracking Implementation](#weight-tracking-implementation)

---

## Introduction

FitnessFreaks is an iOS application designed for fitness enthusiasts to track their fitness journey, monitor weight, plan workouts, and analyze progress. The app provides a modern, visually appealing interface with frosted glass effects and vibrant gradients, creating an engaging experience for users.

### Version
Current Version: 1.0.0
Minimum iOS Version: 14.0

### Target Audience
- Fitness enthusiasts
- Weight tracking users
- People following fitness routines

---

## Architecture Overview

The app uses a SwiftUI-based architecture with MVVM (Model-View-ViewModel) patterns.

### Directory Structure

```
FitnessFreaks_iOS/
├── FitnessFreaks/
│   ├── Assets.xcassets/              # App icons and image assets
│   ├── Components/                   # Reusable UI components
│   │   ├── BackgroundGradient.swift  # Gradient backgrounds
│   │   ├── ChatView.swift            # Chat interface
│   │   ├── FitnessView.swift         # Fitness tracking interface
│   │   ├── HomeView.swift            # Main dashboard
│   │   ├── WeightTrackingView.swift  # Weight tracking interface
│   │   └── ...                       # Other components
│   ├── Extensions/                   # Swift extensions
│   │   ├── ColorExtension.swift      # Color definitions
│   │   └── ViewExtension.swift       # View modifiers
│   ├── Models/                       # Data models
│   │   ├── UserData.swift            # User profile model
│   │   └── WeightData.swift          # Weight tracking models
│   ├── Services/                     # Services for data operations
│   │   ├── CacheService.swift        # Local data caching
│   │   └── NetworkService.swift      # API communication
│   ├── Styles/                       # Custom UI styles
│   │   └── GlassCardStyle.swift      # Frosted glass card style
│   ├── Utilities/                    # Helper utilities
│   │   └── ImageCompressor.swift     # Image compression for uploads
│   ├── Views/                        # Main app views
│   │   ├── Components/               # View-specific components
│   │   ├── Fitness/                  # Workout-related views
│   │   ├── LoginView.swift           # Authentication view
│   │   └── ProfileView.swift         # User profile view
│   ├── ContentView.swift             # Main content container
│   └── FitnessFreaksApp.swift        # App entry point
└── ...
```

---

## App Flow

### Authentication Flow

1. **App Launch**: The application starts with `FitnessFreaksApp.swift` which displays the `LoginView`
2. **Login View**: Users can authenticate using Google or Apple buttons
3. **Token Management**: Upon successful authentication, a JWT token is stored using `CacheService`
4. **Main Content**: After authentication, users are redirected to `ContentView` which contains the app's main tabbed interface

### Navigation

The app uses a custom tab bar implemented in `ContentView.swift` with the following tabs:
- **Home**: Dashboard view with weight tracking and insights
- **Fitness**: Workout planning and exercise tracking
- **Chat**: Messaging and community features
- **Profile**: User settings and profile management

---

## UI Components

### Design Language

The app uses a consistent design language featuring:
- Dark mode interface with vibrant accents
- Frosted glass effects (glass cards, blur overlays)
- Subtle animations for user interactions
- Gradient backgrounds personalized for each section

### Component Inventory

#### Core UI Elements

1. **GlassCard**
   - Description: Frosted glass card with subtle border highlights
   - Usage: Background container for content sections
   - Implementation: `GlassCardStyle.swift` (ViewModifier)

2. **BackgroundGradient**
   - Description: Vibrant gradient backgrounds tailored for each tab
   - Usage: Full-screen backgrounds
   - Implementation: `BackgroundGradient.swift` and `BackgroundGradientView.swift`

3. **ContentScalingButtonStyle**
   - Description: Interactive button style with spring animation
   - Usage: All buttons requiring tactile feedback
   - Implementation: Defined in `ContentView.swift`

#### Feature-specific Components

1. **WeightTrackingView**
   - Location: `/Components/WeightTrackingView.swift`
   - Purpose: Displays and manages weight tracking data
   - Sub-components:
     - Weight graph (line chart)
     - Recent entries list
     - Camera capture for weight image processing
     - Sync indicator with real-time status

2. **LineChart**
   - Location: Inside `WeightTrackingView.swift`
   - Purpose: Visualizes weight trends over time
   - Features:
     - Animated curve drawing
     - Gradient fill
     - Interactive data points
     - Dynamic scaling

3. **ImagePicker**
   - Location: Inside `WeightTrackingView.swift`
   - Purpose: Camera interface for capturing weight display images
   - Features:
     - Camera access
     - Image capture and processing
     - Handoff to AI weight extraction

4. **Custom Tab Bar**
   - Location: `ContentView.swift`
   - Purpose: Navigation between main app sections
   - Features:
     - Glass effect background
     - Selection indicators
     - Animated icon states
     - Custom tab icons

### Iconography

The app uses SF Symbols for consistent iconography:

| Feature | Icon | Symbol Name |
|---------|------|-------------|
| Home Tab | House | `house.fill` |
| Fitness Tab | Fitness | `figure.strengthtraining.traditional` |
| Chat Tab | Message Bubble | `bubble.left.fill` |
| Profile Tab | Person | `person.fill` |
| Weight Tracking | Scale | `scalemass` |
| Camera | Camera | `camera.fill` |
| Sync | Arrows | `arrow.triangle.2.circlepath` |
| Add | Plus | `plus` |

---

## Features

### Weight Tracking

The weight tracking feature is implemented in `WeightTrackingView.swift` and includes:

#### Key Functionality
- View weight history in a graph and list format
- Add new weight entries via camera image capture
- Automatic weight detection using AI (server-side)
- Sync weight data with the server
- View trends and weight changes

#### Data Flow
1. User captures weight scale image
2. Image is compressed using `ImageCompressor.swift`
3. Image is sent to backend via `NetworkService.uploadWeightFromImage()`
4. Backend extracts weight from image and returns weight entry
5. Entry is added to local data and displayed in UI
6. Data is synced with server to ensure consistency

#### Sync Process
- **Manual Sync**: Tap the sync icon to initiate sync
- **Auto Sync**: Sync happens automatically after image upload
- **Sync States**:
  - Grey icon: Not syncing (tap to sync)
  - Spinning mint icon: Currently syncing
- **Data Merging**: When syncing, the app:
  1. Gets all entries from server
  2. Intelligently merges with existing entries
  3. Updates UI to show most recent data
  4. Saves to local cache for offline access

#### Weight Image Processing
The app uses `ImageCompressor.swift` to optimize weight images before upload:
- Reduces image size while maintaining readability
- Converts to base64 format for API compatibility
- Applies progressive compression until target size is reached
- Handles image resizing when compression alone is insufficient

### User Authentication

Authentication is managed in `LoginView.swift` and includes:

- OAuth-based authentication with Google and Apple
- JWT token management
- Secure token storage
- Animated login experience
- Loading indicators during auth process

### Fitness Tracking

Fitness tracking features include:

- Workout creation and tracking
- Exercise selection by muscle groups
- Equipment-based filtering
- Step-by-step workout configuration
- Progress visualization

---

## Data Management

### Data Models

1. **WeightEntry** (in `WeightData.swift`)
   ```swift
   struct WeightEntry: Codable, Identifiable, Equatable {
     let id: Int
     let userId: Int
     let weight: Double
     let image: String?
     let date: String
     let createdAt: String
     let updatedAt: String
     
     // Computed properties
     var dateObject: Date
     var formattedDate: String
     var shortDate: String
     
     // Equatable implementation
     static func == (lhs: WeightEntry, rhs: WeightEntry) -> Bool
   }
   ```

2. **UserData** (in `UserData.swift`)
   ```swift
   struct UserData: Codable {
     let id: Int
     let fullName: String
     let address: String?
     let country: String?
     let profilePhoto: String?
     let email: String
     let phoneNumber: String?
     let dateOfBirth: String?
     let gender: String?
     let isActive: Bool
     let createdAt: String
     let updatedAt: String
   }
   ```

### Data Services

1. **CacheService** (in `CacheService.swift`)
   - Purpose: Manages local data persistence
   - Key Methods:
     - `saveToken(_ token: String)`
     - `getToken() -> String?`
     - `saveWeightData(_ entries: [WeightEntry])`
     - `getCachedWeightData() -> [WeightEntry]?`
     - `clearCache()`

2. **NetworkService** (in `NetworkService.swift`)
   - Purpose: Handles API communications
   - Key Methods:
     - `fetchUserData(token: String) async throws -> UserData`
     - `fetchWeightData(token: String) async throws -> [WeightEntry]`
     - `uploadWeightFromImage(token: String, imageBase64: String) async throws -> WeightEntry`

---

## API Integration

### API Endpoints

The app communicates with a backend server at `https://fitness-0j1s.onrender.com` with the following endpoints:

1. **User Data**
   - Endpoint: `/api/user`
   - Method: GET
   - Authentication: Bearer token
   - Response: User profile information

2. **Weight Data**
   - Endpoint: `/api/weight-data`
   - Method: GET
   - Authentication: Bearer token
   - Response: Array of weight entries

3. **Weight from Image**
   - Endpoint: `/api/weight-data/from-image`
   - Method: POST
   - Authentication: Bearer token
   - Payload: `{ "imageBase64": "data:image/jpeg;base64,..." }`
   - Response: Newly created weight entry

### API Response Formats

1. **Weight Entry Response**
   ```json
   {
     "success": true,
     "data": {
       "id": 28,
       "weight": 64.2,
       "recordedAt": "2025-03-27T15:26:19.624Z",
       "createdAt": "2025-03-27T15:26:20.090Z",
       "updatedAt": "2025-03-27T15:26:20.090Z",
       "originalReading": {
         "weight": 63.3,
         "unit": "kg"
       }
     }
   }
   ```

2. **Weight Data Response**
   ```json
   {
     "success": true,
     "data": [
       {
         "id": 1,
         "userId": 1,
         "weight": 75.5,
         "image": null,
         "date": "2025-03-20T12:30:00.000Z",
         "createdAt": "2025-03-20T12:30:00.000Z",
         "updatedAt": "2025-03-20T12:30:00.000Z"
       },
       // More entries...
     ]
   }
   ```

### Error Handling

API errors are handled through custom `NetworkError` enum:
```swift
enum NetworkError: Error {
  case invalidURL
  case noData
  case decodingError
  case serverError(String)
  case authenticationError
}
```

Error responses include detailed error messages and status codes for troubleshooting.

---

## Design System

### Colors

The app uses a consistent color system defined in `ColorExtension.swift`:

#### Primary Colors
- **Background**: `Color.black` - Main app background
- **Vibrant Mint**: `Color(red: 0.0, green: 0.9, blue: 0.7)` - Primary accent
- **Vibrant Teal**: `Color(red: 0.0, green: 0.75, blue: 0.8)` - Secondary accent

#### Text Colors
- **Text Primary**: `Color.white` - Main text
- **Text Secondary**: `Color.white.opacity(0.7)` - Secondary text
- **Text Tertiary**: `Color.white.opacity(0.5)` - Subdued text

#### Tab-Specific Gradients
- **Home**: Deep blue to blue-purple
- **Fitness**: Green to teal
- **Chat**: Purple to pink
- **Profile**: Teal to green-blue

#### Functional Colors
- **Success**: `accentGreen` - Positive actions
- **Info**: `accentBlue` - Informational elements
- **Warning**: `accentOrange` - Warning states
- **Error**: `accentRed` - Error states

### Typography

The app uses the system font (SF Pro) with consistent sizing:

| Element | Size | Weight | Usage |
|---------|------|--------|-------|
| Large Title | 30pt | Bold | Main headers |
| Title | 20pt | Bold | Section headers |
| Headline | 16pt | Semibold | Card titles |
| Body | 16pt | Regular | Main content |
| Callout | 14pt | Medium | Important notes |
| Caption | 12pt | Regular | Supplementary text |

### Animation System

The app uses a cohesive animation system:

#### Spring Animations
```swift
withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
  // Animated property changes
}
```

#### Easing Animations
```swift
withAnimation(.easeOut(duration: 0.5)) {
  // Animated property changes
}
```

#### Loading Animations
```swift
withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
  loadingRotation = 360
}
```

---

## Weight Tracking Implementation

The weight tracking feature is a core component of the FitnessFreaks app, providing users with an intuitive way to track and visualize their weight over time. This section details the technical implementation of this feature.

### Components Structure

The weight tracking functionality is split across several components:

1. **WeightTrackingView**: Main view component that displays weight data
2. **LineChart**: Custom visualizer for weight trends
3. **ImagePicker**: Camera interface for capturing weight readings
4. **NetworkService**: Backend communication for data sync
5. **CacheService**: Local storage for offline access
6. **ImageCompressor**: Image optimization for uploads

### Data Flow

#### Adding a New Weight Entry
```
User takes photo → Image compressed → Image sent to server → Server processes image →
Server returns weight data → Data added to local collection → UI updates to show new data →
Data synced with server
```

#### Sync Process
```
User taps sync button or upload completes → isSyncing flag set to true → 
Network request initiated → Server returns all weight data → 
Local entries merged with server entries → Updated collection sorted by date →
Updated data saved to cache → isSyncing flag set to false → UI updates
```

### Key Methods

#### Image Capture and Processing
```swift
func uploadWeightImage() {
  guard let image = capturedImage, !processingImage else { return }
  
  processingImage = true
  uploadProgress = 0
  uploadSuccess = false
  errorMessage = nil
  
  // Compress image
  guard let base64Image = ImageCompressor.compressAndConvertToBase64(image: image) else {
    throw NetworkError.serverError("Failed to compress image")
  }
  
  // Upload to server
  let newEntry = try await NetworkService.shared.uploadWeightFromImage(
    token: token,
    imageBase64: base64Image
  )
  
  // Add entry to collection
  if let index = existingEntryIndex {
    self.weightEntries[index] = newEntry
  } else {
    self.weightEntries.append(newEntry)
  }
  
  // Sort and save data
  self.weightEntries.sort(by: { $0.dateObject > $1.dateObject })
  CacheService.shared.saveWeightData(self.weightEntries)
  
  // Start syncing to get latest data
  syncWithBackend()
}
```

#### Smart Data Syncing
```swift
private func syncWithBackend() {
  guard !isSyncing else { return }
  
  isSyncing = true
  
  // Fetch server data
  let entries = try await NetworkService.shared.fetchWeightData(token: token)
  
  // Create a dictionary of existing entries for quick lookup
  var entriesById = [Int: WeightEntry]()
  for entry in self.weightEntries {
    entriesById[entry.id] = entry
  }
  
  // Process server entries
  for serverEntry in entries {
    if entriesById[serverEntry.id] != nil {
      // Update existing entry
      entriesById[serverEntry.id] = serverEntry
    } else {
      // Add new entry
      entriesById[serverEntry.id] = serverEntry
    }
  }
  
  // Convert back to array and sort
  self.weightEntries = Array(entriesById.values)
  self.weightEntries.sort(by: { $0.dateObject > $1.dateObject })
  
  // Save to cache
  CacheService.shared.saveWeightData(self.weightEntries)
  
  isSyncing = false
}
```

### Server Response Handling

The app properly handles the API response format with special attention to the structure:

```swift
struct UploadResponse: Codable {
  let success: Bool
  let data: UploadedWeightData
}

struct UploadedWeightData: Codable {
  let id: Int
  let weight: Double
  let recordedAt: String
  let createdAt: String
  let updatedAt: String
  let originalReading: OriginalReading
  
  struct OriginalReading: Codable {
    let weight: Double
    let unit: String
  }
}
```

This precise mapping ensures that the app can correctly parse and handle the server's response, including the nested `originalReading` property.

### UI States

The weight tracking UI includes several state indicators:

1. **Sync State**:
   - Grey icon: Not syncing (tap to sync)
   - Spinning mint icon: Currently syncing

2. **Progress Indicators**:
   - Upload progress circle: Shows progress during image upload
   - Success checkmark: Displayed when upload completes successfully
   - Error message: Shown when upload or sync fails

3. **Empty States**:
   - Initial empty state with "Add First Entry" button
   - Error state with retry button
   - Loading state during initial data fetch

### Recent Improvements

Recent updates to the weight tracking feature include:

1. **Enhanced API Response Parsing**:
   - Improved handling of the nested response structure
   - Better error diagnostics for failed parsing
   - Detailed logging for troubleshooting

2. **Smarter Data Merging**:
   - Dictionary-based approach for efficient lookups
   - Proper handling of both new and updated entries
   - Sorting by date to ensure consistent display

3. **Automatic Sync After Upload**:
   - Sync automatically triggered after successful upload
   - Also triggered after failed uploads to ensure latest data
   - Manual sync option retained for user control

4. **Improved UI Feedback**:
   - Simplified sync indicator states
   - Clear visual indication of sync status
   - Detailed progress feedback during upload

These improvements ensure that the weight tracking feature provides a seamless, reliable experience for users tracking their fitness journey.

---

Documentation created: March 27, 2025  
Last updated: March 27, 2025
