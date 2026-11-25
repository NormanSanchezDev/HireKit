# Architecture

MVVM on top of Clean Architecture, split into local Swift packages. Dependencies
point inward only.

```
HireKit (app target, composition root)
├── HKPresentation  → HKDomain, HKDesignSystem
├── HKData          → HKDomain
├── HKDomain        → (nothing)
├── HKDesignSystem  → (nothing)
└── HKCore          → (nothing)
```

| Package | Contains | Rules |
| --- | --- | --- |
| `HKCore` | `HKContainer` (type-safe DI container), `HKLifetime` | Used only by the composition root. |
| `HKDomain` | Entities, repository protocols, use case protocols and `Default…` implementations | Pure Swift. No SwiftUI, no Foundation persistence. |
| `HKData` | Data sources and repository implementations | Implements domain protocols. `UserDefaults` today. |
| `HKDesignSystem` | Tokens, theme, Liquid Glass components | No domain knowledge. See `design-system.md`. |
| `HKPresentation` | Views, `@MainActor @Observable` ViewModels, coordinators, routers | Depends on use case protocols, never on `HKData`. |

## Dependency injection

- `HireKit/DI/AppDependencies.swift` is the composition root. It registers data
  sources, repositories and use cases in `HKContainer`, and implements
  `HKViewModelFactory`.
- Views receive `any HKViewModelFactory` and build ViewModels through it.
  `HKPreviewViewModelFactory` (DEBUG only) backs previews with in-memory data.
- Adding a feature:
  1. Domain: entity, repository protocol, use case protocol plus `Default…`.
  2. Data: data source and repository implementation.
  3. Register both in `AppDependencies`.
  4. Add a `make…ViewModel` method to `HKViewModelFactory`, `AppDependencies`
     and `HKPreviewViewModelFactory`.
  5. Write the ViewModel and view in `HKPresentation/Features/<Feature>/`.

## Navigation

Two levels, both in `HKPresentation`:

1. **Flows.** `RootViewModel.destination` swaps whole flows:
   `loading → welcome → auth → home`. Switching replaces the screen, so there
   is no back navigation between flows.
2. **Screens inside a flow.** Each flow owns an `HKRouter<Route>` (path plus an
   optional sheet) and renders it with `HKRouterStack`.
   - Routes are enums that conform to `HKRoute`.
   - The coordinator view (`AuthFlowView`, `HomeView` + `HomeCoordinator`)
     maps each route to a screen and builds ViewModels through the factory.
   - ViewModels never see routers. They receive closures such as
     `onSignUp` or `onAuthenticated`, and the coordinator turns them into
     `push`, `present` or a flow change.
   - Home keeps one router per tab in `HomeCoordinator`. Reselecting a tab pops
     it to root, and `open(_:)` jumps across tabs for deep links.

Adding a flow: create `<Flow>Route: HKRoute`, a coordinator view with
`@State var router = HKRouter<<Flow>Route>()`, and render it with
`HKRouterStack(router:) { root } destination: { route in … }`.

## Testing

- Swift Testing everywhere (`import Testing`, `@Test`, `#expect`).
- ViewModels, routers and coordinators are tested without SwiftUI.
- Domain tests use stub use cases; data tests use an isolated `UserDefaults`
  suite.
- App-level tests in `HireKitTests` exercise `AppDependencies` end to end.

## Known gaps

- No session persistence yet: after onboarding, relaunching goes straight to
  Home. A `SessionRepository` in Domain/Data should drive
  `RootViewModel.load()`.
- Some presentation files still hold several views (`AuthViews.swift`,
  `HomeView.swift`, `SettingsView.swift`, `HomeRoutes.swift`). Split them to
  one type per file when they are next touched.
