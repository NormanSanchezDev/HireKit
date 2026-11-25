# App

## Propósito

HireKit acompaña a una persona durante un proceso de contratación. La meta es
reunir en un solo lugar cada proceso, sus etapas, entrevistas y próximos pasos,
para que nada se pierda entre correos y notas.

## Plataformas

| Plataforma | Mínimo | Presentación |
| --- | --- | --- |
| iPhone | iOS 27 | Barra de pestañas flotante de Liquid Glass que se minimiza al hacer scroll |
| iPad | iPadOS 27 | Pestañas que se convierten en barra lateral (`sidebarAdaptable`) |
| Mac | macOS 27 | Barra lateral, ventana redimensionable de 720 × 520 como mínimo |

La interfaz está disponible en español e inglés y usa Dynamic Type,
VoiceOver y áreas táctiles de 44 pt.

## Flujos actuales

```
Bienvenida ──▶ Acceso ──▶ Inicio
   ▲                        │
   └──── Ajustes: "Ver la bienvenida de nuevo"
```

| Flujo | Pantallas | Estado |
| --- | --- | --- |
| Bienvenida | `WelcomeView` | Completo. Guarda el progreso en el dispositivo. |
| Acceso | `SignInView`, `SignUpView` | Inicio de sesión y registro con Supabase Auth. El registro pide nombre(s), apellido paterno, apellido materno opcional, fecha de nacimiento, teléfono con lada, correo y contraseña, y puede pedir confirmar el correo. |
| Inicio · pestaña Inicio | `DashboardView`, `NotificationsView` | Saludo según la hora y estados vacíos. |
| Inicio · pestaña Ajustes | `SettingsView`, `AppearanceView`, `AboutView` | Tema claro, oscuro o del sistema; reinicio de la bienvenida. |

## Pendiente

- **Sesión.** Al reabrir la app tras la bienvenida se entra directo a Inicio,
  sin comprobar la sesión de Supabase. Falta un caso de uso de sesión actual y
  cerrar sesión.
- **Procesos de contratación.** El dominio aún no modela procesos, etapas ni
  entrevistas; el inicio muestra estados vacíos.
- **Notificaciones.** La pantalla existe pero no hay fuente de datos.
