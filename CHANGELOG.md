# Changelog

Todos los cambios importantes de HireKit se registran aquí.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y
el proyecto usa [Versionado Semántico](https://semver.org/lang/es/). Todavía
no hay versiones publicadas, así que el historial previo se agrupa por fecha y
commit.

## [Sin publicar]

### Añadido

- Registro completo: nombre(s), apellido paterno, apellido materno opcional,
  fecha de nacimiento (18 años mínimo), teléfono con lada 🇲🇽 +52 / 🇺🇸 +1,
  correo y contraseña. Los nombres se limpian y capitalizan al perder el foco.
- Reglas de perfil en HKDomain: `PersonName`, `DialCode`, `PhoneNumber` y
  `BirthDateRule`.
- Tabla `public.profiles` con RLS y trigger `on_auth_user_created` en
  `supabase/migrations/20261125120000_create_profiles.sql`.
- Componentes `HKDatePicker`, `HKDropdown` y `HKPhoneField` (con
  `HKPhoneFormat`), `HKDateFormat` para escribir la fecha como `ddmmaaaa` con
  máscara `dd/mm/aaaa`, y `HKFieldCapitalization` y `onEditingEnded` en `HKField`.
- Textos del registro en español e inglés.

- Inicio de sesión y registro con Supabase Auth: casos de uso `SignInUseCase` y
  `SignUpUseCase`, `AuthRepository` y `AuthenticationError` en HKDomain, y
  `SupabaseAuthRemoteDataSource` y `DefaultAuthRepository` en HKData.
- Dependencia Supabase Swift 2.55.8 en HKData.
- `HireKit/Supabase.plist` para la URL y la clave publicable de Supabase,
  ignorado por Git.
- Mensajes de error de acceso y aviso "Revisa tu correo" en español e inglés.
- Conexiones salientes en el sandbox de macOS.
- Componente `HKActionPrompt` para combinar texto de apoyo y una acción accesible en línea.

- `HKBackground` y `.hkBackground()`: fondo de doodles animados que se adapta a
  modo claro y oscuro y respeta Reducir movimiento.
- `README.md` con banner, badges, requisitos, estructura y tabla de dependencias.
- `CHANGELOG.md`.
- README en cada paquete: HKCore, HKDomain, HKData, HKDesignSystem y HKPresentation.
- Carpeta `documentation/` con app, negocio, arquitectura, routing y design system.
- `HomeCoordinator.selectedTab` ahora es asignable, para enlazar `TabView` sin
  `Binding(get:set:)`.
- `isShowingError` en `WelcomeViewModel` y `SettingsViewModel` para enlazar alertas.
- Vistas previas de `HKButton` en modo oscuro y con texto de accesibilidad grande.

### Cambiado

- `NewAccount` reemplaza `name` por el perfil completo y
  `AuthRemoteDataSource.signUp` recibe un `RemoteNewProfile`. Supabase guarda
  el perfil en metadatos con claves `first_name`, `paternal_last_name`, etc.
- `HKField`, `HKDatePicker` y `HKPhoneField` comparten `HKFieldContainer`.

- El tema se lee con `@Environment(\.hkTheme) private var theme` y
  `theme.colors…`. Ya no hace falta `colorScheme` ni `current(for:)`, y las
  previews no necesitan inyectar `HKThemeManager`, que ahora solo guarda el
  modo Sistema, Claro u Oscuro.
- Inicio de sesión y registro se configuran al aparecer con `SignInUIState` y
  `SignUpUIState`, propiedad de su ViewModel, y muestran carga y errores.
- Si el registro pide confirmar el correo, la app avisa y vuelve a inicio de sesión.
- `AppDependencies` recibe el `Bundle` del que lee la configuración de Supabase.
- La bienvenida se configura al aparecer mediante `WelcomeUIState` en su ViewModel.

- Textos, validaciones y etiquetas de accesibilidad disponibles en español e inglés desde un catálogo de cadenas compartido.

- `HKButton` recibe `HKButtonModel` en bienvenida y autenticación, y admite las variantes `filled`, `outline` y `text`.

- Nueva paleta azul y lila para Liquid Glass, con fondo azul marino en modo oscuro y variantes de contraste aumentado.

- Todas las pantallas usan `.hkBackground()` en lugar de `.hkBackdrop()`.
- Un tipo por archivo en HKDomain, HKData y HKPresentation (casos de uso,
  fuente de datos, vistas de auth, home y ajustes, rutas de home).
- Documentación DocC `///` en todas las declaraciones públicas de HKDomain,
  HKData y HKPresentation.
- Las pantallas usan los inicializadores cortos `HKLabel(_:type:tone:)` y
  `HKRowLabel(_:systemImage:)`.
- Las acciones de auth se agrupan en `HKGlassGroup`.
- Textos de la bienvenida traducidos al español ("¿Listo para empezar?", "Empecemos").
- Las instrucciones para agentes en `.claude/` apuntan a `documentation/` y
  exigen mantener README, CHANGELOG y documentación al día.

### Eliminado

- Campo único "Nombre" del registro y la clave de metadatos `name`.

- `HKThemeManager.current` y `current(for:)`, y `AppearanceColor`, sustituidos
  por `EnvironmentValues.hkTheme`.
- `HKBackdrop` y `.hkBackdrop()` (degradado `MeshGradient`), reemplazados por
  `HKBackground`.
- `dismissError()` en `WelcomeViewModel` y `SettingsViewModel`, reemplazado por
  `isShowingError`.
- `HKButtonPreviews.swift`, duplicado de las vistas previas de `HKButton`, que
  además usaba `glassEffect` directamente.
- `.claude/docs/`, sustituida por `documentation/`.

## 2026-11-25 · `9f12a51` Integración con agentes de IA

### Añadido

- `HKGlassStyle` y el modificador `.hkGlass(_:isInteractive:in:)`.
- `HKButton(_:systemImage:)`, `HKLabel(_:type:tone:)` y `HKRowLabel(_:systemImage:)`.
- Pruebas de los modelos del design system.
- `.claude/CLAUDE.md` con requisitos, skills, graphify y rtk.

### Cambiado

- Componentes del design system orientados a Liquid Glass; `HKField` sobre vidrio.
- Documentación `/** */` convertida a DocC `///` en todo el repositorio.

## 2026-11-25 · `22f4557` Routing

### Añadido

- `HKRouter` genérico, `HKRouterStack` y `HKRoute`.
- Flujo de acceso con inicio de sesión, registro y validación local.
- Inicio con `TabView` Liquid Glass y un router por pestaña (`HomeCoordinator`).

## 2026-11-24 · `e9713ad` Arquitectura

### Añadido

- Paquetes HKCore, HKDomain y HKData; MVVM + Clean con raíz de composición.
- `HKImage` con imágenes del catálogo, assets, recursos y SF Symbols.

## 2026-11-24 · `44db5db`, `87e7e5d`, `6feab1f` Inicio del proyecto

### Añadido

- Proyecto inicial con HKDesignSystem y HKPresentation.
- `HKButton`, `HKLabel` y `HKField`.
