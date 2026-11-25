# Negocio

Reglas que la app aplica hoy y el modelo de dominio que las sostiene. El
dominio vive en `HKDomain` y no depende de SwiftUI ni de cómo se guardan los
datos.

## Bienvenida (onboarding)

| Regla | Dónde se aplica |
| --- | --- |
| Una persona nueva ve la bienvenida al abrir la app. | `RootViewModel.load()` con `OnboardingState.pending` |
| Al terminar la bienvenida, el progreso se guarda y se pasa al acceso. | `CompleteOnboardingUseCase`, `RootViewModel.onboardingFinished()` |
| Desde Ajustes se puede volver a ver la bienvenida. | `ResetOnboardingUseCase`, `RootViewModel.onboardingReset()` |
| Un valor guardado desconocido o dañado cuenta como `pending`, nunca salta la bienvenida. | `DefaultOnboardingRepository.currentState()` |

Modelo:

```
OnboardingState: pending | completed
OnboardingRepository ── currentState(), save(_:)
Casos de uso: GetOnboardingState, CompleteOnboarding, ResetOnboarding
```

## Acceso

Primero se valida el formulario en `AuthInputValidator`. Si es válido, el
ViewModel llama al caso de uso, que verifica las credenciales con Supabase Auth.

| Campo | Regla | Mensaje |
| --- | --- | --- |
| Correo | Obligatorio | "Ingresa tu correo." |
| Correo | Una `@`, usuario no vacío y dominio con punto interior | "Ingresa un correo válido." |
| Contraseña | Obligatoria | "Ingresa tu contraseña." |
| Contraseña | Al menos 8 caracteres | "Usa al menos 8 caracteres." |
| Nombre (registro) | Obligatorio, sin contar espacios | "Ingresa tu nombre." |

Antes de enviar, los casos de uso normalizan los datos: el correo se recorta y
pasa a minúsculas, el nombre se recorta y la contraseña no cambia.

| Caso de uso | Resultado |
| --- | --- |
| `SignInUseCase` | Usuario autenticado (`AuthUser`). |
| `SignUpUseCase` | `.signedIn` si Supabase devuelve sesión, `.confirmationRequired` si hay que confirmar el correo. |

| Error | Cuándo | Mensaje |
| --- | --- | --- |
| `invalidCredentials` | Correo o contraseña incorrectos | "El correo o la contraseña no son correctos." |
| `emailNotConfirmed` | Cuenta sin confirmar | "Confirma tu correo antes de iniciar sesión…" |
| `emailAlreadyRegistered` | Registro con un correo existente | "Ya existe una cuenta con este correo." |
| `weakPassword` | Supabase rechaza la contraseña | "La contraseña es muy débil…" |
| `rateLimited` | Demasiados intentos o correos | "Demasiados intentos…" |
| `network` | Sin conexión | "No hay conexión…" |
| `notConfigured` | Falta `Supabase.plist` | "El acceso no está disponible en este momento." |
| `unknown` | Cualquier otro error | "Algo salió mal…" |

Cuando el registro necesita confirmación, la app muestra "Revisa tu correo" y
vuelve a inicio de sesión. El nombre se guarda en los metadatos del usuario
con la clave `name`.

## Inicio

| Regla | Dónde se aplica |
| --- | --- |
| Saludo: "Buenos días" de 5:00 a 11:59, "Buenas tardes" de 12:00 a 18:59, "Buenas noches" el resto. | `HomeViewModel.greeting` |

## Preferencias

| Regla | Dónde se aplica |
| --- | --- |
| El tema puede ser Sistema, Claro u Oscuro, y se guarda en el dispositivo. | `HKThemeManager`, `AppearanceView` |
