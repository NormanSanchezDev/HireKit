# HKData

Implementa los contratos de repositorio de `HKDomain`. Las fuentes de datos trabajan con valores primitivos y los repositorios los traducen a tipos del dominio.

## Dependencias

- `HKDomain` (paquete local).
- Foundation (`UserDefaults`).

## Contenido

| Tipo | Descripción |
| --- | --- |
| `OnboardingLocalDataSource` | Contrato de almacenamiento local del progreso de bienvenida. |
| `UserDefaultsOnboardingDataSource` | Guarda el progreso en `UserDefaults` con la clave `HKData.onboardingState`. |
| `DefaultOnboardingRepository` | `OnboardingRepository` que traduce valores desconocidos a `.pending`. |

## Uso

```swift
let repository = DefaultOnboardingRepository(
    localDataSource: UserDefaultsOnboardingDataSource(defaults: .standard)
)
```

## Pruebas

```bash
cd Packages/HKData
xcodebuild test -scheme HKData -destination 'platform=macOS' -derivedDataPath /tmp/dd-HKData
```
