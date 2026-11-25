# HKCore

Contenedor de inyección de dependencias con tipos seguros. Solo lo usa la raíz de composición de la app (`AppDependencies`); las funcionalidades reciben sus dependencias por inicializador.

## Dependencias

Ninguna. Solo Foundation.

## Contenido

| Tipo | Descripción |
| --- | --- |
| `HKContainer` | Registra y resuelve servicios por tipo. `@MainActor`. |
| `HKLifetime` | `.singleton` (una instancia compartida) o `.transient` (una por resolución). |

## Uso

```swift
let container = HKContainer()
container.register((any OnboardingRepository).self, lifetime: .singleton) {
    DefaultOnboardingRepository(localDataSource: $0.resolve())
}
let repository: any OnboardingRepository = container.resolve()
```

Resolver un tipo sin registrar detiene la app con `preconditionFailure`; usa
`resolveIfRegistered` cuando el servicio sea opcional.

## Pruebas

```bash
cd Packages/HKCore
xcodebuild test -scheme HKCore -destination 'platform=macOS' -derivedDataPath /tmp/dd-HKCore
```
