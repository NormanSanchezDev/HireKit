# Routing

La navegación tiene dos niveles. Ambos viven en `HKPresentation`.

## 1. Flujos

`RootViewModel.destination` elige el flujo que ocupa toda la pantalla:

```
loading ──▶ welcome ──▶ auth ──▶ home
                ▲                  │
                └── onboardingReset┘
```

Cambiar de flujo reemplaza la pantalla completa, así que no hay botón "atrás"
entre flujos. `HKRootView` anima el cambio con `.blurReplace`.

## 2. Pantallas dentro de un flujo

Cada flujo tiene un `HKRouter<Route>`: una pila (`path`) y una hoja opcional
(`sheet`). `HKRouterStack` lo dibuja con `NavigationStack(path:)` y
`.sheet(item:)`, usando el mismo constructor de pantallas para ambos.

| Pieza | Responsabilidad |
| --- | --- |
| `HKRoute` | Protocolo de las rutas; cada flujo declara su enum. |
| `HKRouter` | Estado: `push`, `pop`, `popToRoot`, `present`, `dismiss`, `show(_:)`. |
| `HKRouterStack` | Vista que enlaza un router con `NavigationStack` y la hoja. |
| Coordinador | Vista o clase que posee los routers y traduce callbacks en navegación. |

**Los ViewModels nunca ven un router.** Reciben closures como `onSignUp` u
`onAuthenticated`, y el coordinador las convierte en `push`, `present` o un
cambio de flujo.

### Acceso

| Ruta | Presentación | Desde |
| --- | --- | --- |
| `AuthRoute.signIn` | Raíz | — |
| `AuthRoute.signUp` | Push | "Crear cuenta" en inicio de sesión |

Coordinador: `AuthFlowView`. Si el registro pide confirmar el correo,
`onConfirmationRequired` hace `popToRoot()` y el usuario vuelve a inicio de
sesión.

### Inicio

`HomeCoordinator` guarda la pestaña seleccionada y un router por pestaña, así
cada pestaña recuerda su historial. `TabView(selection: $coordinator.selectedTab)`
se enlaza directamente; volver a elegir la pestaña activa la regresa a su raíz.

| Pestaña | Ruta | Presentación |
| --- | --- | --- |
| Inicio | `DashboardRoute.notifications` | Push |
| Ajustes | `SettingsRoute.appearance` | Push |
| Ajustes | `SettingsRoute.about` | Hoja |

### Deep links

`HomeCoordinator.open(_:)` recibe un `HomeDestination`, cambia de pestaña y
reemplaza su pila:

```swift
coordinator.open(.settings(.appearance))
coordinator.open(.dashboard())
```

## Añadir un flujo

1. Crea `<Flujo>Route: HKRoute`.
2. Crea la vista coordinadora con `@State private var router = HKRouter<<Flujo>Route>()`.
3. Dibuja con `HKRouterStack(router:) { raíz } destination: { route in … }`.
4. Pasa closures a los ViewModels; nunca el router.
5. Si es un flujo de pantalla completa, añade un caso a `RootViewModel.Destination`.
6. Prueba el router o el coordinador sin SwiftUI y actualiza este documento.
