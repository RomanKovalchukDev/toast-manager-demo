# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI demo project showcasing the ToastManager component, a lightweight toast notification system for iOS apps. The repository contains:

1. **Reference implementation** (`1/ToastManager — Usage Guide/ToastManager/`) with three core files
2. **Demo app** (`ToastManagerDemo/`) — Xcode project demonstrating integration
3. **Usage documentation** (`1/ToastManager — Usage Guide 3305fb807eca81aea671ffe894c91748.md`)

## Architecture

### ToastManager Component Structure

The ToastManager system consists of three tightly coupled files:

- **ToastData.swift** — `enum` with two cases: `.success(String)` and `.error(String)`
- **ToastManager.swift** — `@Observable` class that manages toast state and auto-dismiss logic
- **ToastableModifier.swift** — SwiftUI `ViewModifier` that renders toasts using [PopupView](https://github.com/exyte/PopupView)

### Design Principles

**ViewModels trigger toasts, not Coordinators or Screens.**

- Coordinators create and own `ToastManager` instances
- Coordinators apply `.toastable(with:)` modifier to navigation root
- Coordinators inject `ToastManager` into ViewModels via `init`
- ViewModels call `toastManager.showToast()` based on business logic (API failures, validation errors, etc.)

**ToastManager is designed to be subclassed.** Use `open class` to extend with loading indicators, full-screen error dialogs, or connection error handling.

## Development Commands

### Building
Open the Xcode project:
```bash
open ToastManagerDemo/ToastManagerDemo.xcodeproj
```

Build from command line:
```bash
xcodebuild -project ToastManagerDemo/ToastManagerDemo.xcodeproj -scheme ToastManagerDemo -destination 'platform=iOS Simulator,name=iPhone 16' build
```

### Testing
Run tests via Xcode or:
```bash
xcodebuild test -project ToastManagerDemo/ToastManagerDemo.xcodeproj -scheme ToastManagerDemo -destination 'platform=iOS Simulator,name=iPhone 16'
```

Tests use Swift Testing framework (not XCTest). Test files are in:
- `ToastManagerDemo/ToastManagerDemoTests/`
- `ToastManagerDemo/ToastManagerDemoUITests/`

## Key Implementation Details

### Dependency
**PopupView** is required for `ToastableModifier`. It handles toast positioning and animation. Add via SPM or CocoaPods before integrating ToastManager.

### Custom Toast Views Required
`ToastableModifier` references `ErrorToastView` and `SuccessToastView` which are **not included** in the base component. You must implement these views to match your design system.

### Auto-Dismiss Behavior
Default auto-dismiss is 2.5 seconds. Override per-call:
```swift
toastManager.showToast(.error("Connection lost"), autoDismissDelay: 5.0)
```

### Extending ToastManager
Subclass for additional states like loading or full-screen errors:
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

Then update `ToastableModifier` to observe and render these states.

## File Locations

- **Reference implementation**: `1/ToastManager — Usage Guide/ToastManager/*.swift`
- **Demo app source**: `ToastManagerDemo/ToastManagerDemo/`
- **Tests**: `ToastManagerDemo/ToastManagerDemoTests/` and `ToastManagerDemo/ToastManagerDemoUITests/`
- **Full usage guide**: `1/ToastManager — Usage Guide 3305fb807eca81aea671ffe894c91748.md`
