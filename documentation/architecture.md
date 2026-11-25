# Arquitectura

MVVM sobre Clean Architecture, dividida en paquetes locales de Swift. Las
dependencias solo apuntan hacia dentro.

```
HireKit (app, raíz de composición)
├── HKPresentation ──▶ HKDomain, HKDesignSystem
├── HKData         ──▶ HKDomain
├── HKCore
├── HKDomain        (sin dependencias)
└── HKDesignSystem  (sin dependencias)
```

| Paquete | Contiene | Reglas |
| --- | --- | --- |
| `HKCore` | `HKContainer`, `HKLifetime` | Solo lo usa la raíz de composición. |
| `HKDomain` | Entidades, contratos de repositorio, casos de uso | Swift puro. Sin SwiftUI ni persistencia. |
| `HKData` | Fuentes de datos e implementaciones de repositorio | Implementa contratos del dominio. Hoy usa `UserDefaults`. |
| `HKDesignSystem` | Tokens, tema, componentes Liquid Glass | Sin conocimiento del dominio. |
| `HKPresentation` | Vistas, ViewModels, coordinadores, routers | Depende de protocolos de casos de uso, nunca de `HKData`. |

## Dependencias externas

Ninguna. Solo frameworks de Apple (SwiftUI, Observation, Foundation, Swift
Testing). Una librería de terceros requiere aprobación y se registra en la
tabla "Dependencias" del README raíz, en el README del paquete y aquí.

## Inyección de dependencias

- `HireKit/DI/AppDependencies.swift` es la raíz de composición. Registra
  fuentes de datos, repositorios y casos de uso en `HKContainer`, e implementa
  `HKViewModelFactory`.
- Las vistas reciben `any HKViewModelFactory` y crean sus ViewModels con él.
  Nunca resuelven del contenedor.
- `HKPreviewViewModelFactory` (solo DEBUG) alimenta las vistas previas con
  datos en memoria.

## Concurrencia

- ViewModels, routers y coordinadores son `@MainActor @Observable`.
- Casos de uso y repositorios son `Sendable` y `async`.
- Upcoming features activas en todos los paquetes: `ApproachableConcurrency` y
  `MemberImportVisibility`.

## Añadir una funcionalidad

1. **Dominio:** entidad, contrato de repositorio, protocolo de caso de uso y su
   implementación `Default…`, un tipo por archivo.
2. **Datos:** fuente de datos e implementación del repositorio.
3. **Composición:** registro en `AppDependencies`.
4. **Fábrica:** método `make…ViewModel` en `HKViewModelFactory`,
   `AppDependencies` y `HKPreviewViewModelFactory`.
5. **Presentación:** ViewModel y vistas en `HKPresentation/Features/<Funcionalidad>/`.
   Si tiene pantallas propias, sigue [routing.md](routing.md).
6. **Pruebas** con Swift Testing en el paquete de cada capa.
7. **Documentación:** actualiza este documento, [business.md](business.md),
   [app.md](app.md), el README del paquete y el CHANGELOG.

## Pruebas

- Swift Testing en todos los paquetes (`@Test`, `#expect`).
- ViewModels, routers y coordinadores se prueban sin SwiftUI.
- El dominio usa repositorios en memoria; los datos usan una suite aislada de
  `UserDefaults`.
- `HireKitTests` prueba `AppDependencies` de punta a punta.
