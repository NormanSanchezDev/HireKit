import SwiftUI

/// A resizable image from any source: design system media, app assets,
/// generated image resources or SF Symbols.
///
/// The image keeps its aspect ratio and fills the size its parent proposes.
/// Set the size from the caller:
///
/// ```swift
/// HKImage(.media("hk_placeholder"))
///     .frame(height: 160)
///
/// HKImage(model: .init(
///     source: .system("briefcase.fill"),
///     tint: .indigo,
///     accessibilityLabel: "Empleo"
/// ))
/// .frame(width: 32, height: 32)
/// ```
///
/// Images without an accessibility label are decorative and hidden from
/// VoiceOver. SF Symbols use hierarchical rendering.
public struct HKImage: View {
    private let model: HKImageModel

    /// Creates an image from a model.
    ///
    /// - Parameter model: The content and configuration of the image.
    public init(model: HKImageModel) {
        self.model = model
    }

    /// Creates a decorative image.
    ///
    /// - Parameters:
    ///   - source: The place the image loads from.
    ///   - contentMode: How the image fills the proposed space.
    ///   - tint: The color of SF Symbols and template images.
    public init(_ source: HKImageSource, contentMode: ContentMode = .fit, tint: Color? = nil) {
        self.init(model: HKImageModel(source: source, contentMode: contentMode, tint: tint))
    }

    public var body: some View {
        styled
            .aspectRatio(contentMode: model.contentMode)
            .accessibilityElement()
            .accessibilityLabel(model.accessibilityLabel.map { Text($0) } ?? Text(""))
            .accessibilityAddTraits(.isImage)
            .accessibilityHidden(model.accessibilityLabel == nil)
    }

    @ViewBuilder
    private var styled: some View {
        let image = model.source.image
        if model.source.isSymbol {
            image
                .resizable()
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(model.tint ?? .primary)
        } else if let tint = model.tint {
            image
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(tint)
        } else {
            image.resizable()
        }
    }
}

#Preview("Image sources") {
    HStack(spacing: 24) {
        HKImage(.media("hk_placeholder"))
        HKImage(model: .init(
            source: .system("briefcase.fill"),
            tint: .indigo,
            accessibilityLabel: "Empleo"
        ))
        HKImage(.image(Image(systemName: "person.crop.circle")), tint: .teal)
    }
    .frame(height: 80)
    .padding()
}
