# Codex instructions

## SwiftUI screens and MVVM lifecycle

Implement each feature screen with a feature-specific `...UIState` owned by its `@MainActor @Observable` ViewModel. Put localized display content and renderable values in the UI state, including loading, empty, error, and action availability where needed. Keep domain use cases and navigation callbacks in the ViewModel.

Have the SwiftUI View call `viewModel.onAppear()` using `.onAppear`. Prepare or refresh state in the ViewModel, making the method idempotent when repeated appearances must preserve in-flight work or dismissed errors. Render from `uiState` and pass state-owned component models to design-system components. Test state preparation and lifecycle behavior at the ViewModel level. Use `WelcomeUIState` and `WelcomeViewModel` as the reference.
