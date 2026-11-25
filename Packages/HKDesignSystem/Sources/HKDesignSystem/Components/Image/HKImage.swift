import SwiftUI

///
/// HKImage shows any image: design system media, app asset, generated
/// `ImageResource`s or SF Symbols. Size it with `.frame` from the caller
///
public struct HKImage: View {
    private let model: HKImageModel

    public init(model: HKImageModel) {
        self.model = model
    }

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
