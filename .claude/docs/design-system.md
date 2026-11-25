# HKDesignSystem

Package: `Packages/HKDesignSystem`. Every HireKit screen is built from these
components. Components read `HKThemeManager` from the environment, so inject it
once at the root: `.environment(themeManager)`.

## Principles

1. **Liquid Glass first.** Surfaces are glass, not opaque fills. Use
   `HKGlassCard`, `.hkGlass(_:isInteractive:in:)` or the system glass button
   styles. Never rebuild glass with materials, blurs or shadows.
2. **Glass needs something to refract.** Put glass screens on `.hkBackdrop()`
   or over real content.
3. **Group nearby glass.** Wrap adjacent glass views in `HKGlassGroup` with the
   same spacing as the layout inside, so they blend and morph.
4. **Interactive only when tappable.** `isInteractive: true` only on views that
   respond to touch or pointer input.
5. **Tokens, not literals.** Colors, fonts, spacing and radii come from
   `themeManager.current(for: colorScheme)`. Never hard-code values in
   components.
6. **Accessible by default.** Dynamic Type styles, 44 pt hit targets, text
   labels on icon-only controls, color never the only signal.

## Folder layout

```
Sources/HKDesignSystem/
├── Tokens/      HKColors, HKTypography, HKSpacing, HKRadius, HKGlassStyle
├── Theme/       HKTheme, HKThemeMode, HKThemeManager
├── Components/
│   ├── Glass/   HKGlassCard, HKGlassGroup, HKBackdrop, View.hkGlass
│   ├── Button/  HKButton (+ previews)
│   ├── Field/   HKField, HKFieldModel, HKFieldValidation, HKFieldContentType
│   ├── Image/   HKImage, HKImageModel, HKImageSource
│   └── Label/   HKLabel, HKLabelModel, HKLabelType, HKLabelTone, HKRowLabel
└── Resources/   Media.xcassets
```

## Catalog

| Component | Use for | Example |
| --- | --- | --- |
| `HKGlassCard` | Grouping content on glass | `HKGlassCard(style: .tinted(.indigo)) { … }` |
| `HKGlassGroup` | Blending adjacent glass views | `HKGlassGroup(spacing: 12) { HStack(spacing: 12) { … } }` |
| `.hkGlass(_:isInteractive:in:)` | Custom glass controls | `.hkGlass(.clear, in: .capsule)` |
| `HKBackdrop` / `.hkBackdrop()` | Screen background behind glass | `ScrollView { … }.hkBackdrop()` |
| `HKButton` | Actions; `.primary` once per screen | `HKButton("Aplicar", systemImage: "paperplane") { … }` |
| `HKField` | Text input with validation | `HKField(model: .init(title: "Correo", errorMessage: error), text: $email)` |
| `HKImage` | Media, assets, resources, SF Symbols | `HKImage(.media("hk_placeholder"))` |
| `HKLabel` | Themed text | `HKLabel("Inicio", type: .title, tone: .accent)` |
| `HKRowLabel` | Rows in `List` and `Form` | `HKRowLabel("Apariencia", systemImage: "paintpalette")` |

`HKGlassStyle`: `.regular` by default, `.clear` over rich media, `.tinted(color)`
to highlight one surface.

## Adding a component

1. Load `swiftui-pro:swiftui-pro` and `ecc:liquid-glass-design`.
2. Create a feature folder under `Components/`, one type per file. Put
   configuration in an `…Model` struct when there are more than three options.
3. Read tokens from the theme. Use `.hkGlass` or a system glass style for the
   surface.
4. Document every public declaration with `///` DocC, including a usage
   example in the type's discussion.
5. Add `#Preview`s for each state, on `.hkBackdrop()`, with
   `.environment(HKThemeManager(defaults: nil))`.
6. Add Swift Testing tests for model logic in `Tests/HKDesignSystemTests`.
7. Run the `swiftui-pro` review, then `xcodebuild test` on macOS and the iOS
   Simulator.
