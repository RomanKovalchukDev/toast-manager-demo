# ToastManager — Usage Guide

[ToastManager.zip](ToastManager%20%E2%80%94%20Usage%20Guide/ToastManager.zip)

## Overview

ToastManager is a lightweight SwiftUI component for displaying toast notifications. It consists of 3 files:

| File | Purpose |
| --- | --- |
| `ToastManager.swift` | Observable class that manages toast state |
| `ToastData.swift` | Enum defining toast types (success / error) |
| `ToastableModifier.swift` | ViewModifier that renders toasts on screen |

**Dependency:** [PopupView](https://github.com/exyte/PopupView) — handles positioning and animation.

---

## Source Files

### ToastData.swift

```swift
public enum ToastData: Equatable {
    case success(String)
    case error(String)
}
```

### ToastManager.swift

```swift
@Observable
final class ToastManager {
    var toast: ToastData?

    func showToast(_ toast: ToastData, autoDismissDelay: TimeInterval = 2.5) {
        self.toast = toast

        DispatchQueue.main.asyncAfter(deadline: .now() + autoDismissDelay) { [weak self] in
            self?.toast = nil
        }
    }
}
```

**Key points:**

- `@Observable` — SwiftUI tracks changes automatically
- Auto-dismisses after 2.5s by default (configurable per call)

### ToastableModifier.swift

```swift
public struct ToastableModifier: ViewModifier {
    @Bindable var toastManager: ToastManager

    public init(toastManager: ToastManager) {
        self._toastManager = Bindable(toastManager)
    }

    public func body(content: Content) -> some View {
        content.popup(item: $toastManager.toast) { toast in
            switch toast {
            case .error(let message):
                ErrorToastView(error: message)
                
            case .success(let message):
                SuccessToastView(message: message)
            }
        } customize: {
            $0
                .type(.floater(verticalPadding: 16, horizontalPadding: 16, useSafeAreaInset: true))
                .position(.bottom)
        }
    }
}
```

> You must provide your own `ErrorToastView` and `SuccessToastView` — these are project-specific toast designs.

---

## Integration Steps

1. Add **PopupView** dependency (SPM or CocoaPods)
2. Copy the 3 source files into your project
3. Create `ErrorToastView` and `SuccessToastView` matching your design system
4. Add a `View` extension for convenience:

```swift
extension View {
    func toastable(with toastManager: ToastManager) -> some View {
        modifier(ToastableModifier(toastManager: toastManager))
    }
}
```

---

## Architecture: Show Toasts from ViewModels

> The core principle: **ViewModels trigger toasts, not Coordinators or Screens.**
> 

Screens handle UI layout. Coordinators handle navigation. ViewModels own business logic — and deciding *when* to show a toast is a business logic decision (API failed, booking succeeded, validation error, etc.).

### Data Flow

```
Coordinator creates ToastManager
       │
       ├──► CoordinatorView applies .toastable(with:) modifier
       │
       └──► Coordinator passes toastManager to ViewModel via init
                    │
                    ▼
              ViewModel calls toastManager.showToast(...)
                    │
                    ▼
              ToastableModifier observes state change → renders toast
```

---

## Usage Examples

### 1. Coordinator — Create and Own ToastManager

```swift
@MainActor
final class CoachesCoordinator: ObservableObject {
    let router = NavigationRouter<CoachesRoute>()
    let toastManager = ToastManager()
}
```

### 2. CoordinatorView — Apply the Modifier

Apply `.toastable()` at the **root** of your navigation stack so toasts appear above all screens:

```swift
struct CoachesCoordinatorView: View {
    @ObservedObject var coordinator: CoachesCoordinator

    var body: some View {
        NavigationStackView(
            router: coordinator.router,
            rootContent: { 
	            coordinator.makeInitialView() 
	          },
            destination: { route in 
		            coordinator.buildDestination(for: route) 
		        }
        )
        .toastable(with: coordinator.toastManager)
    }
}
```

### 3. Coordinator — Pass ToastManager to ViewModels

When creating ViewModels, inject `toastManager`:

```swift
private func makeFilteredCoachesView(language: LanguageModel, areas: [AreaModel]) -> some View {
    let viewModel = CoachesListFilteredViewModel(
        language: language,
        areas: areas,
        toastManager: toastManager,
        events: .init(
            onCoachSelected: { [weak self] coach in
                self?.router.push(.coachDetails(coach: coach))
            }
        )
    )
    
    return CoachesListFilteredScreen(viewModel: viewModel)
}
```

### 4. ViewModel — Store and Use ToastManager

```swift
@MainActor
final class CoachesListFilteredViewModel: ObservableObject {
    private let toastManager: ToastManager

    init(
        language: LanguageModel,
        areas: [AreaModel],
        toastManager: ToastManager,
        events: Events
    ) {
        self.toastManager = toastManager
        // ...
    }
}
```

### 5. ViewModel — Show Toasts on Events

**Success toast:**

```swift
func onBookingCompleted() {
    toastManager.showToast(.success("Session booked successfully"))
}
```

**Error toast:**

```swift
func fetchData() {
    Task {
        do {
            let data = try await repository.getData()
            self.items = data
        } 
        catch {
            toastManager.showToast(.error(error.localizedDescription))
        }
    }
}
```

**Custom dismiss delay:**

```swift
toastManager.showToast(.error("Connection lost"), autoDismissDelay: 5.0)
```

---

## Extending ToastManager

The base ToastManager is intentionally minimal. For projects that need loading indicators or full-screen error dialogs, subclass it:

```swift
@MainActor
final class AppToastManager: ToastManager {
    @Published var isLoading = false
    @Published var showConnectionError = false

    func showLoading() {
        isLoading = true
    }

    func hideLoading() {
        isLoading = false
    }

    func showGenericError(
        errorText: String,
        onRetry: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        isLoading = false
        // Present full-screen error with retry/cancel
    }
}
```

Then update `ToastableModifier` to handle the extra states (loading overlay, error full-screen cover).

**Example — Loading + Error Handling in a ViewModel:**

```swift
private func bookSession() {
    toastManager.showLoading()

    Task {
        do {
            let appointment = try await appointmentRepository.bookSession(info)
            toastManager.hideLoading()
            events.onBookSessionSuccess(appointment)
        } 
        catch {
            toastManager.hideLoading()
            
            toastManager.showGenericError(
                errorText: error.localizedDescription,
                onRetry: { [weak self] in
	                self?.bookSession()
                },
                onCancel: { [weak self] in 
			            self?.events.onGoBack()
                }
            )
        }
    }
}
```

---

## Summary

| Layer | Responsibility |
| --- | --- |
| **Coordinator** | Creates `ToastManager`, passes it to ViewModels, applies `.toastable()` modifier |
| **ViewModel** | Calls `showToast()` / `showLoading()` / `showGenericError()` based on business logic |
| **Screen (View)** | Does nothing with toasts — they render automatically via the modifier |
| **ToastableModifier** | Observes `ToastManager` state and renders the appropriate toast UI |
