# HKPresentation

Vistas, ViewModels, coordinadores y routers de HireKit. La navegación está descrita en [documentation/routing.md](../../documentation/routing.md).

Las pantallas y sus mensajes de validación usan claves de `HireKit/Localizable.xcstrings` en español e inglés.

La bienvenida, el inicio de sesión y las tres pantallas del registro obtienen
el contenido, los campos, la acción principal y el estado de carga y error de
`uiState` (`WelcomeUIState`, `SignInUIState`, `SignUpUIState`,
`PersonalInformationUIState`, `ContactInformationUIState`) al aparecer. Los
pasos del registro comparten un `SignUpDraft` en memoria, sin contraseña. Antes de
`onAppear()` el estado es `nil`.

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
    ├── Auth/      AuthFlowView, AuthRoute, AuthForm, AuthInputValidator,
    │              mensajes de AuthenticationError, DialCode+Presentation,
    │              SignIn/ (View, ViewModel, Model/…UIState)
    │              SignUp/ (introducción, SignUpDraft, SignUpStep)
    │              PersonalInformation/ (paso 1, validador)
    │              ContactInformation/ (paso 2, validador)
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
`HKPreviewViewModelFactory()`, que usa `PreviewAuthRepository` en memoria.

## Pruebas

```bash
cd Packages/HKPresentation
xcodebuild test -scheme HKPresentation -destination 'platform=iOS Simulator,name=iPhone 18 Pro'
```
