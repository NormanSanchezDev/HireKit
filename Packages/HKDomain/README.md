# HKDomain

Reglas de negocio de HireKit: entidades, contratos de repositorio y casos de uso. Es Swift puro: no importa SwiftUI ni sabe dónde se guardan los datos. Las reglas están descritas en [documentation/business.md](../../documentation/business.md).

## Dependencias

Ninguna.

## Contenido

```
Sources/HKDomain/
├── Entities/        OnboardingState
├── Repositories/    OnboardingRepository
└── UseCases/
    └── Onboarding/  GetOnboardingState, CompleteOnboarding, ResetOnboarding
                     y sus implementaciones Default…
```

Cada caso de uso es un protocolo `Sendable` con un único `execute()` y una
implementación `Default…` que recibe su repositorio por inicializador.

## Uso

```swift
let useCase: any CompleteOnboardingUseCase = DefaultCompleteOnboardingUseCase(repository: repository)
try await useCase.execute()
```

## Pruebas

```bash
cd Packages/HKDomain
xcodebuild test -scheme HKDomain -destination 'platform=macOS' -derivedDataPath /tmp/dd-HKDomain
```
