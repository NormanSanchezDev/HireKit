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

Validación de formulario, en `AuthInputValidator`. No es autenticación real.

| Campo | Regla | Mensaje |
| --- | --- | --- |
| Correo | Obligatorio | "Ingresa tu correo." |
| Correo | Una `@`, usuario no vacío y dominio con punto interior | "Ingresa un correo válido." |
| Contraseña | Obligatoria | "Ingresa tu contraseña." |
| Contraseña | Al menos 8 caracteres | "Usa al menos 8 caracteres." |
| Nombre (registro) | Obligatorio, sin contar espacios | "Ingresa tu nombre." |

Cuando exista un backend, la verificación de credenciales será un caso de uso
de `HKDomain`, y `AuthInputValidator` seguirá solo como ayuda de formulario.

## Inicio

| Regla | Dónde se aplica |
| --- | --- |
| Saludo: "Buenos días" de 5:00 a 11:59, "Buenas tardes" de 12:00 a 18:59, "Buenas noches" el resto. | `HomeViewModel.greeting` |

## Preferencias

| Regla | Dónde se aplica |
| --- | --- |
| El tema puede ser Sistema, Claro u Oscuro, y se guarda en el dispositivo. | `HKThemeManager`, `AppearanceView` |
