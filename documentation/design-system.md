# Design System

Paquete: `Packages/HKDesignSystem`. Todas las pantallas se construyen con estos
componentes. Leen `HKThemeManager` del entorno, que se inyecta una vez en la
raíz con `.environment(themeManager)`.

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
   `themeManager.current(for: colorScheme)`.
6. **Accesible por defecto.** Estilos de Dynamic Type, áreas de 44 pt, texto en
   los controles de solo icono y el color nunca como única señal.

## Catálogo

| Componente | Uso | Ejemplo |
| --- | --- | --- |
| `HKGlassCard` | Agrupar contenido sobre vidrio | `HKGlassCard(style: .tinted(.indigo)) { … }` |
| `HKGlassGroup` | Fundir vistas de vidrio cercanas | `HKGlassGroup(spacing: 12) { HStack(spacing: 12) { … } }` |
| `.hkGlass(_:isInteractive:in:)` | Controles de vidrio propios | `.hkGlass(.clear, in: .capsule)` |
| `HKBackground` / `.hkBackground()` | Fondo de pantalla detrás del vidrio: doodles animados sobre color sólido | `ScrollView { … }.hkBackground()` |
| `HKButton` | Acciones; `.primary` una vez por pantalla | `HKButton("Aplicar", systemImage: "paperplane") { … }` |
| `HKField` | Texto con validación | `HKField(model: .init(title: "Correo", errorMessage: error), text: $email)` |
| `HKImage` | Media, assets, recursos y SF Symbols | `HKImage(.media("hk_placeholder"))` |
| `HKLabel` | Texto con estilo del tema | `HKLabel("Inicio", type: .title, tone: .accent)` |
| `HKRowLabel` | Filas en `List` y `Form` | `HKRowLabel("Apariencia", systemImage: "paintpalette")` |

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
| Colores | `HKColors` | `primary` (índigo), `secondary` (verde azulado), `textPrimary`, `error` |
| Tipografía | `HKTypography` | `title`, `headline`, `body`, `caption`, `button`, `fieldLabel` |
| Espaciado | `HKSpacing` | `small`, `medium`, `large`, `extraLarge`, `minimumHitTarget` |
| Radios | `HKRadius` | `medium`, `large` |

## Añadir un componente

1. Carga las skills `swiftui-pro:swiftui-pro` y `ecc:liquid-glass-design`.
2. Crea una carpeta en `Components/`, un tipo por archivo. Usa un struct
   `…Model` cuando haya más de tres opciones.
3. Lee los tokens del tema y usa `.hkGlass` o un estilo de vidrio del sistema.
4. Documenta toda declaración pública con DocC `///`, con ejemplo de uso.
5. Añade `#Preview` de cada estado sobre `.hkBackground()` con
   `.environment(HKThemeManager(defaults: nil))`.
6. Prueba la lógica de los modelos en `Tests/HKDesignSystemTests`.
7. Actualiza este catálogo y el README del paquete.
