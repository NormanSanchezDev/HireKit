# HKDesignSystem

Tokens, tema y componentes Liquid Glass de HireKit. Los principios y el catálogo completo están en [documentation/design-system.md](../../documentation/design-system.md).

La paleta de `HKColors` incluye tres niveles de texto, colores de estado y variantes claras, oscuras y de contraste aumentado. `HKLabelTone.tertiary` aplica el tercer nivel.

Los textos de los componentes reciben `LocalizedStringKey` y se resuelven en el catálogo `Localizable.xcstrings` de la aplicación.

## Dependencias

Ninguna. SwiftUI y Observation.

## Contenido

```
Sources/HKDesignSystem/
├── Tokens/      HKColors, HKTypography, HKSpacing, HKRadius, HKGlassStyle
├── Theme/       HKTheme, EnvironmentValues.hkTheme, HKThemeMode, HKThemeManager
├── Components/
│   ├── Background/ HKBackground, View.hkBackground (doodles animados)
│   ├── Glass/   HKGlassCard, HKGlassGroup, View.hkGlass
│   ├── Button/  HKButton, HKButtonModel, HKButtonType
│   ├── Field/   HKField, HKFieldModel, HKFieldValidation, HKFieldContentType,
│   │            HKFieldCapitalization, HKFieldContainer (interno)
│   ├── DatePicker/ HKDatePicker, HKDatePickerModel
│   ├── Dropdown/ HKDropdown, HKDropdownOption
│   ├── PhoneField/ HKPhoneField, HKPhoneFieldModel, HKPhoneFormat
│   ├── Image/   HKImage, HKImageModel, HKImageSource
│   └── Label/   HKActionPrompt, HKActionPromptModel, HKLabel, HKLabelModel, HKLabelType, HKLabelTone, HKRowLabel
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
                    HKLabel("welcome_title_txt", type: .title, tone: .accent)
                }
                HKButton(model: .init(title: "common_continue", systemImage: "arrow.right") { })
            }
            .hkBackground()
            .environment(themeManager)
            .preferredColorScheme(themeManager.selectedMode.colorScheme)
        }
    }
}
```

En tus vistas, lee los tokens del entorno:

```swift
@Environment(\.hkTheme) private var theme

Text("Hola").foregroundStyle(theme.colors.primary)
```

## Pruebas

```bash
cd Packages/HKDesignSystem
xcodebuild test -scheme HKDesignSystem -destination 'platform=macOS' -derivedDataPath /tmp/dd-HKDesignSystem
```

`swift test` no compila `Media.xcassets`; usa siempre `xcodebuild`.
