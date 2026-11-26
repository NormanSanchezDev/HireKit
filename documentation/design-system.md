# Design System

Paquete: `Packages/HKDesignSystem`. Todas las pantallas se construyen con estos
componentes.

## Tema

Cualquier vista lee los tokens con una sola línea:

```swift
struct OfferRow: View {
    @Environment(\.hkTheme) private var theme

    var body: some View {
        Text("Oferta aceptada")
            .foregroundStyle(theme.colors.success)
            .padding(theme.spacing.medium)
    }
}
```

- `HKTheme` reúne `colors`, `typography`, `spacing` y `radius`. Tiene valor por
  defecto en el entorno, así que vistas y previews no necesitan inyectarlo.
- Los colores salen del asset catalog y ya se adaptan a claro, oscuro y
  contraste aumentado. No hace falta leer `colorScheme` ni resolver colores.
- `HKThemeManager` solo guarda el modo elegido (Sistema, Claro u Oscuro). La
  raíz lo aplica con `.preferredColorScheme(themeManager.selectedMode.colorScheme)`
  y lo inyecta con `.environment(themeManager)` para la pantalla de Apariencia.
  Ninguna otra vista lo lee.

## Principios

1. **Liquid Glass primero.** Las superficies son vidrio, no rellenos opacos.
   Usa `HKGlassCard`, `.hkGlass(_:isInteractive:in:)` o los estilos de botón
   `.glass` y `.glassProminent`. Nunca imites el vidrio con materiales, blur o
   sombras.
2. **El vidrio necesita algo que refractar.** Pon las pantallas de vidrio sobre
   `.hkBackground()` o sobre contenido real.
3. **Agrupa el vidrio cercano.** Envuelve vistas de vidrio adyacentes en
   `HKGlassGroup` con el mismo espaciado que el layout interior.
4. **Interactivo solo si se toca.** `isInteractive: true` solo en vistas que
   responden a toques o al puntero.
5. **Tokens, no literales.** Colores, fuentes, espaciados y radios salen de
   `@Environment(\.hkTheme)`.
6. **Accesible por defecto.** Estilos de Dynamic Type, áreas de 44 pt, texto en
   los controles de solo icono y el color nunca como única señal.

## Localización

`HireKit/Localizable.xcstrings` reúne las traducciones en español e inglés. Las pantallas pasan claves `LocalizedStringKey` con el formato `<pantalla>_<función>_txt`, como `welcome_title_txt`. Los componentes usan `common_` para textos reutilizables, como `common_loading`. Las validaciones y las etiquetas de VoiceOver siguen la misma convención. Los valores que escribe la persona y los identificadores de imágenes y símbolos son `String`.

## Catálogo

| Componente | Uso | Ejemplo |
| --- | --- | --- |
| `HKGlassCard` | Agrupar contenido sobre vidrio | `HKGlassCard(style: .tinted(.indigo)) { … }` |
| `HKGlassGroup` | Fundir vistas de vidrio cercanas | `HKGlassGroup(spacing: 12) { HStack(spacing: 12) { … } }` |
| `.hkGlass(_:isInteractive:in:)` | Controles de vidrio propios | `.hkGlass(.clear, in: .capsule)` |
| `HKBackground` / `.hkBackground()` | Fondo de pantalla detrás del vidrio: doodles animados sobre color sólido | `ScrollView { … }.hkBackground()` |
| `HKButton` | Acciones; `.filled` una vez por pantalla | `HKButton(model: .init(title: "common_apply", systemImage: "paperplane") { … })` |
| `HKField` | Texto con validación; `capitalization: .words` para nombres y `onEditingEnded` al perder el foco | `HKField(model: .init(title: "sign_in_email_txt", errorMessage: error), text: $email)` |
| `HKDatePicker` | Fecha escrita con máscara `dd/mm/aaaa` (`HKDateFormat`); el botón de calendario abre un calendario gráfico limitado a un rango que guarda con "Listo" | `HKDatePicker(model: .init(title: "sign_up_birth_date_txt", range: range), date: $birthDate)` |
| `HKDropdown` | Menú compacto de opciones, sin superficie propia | `HKDropdown(title: "common_dial_code", options: options, selection: $code)` |
| `HKPhoneField` | Lada (`HKDropdown`) y número con máscara `(XX) XX XX XX XX`; enlaza solo dígitos | `HKPhoneField(model: model, dialCode: $code, digits: $digits)` |
| `HKAnimation` | Animación Lottie decorativa en bucle; muestra el primer cuadro con Reduce Motion y una imagen alternativa si el archivo no carga; oculta a VoiceOver | `HKAnimation(model: .init(name: "hk_sign_up", fallback: .system("person.crop.circle.badge.plus")))` |
| `HKStepCarousel` | Carrusel paginado de tarjetas de vidrio con indicador; el dueño decide la página, así puede avanzar con un temporizador | `HKStepCarousel(model: state.carousel, onSelect: viewModel.select)` |
| `HKImage` | Media, assets, recursos y SF Symbols | `HKImage(.media("hk_placeholder"))` |
| `HKLabel` | Texto con estilo del tema | `HKLabel("dashboard_navigation_title_txt", type: .title, tone: .accent)` |
| `HKActionPrompt` | Texto de apoyo y acción en línea | `HKActionPrompt(model: prompt) { viewModel.continue() }` |
| `HKRowLabel` | Filas en `List` y `Form` | `HKRowLabel("settings_appearance_row_txt", systemImage: "paintpalette")` |

Los campos comparten `HKFieldContainer`: título, superficie de vidrio, contorno
de foco o validación y mensaje inferior. Un componente de entrada nuevo debe
usarlo en vez de copiar ese marco.

## Fondo

`HKBackground` dibuja doodles a mano alzada (ondas, rizos, destellos, cruces,
anillos, zigzags, puntos) y símbolos de contratación (maletín, currículum,
persona, sello, chat) sobre `colors.background`. No usa degradados.

- **Color:** cada doodle usa `primary`, `secondary` o `textSecondary` con
  opacidad 0,22 en claro y 0,3 en oscuro.
- **Distribución:** `HKDoodleField` reparte los doodles en celdas de 92 pt con
  filas alternas desplazadas, un 20 % de celdas vacías y desplazamiento
  aleatorio con semilla fija. El patrón no cambia entre renders.
- **Movimiento:** cada doodle flota hasta 10 pt alrededor de su centro y oscila
  ±0,3 rad, a ritmos distintos (`TimelineView` a 30 fps en un `Canvas`).
- **Reducir movimiento:** con la opción activa el fondo queda quieto.

`HKGlassStyle`: `.regular` por defecto, `.clear` sobre media rica,
`.tinted(color)` para resaltar una superficie.

## Tokens

| Token | Tipo | Ejemplos |
| --- | --- | --- |
| Colores | `HKColors` | `primary` (azul), `secondary` (lila), `textPrimary`, `error` |
| Tipografía | `HKTypography` | `title`, `headline`, `body`, `caption`, `button`, `fieldLabel` |
| Espaciado | `HKSpacing` | `small`, `medium`, `large`, `extraLarge`, `minimumHitTarget` |
| Radios | `HKRadius` | `medium`, `large` |

## Paleta por apariencia

Los colores de `Palette.xcassets` incluyen variantes de contraste aumentado. El fondo queda detrás del vidrio nativo. Reserva `textTertiary` para contenido secundario deshabilitado o decorativo.

| Rol | Claro | Oscuro |
| --- | --- | --- |
| `primary` | `#1755CF` | `#246BFD` |
| `secondary` | `#7737AA` | `#C084FC` |
| `success` | `#276C34` | `#6DCF77` |
| `error` | `#AD383F` | `#DC7170` |
| `warning` | `#825500` | `#FFB800` |
| `textPrimary` | `#00152D` | `#F0F8FE` |
| `textSecondary` | `#455161` | `#949AA5` |
| `textTertiary` | `#586473` | `#626772` |
| `background` | `#F0F8FE` | `#00152D` |
| `surface` | `#FFFFFF` | `#1E2027` |

## Añadir un componente

1. Carga las skills `swiftui-pro:swiftui-pro` y `ecc:liquid-glass-design`.
2. Crea una carpeta en `Components/`, un tipo por archivo. Usa un struct
   `…Model` cuando haya más de tres opciones.
3. Lee los tokens del tema y usa `.hkGlass` o un estilo de vidrio del sistema.
4. Documenta toda declaración pública con DocC `///`, con ejemplo de uso.
5. Añade `#Preview` de cada estado sobre `.hkBackground()`. Usa
   `.preferredColorScheme(.dark)` para la variante oscura.
6. Prueba la lógica de los modelos en `Tests/HKDesignSystemTests`.
7. Actualiza este catálogo y el README del paquete.
