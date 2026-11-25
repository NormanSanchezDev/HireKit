# HKData

Implementa los contratos de repositorio de `HKDomain`. Las fuentes de datos trabajan con valores primitivos y los repositorios los traducen a tipos del dominio.

## Dependencias

- `HKDomain` (paquete local).
- Foundation (`UserDefaults`).
- [Supabase Swift](https://github.com/supabase/supabase-swift) 2.55.8 (producto `Supabase`). Solo este paquete lo importa.

## Contenido

| Tipo | Descripción |
| --- | --- |
| `OnboardingLocalDataSource` | Contrato de almacenamiento local del progreso de bienvenida. |
| `UserDefaultsOnboardingDataSource` | Guarda el progreso en `UserDefaults` con la clave `HKData.onboardingState`. |
| `DefaultOnboardingRepository` | `OnboardingRepository` que traduce valores desconocidos a `.pending`. |
| `AuthRemoteDataSource` | Contrato de la API de autenticación, con `RemoteAuthUser` y `RemoteSignUpResponse`. |
| `SupabaseAuthRemoteDataSource` | Inicia sesión y registra con Supabase Auth. Sin configuración lanza `.notConfigured`. |
| `SupabaseConfiguration` | URL y clave publicable leídas de `Supabase.plist`. Exige `https`. |
| `SupabaseAuthErrorMapper` | Traduce errores de Supabase a `AuthenticationError` (interno). |
| `DefaultAuthRepository` | `AuthRepository` que traduce las respuestas remotas a tipos del dominio. |

## Uso

```swift
let repository = DefaultOnboardingRepository(
    localDataSource: UserDefaultsOnboardingDataSource(defaults: .standard)
)

let auth = DefaultAuthRepository(
    remoteDataSource: SupabaseAuthRemoteDataSource(
        configuration: SupabaseConfiguration(bundle: .main)
    )
)
```

## Pruebas

```bash
cd Packages/HKData
xcodebuild test -scheme HKData -destination 'platform=macOS' -derivedDataPath /tmp/dd-HKData
```
