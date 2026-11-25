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
| Nombre(s) y apellido paterno (registro) | Obligatorios | "Este campo es obligatorio." |
| Nombre(s) y apellidos (registro) | Mayúscula inicial, al menos 2 letras, solo letras, espacios, apóstrofo y guion (`PersonName.isValid`) | "Usa solo letras, empieza con mayúscula y escribe al menos 2 letras." |
| Apellido materno (registro) | Opcional; si se escribe, sigue la regla anterior | Igual que arriba |
| Fecha de nacimiento (registro) | Obligatoria | "Selecciona tu fecha de nacimiento." |
| Fecha de nacimiento (registro) | Al menos 18 años cumplidos, sin fechas futuras (`BirthDateRule`) | "Debes tener al menos 18 años." |
| Teléfono (registro) | Obligatorio | "Escribe tu número de teléfono." |
| Teléfono (registro) | Exactamente 10 dígitos (`PhoneNumber`) | "El número debe tener 10 dígitos." |

Limpieza de nombres (`PersonName.cleaned`): al perder el foco y antes de
enviar, cada nombre pierde la puntuación y los dígitos, se colapsan los
espacios, se recortan los extremos y cada palabra empieza con mayúscula.
`"CArlos arTURO"` queda `"Carlos Arturo"` y `" Carlos.  Arturo "` queda
`"Carlos Arturo"`.

Teléfono: la lada se elige entre 🇲🇽 +52 y 🇺🇸 +1 (`DialCode`). El número se
muestra como `(56) 25 06 83 70` mientras se escribe y se guarda solo con
dígitos (`5625068370`); la lada va en otra columna. El selector de fecha solo
ofrece fechas entre 120 y 18 años atrás.

Antes de enviar, los casos de uso normalizan los datos: el correo se recorta y
pasa a minúsculas, los nombres se limpian, un apellido materno vacío se guarda
como `null` y la contraseña no cambia.

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
vuelve a inicio de sesión.

El perfil viaja en los metadatos del registro con las claves `first_name`,
`paternal_last_name`, `maternal_last_name`, `birth_date` (`yyyy-MM-dd`),
`dial_code` y `phone`. El trigger `on_auth_user_created`
(`supabase/migrations/20261125120000_create_profiles.sql`) los copia a
`public.profiles`, que tiene RLS: cada persona solo puede leer y actualizar su
propia fila. La tabla repite las reglas con `check` (2 letras, 18 años, lada
`+52`/`+1`, 10 dígitos). El nombre visible de `AuthUser` es
`first_name` + `paternal_last_name`.

## Inicio

| Regla | Dónde se aplica |
| --- | --- |
| Saludo: "Buenos días" de 5:00 a 11:59, "Buenas tardes" de 12:00 a 18:59, "Buenas noches" el resto. | `HomeViewModel.greeting` |

## Preferencias

| Regla | Dónde se aplica |
| --- | --- |
| El tema puede ser Sistema, Claro u Oscuro, y se guarda en el dispositivo. | `HKThemeManager`, `AppearanceView` |
