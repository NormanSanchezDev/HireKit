# HKPresentation

Vistas, ViewModels, coordinadores y routers de HireKit. La navegación está descrita en [documentation/routing.md](../../documentation/routing.md).

## Dependencias

- `HKDomain` (paquete local): protocolos de casos de uso.
- `HKDesignSystem` (paquete local): componentes de interfaz.
- SwiftUI y Observation.

Nunca depende de `HKData`.

## Contenido

```
Sources/HKPresentation/
├── DI/          HKViewModelFactory, HKPreviewViewModelFactory (DEBUG)
├── Navigation/  HKRoute, HKRouter, HKRouterStack
├── Root/        HKRootView, RootViewModel
└── Features/
    ├── Welcome/   WelcomeView, WelcomeViewModel
    ├── Auth/      AuthFlowView, AuthRoute, SignIn/SignUp (View + ViewModel), AuthForm
    ├── Home/      HomeView, HomeCoordinator, HomeTab, rutas, DashboardView
    └── Settings/  SettingsView, SettingsViewModel, AppearanceView, AboutView
```

Los ViewModels son `@MainActor @Observable` y reciben casos de uso y closures
de navegación por inicializador. Las vistas son internas; solo `HKRootView`,
los ViewModels, las rutas y los routers son públicos.

## Uso

```swift
WindowGroup {
    HKRootView(factory: dependencies)
        .environment(dependencies.themeManager)
}
```

`dependencies` implementa `HKViewModelFactory`. En las vistas previas usa
`HKPreviewViewModelFactory()`.

## Pruebas

```bash
cd Packages/HKPresentation
xcodebuild test -scheme HKPresentation -destination 'platform=iOS Simulator,name=iPhone 17'
```
