# HKDomain

Reglas de negocio de HireKit: entidades, contratos de repositorio y casos de uso. Es Swift puro: no importa SwiftUI ni sabe dónde se guardan los datos. Las reglas están descritas en [documentation/business.md](../../documentation/business.md).

## Dependencias

Ninguna.

## Contenido

```
Sources/HKDomain/
├── Entities/
│   ├── OnboardingState
│   ├── Auth/        AuthCredentials, NewAccount, ContactInformation, AuthUser,
│   │                SignUpResult, AuthenticationError
│   └── Profile/     PersonName, DialCode, PhoneNumber, BirthDateRule,
│                    PersonalInformation
├── Repositories/    OnboardingRepository, AuthRepository
└── UseCases/
    ├── Onboarding/  GetOnboardingState, CompleteOnboarding, ResetOnboarding
    └── Auth/        SignIn, SignUp
                     y sus implementaciones Default…
```

Cada caso de uso es un protocolo `Sendable` con un único `execute()` y una
implementación `Default…` que recibe su repositorio por inicializador. Los
casos de uso de acceso lanzan `throws(AuthenticationError)` y normalizan los
datos antes de llamar al repositorio.

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
