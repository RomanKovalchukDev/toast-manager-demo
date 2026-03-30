# ToastManager Demo

A SwiftUI demo application showcasing a lightweight toast notification system with MVVM architecture.

## Overview

ToastManager is a reusable SwiftUI component for displaying temporary notification messages (toasts) in iOS applications. This demo project illustrates the recommended architecture pattern where ViewModels trigger toasts based on business logic events.

## Features

- **Success and Error Toasts** with distinct visual styles
- **Auto-dismiss** with configurable duration (default 2.5 seconds)
- **Native SwiftUI** implementation (no external dependencies)
- **MVVM Architecture** with dependency injection
- **Smooth animations** using SwiftUI transitions
- **Multi-line message support**
- **Async operation handling** with loading states

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Project Structure

```
ToastManagerDemo/
├── ToastManager/
│   ├── ToastData.swift           # Toast type enum (success/error)
│   ├── ToastManager.swift        # Observable toast manager
│   ├── ToastableModifier.swift   # ViewModifier for rendering toasts
│   └── View+Toastable.swift      # Convenience extension
├── CommonViews/
│   ├── ErrorToastView.swift      # Red gradient error toast
│   └── SuccessToastView.swift    # Green gradient success toast
├── ContentView/
│   ├── ContentView.swift         # Demo UI
│   └── ContentViewModel.swift    # ViewModel with toast triggers
└── ToastManagerDemoApp.swift     # App entry point
```

## Architecture

### MVVM Pattern with ToastManager

The ToastManager follows a clear separation of concerns:

1. **App/Coordinator Level**: Creates and owns `ToastManager` instance
2. **Root View**: Applies `.toastable(with:)` modifier to navigation root
3. **ViewModel**: Receives `ToastManager` via dependency injection
4. **Business Logic**: ViewModel calls `showToast()` based on events (API failures, validation errors, etc.)
5. **Automatic Rendering**: `ToastableModifier` observes state changes and displays toasts

### Architecture Diagram

![Architecture Diagram](docs/diagrams/architecture-diagram.svg)

### Class Structure

![Class Diagram](docs/diagrams/class-diagram.svg)

### Example Flow

```swift
// App creates ToastManager
private let toastManager = ToastManager()

// Root view applies modifier
.toastable(with: toastManager)

// ViewModel receives it via init
init(toastManager: ToastManager) {
    self.toastManager = toastManager
}

// ViewModel triggers toasts
toastManager.showToast(.success("Operation completed"))
toastManager.showToast(.error("Something went wrong"))
```

### Sequence Flow

![Sequence Diagram](docs/diagrams/sequence-diagram.svg)

The diagram above shows the complete flow from user interaction to toast display and auto-dismissal.

## Usage Examples

### Basic Toast

```swift
// Success toast
toastManager.showToast(.success("Data saved successfully"))

// Error toast
toastManager.showToast(.error("Failed to load data"))
```

### Custom Duration

```swift
toastManager.showToast(
    .success("This will stay for 5 seconds"),
    autoDismissDelay: 5.0
)
```

### In Async Operations

```swift
func loadData() async {
    do {
        let data = try await repository.fetchData()
        self.items = data
        toastManager.showToast(.success("Data loaded"))
    } catch {
        toastManager.showToast(.error(error.localizedDescription))
    }
}
```

## Building and Running

### From Xcode

1. Open `ToastManagerDemo.xcodeproj`
2. Select a simulator (iPhone 16, iPhone 17, etc.)
3. Press `Cmd+R` to build and run

### From Command Line

```bash
# Build
xcodebuild -project ToastManagerDemo/ToastManagerDemo.xcodeproj \
  -scheme ToastManagerDemo \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build

# Run tests
xcodebuild test -project ToastManagerDemo/ToastManagerDemo.xcodeproj \
  -scheme ToastManagerDemo \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Demo Features

The demo app includes:

- **Basic Toasts**: Show success and error toasts with standard messages
- **Async Operations**: Simulate network requests with random success/failure
- **Counter Example**: Demonstrates state management with toast feedback
- **Custom Duration**: Toast that stays visible for 5 seconds
- **Long Messages**: Multi-line text handling demonstration

## Customization

### Extending ToastManager

For projects requiring loading indicators or full-screen error dialogs, subclass `ToastManager`:

```swift
@MainActor
final class AppToastManager: ToastManager {
    @Published var isLoading = false

    func showLoading() {
        isLoading = true
    }

    func hideLoading() {
        isLoading = false
    }
}
```

### Custom Toast Views

Replace `ErrorToastView` and `SuccessToastView` with your own designs to match your app's visual style.

### Additional Toast Types

Extend `ToastData` enum:

```swift
public enum ToastData: Equatable {
    case success(String)
    case error(String)
    case warning(String)
    case info(String)
}
```

## Integration Guide

To integrate ToastManager into your project:

1. Copy the `ToastManager/` folder files to your project
2. Create `ErrorToastView` and `SuccessToastView` matching your design system
3. Add `.toastable(with:)` modifier at your navigation root
4. Inject `ToastManager` into your ViewModels via init
5. Call `showToast()` from ViewModel methods based on business logic

See `Usage Guide.md` for detailed integration instructions.

## Design Principles

**ViewModels trigger toasts, not Views or Coordinators.**

- Toasts represent business logic outcomes (success, failure, validation)
- ViewModels own business logic, therefore they decide when to show toasts
- Views handle layout, Coordinators handle navigation
- This separation keeps concerns properly isolated

## Documentation

- `CLAUDE.md`: Development guidance for working with this codebase
- `Usage Guide.md`: Comprehensive integration and architecture guide

## License

This is a demo project for educational purposes.
