# HKDesignSystem

Tokens, tema y componentes Liquid Glass de HireKit. Los principios y el catálogo completo están en [documentation/design-system.md](../../documentation/design-system.md).

## Dependencias

Ninguna. SwiftUI y Observation.

## Contenido

```
Sources/HKDesignSystem/
├── Tokens/      HKColors, HKTypography, HKSpacing, HKRadius, HKGlassStyle
├── Theme/       HKTheme, HKThemeMode, HKThemeManager
├── Components/
│   ├── Background/ HKBackground, View.hkBackground (doodles animados)
│   ├── Glass/   HKGlassCard, HKGlassGroup, View.hkGlass
│   ├── Button/  HKButton
│   ├── Field/   HKField, HKFieldModel, HKFieldValidation, HKFieldContentType
│   ├── Image/   HKImage, HKImageModel, HKImageSource
│   └── Label/   HKLabel, HKLabelModel, HKLabelType, HKLabelTone, HKRowLabel
└── Resources/   Media.xcassets
```

## Uso

```swift
@main
struct HireKitApp: App {
    @State private var themeManager = HKThemeManager()

    var body: some Scene {
        WindowGroup {
            ScrollView {
                HKGlassCard {
                    HKLabel("Bienvenido", type: .title, tone: .accent)
                }
                HKButton("Continuar", systemImage: "arrow.right") { }
            }
            .hkBackground()
            .environment(themeManager)
        }
    }
}
```

## Pruebas

```bash
cd Packages/HKDesignSystem
xcodebuild test -scheme HKDesignSystem -destination 'platform=macOS' -derivedDataPath /tmp/dd-HKDesignSystem
```

`swift test` no compila `Media.xcassets`; usa siempre `xcodebuild`.
