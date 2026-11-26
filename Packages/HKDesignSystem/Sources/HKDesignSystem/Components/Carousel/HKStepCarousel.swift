import SwiftUI

/// A horizontally paged carousel of glass cards with a page indicator.
///
/// The carousel shows the model's selected page and reports every page the
/// person picks, by swiping or with the indicator. The owner decides the
/// selection, so it can also advance pages on a timer:
///
/// ```swift
/// HKStepCarousel(model: uiState.carousel) { index in
///     viewModel.select(index)
/// }
/// ```
///
/// Each indicator dot is a button with a spoken position such as
/// "Etapa 2 de 3". Page changes do not animate when Reduce Motion is on.
public struct HKStepCarousel: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.hkTheme) private var theme
    @ScaledMetric(relativeTo: .headline) private var iconSize = 32
    @State private var scrolledID: Int?

    private let model: HKStepCarouselModel
    private let onSelect: (Int) -> Void

    /// Creates a carousel.
    ///
    /// - Parameters:
    ///   - model: The pages and the page on screen.
    ///   - onSelect: Called with the position of a page the person picks.
    public init(model: HKStepCarouselModel, onSelect: @escaping (Int) -> Void) {
        self.model = model
        self.onSelect = onSelect
        _scrolledID = State(initialValue: model.selectedIndex)
    }

    public var body: some View {
        VStack(spacing: theme.spacing.small) {
            pages
            indicator
        }
        .onChange(of: model.selectedIndex) { _, index in
            withAnimation(reduceMotion ? nil : .smooth) {
                scrolledID = index
            }
        }
        .onChange(of: scrolledID) { _, index in
            guard let index, index != model.selectedIndex else { return }
            onSelect(index)
        }
    }

    private var pages: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(model.items) { item in
                    page(item)
                        .padding(.horizontal, theme.spacing.small)
                        .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .scrollPosition(id: $scrolledID)
    }

    private func page(_ item: HKStepCarouselItem) -> some View {
        HKGlassCard {
            VStack(alignment: .leading, spacing: theme.spacing.medium) {
                HKImage(.system(item.systemImage), tint: theme.colors.primary)
                    .frame(width: iconSize, height: iconSize)
                HKLabel(item.title, type: .headline)
                HKLabel(item.description, tone: .secondary)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .accessibilityElement(children: .combine)
    }

    private var indicator: some View {
        HStack(spacing: 0) {
            ForEach(model.items) { item in
                indicatorDot(for: item)
            }
        }
    }

    private func indicatorDot(for item: HKStepCarouselItem) -> some View {
        let isSelected = item.id == model.selectedIndex
        return Button(
            "common_carousel_page_\(item.id + 1)_of_\(model.items.count)",
            systemImage: isSelected ? "circle.fill" : "circle"
        ) {
            onSelect(item.id)
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.plain)
        .font(theme.typography.caption)
        .foregroundStyle(isSelected ? theme.colors.primary : theme.colors.textSecondary)
        .frame(minWidth: theme.spacing.minimumHitTarget, minHeight: theme.spacing.minimumHitTarget)
        .contentShape(.rect)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview("Step carousel") {
    @Previewable @State var selection = 0
    HKStepCarousel(model: .init(
        items: [
            .init(id: 0, systemImage: "person.text.rectangle", title: "Paso uno", description: "Descripción del primer paso."),
            .init(id: 1, systemImage: "envelope", title: "Paso dos", description: "Descripción del segundo paso."),
            .init(id: 2, systemImage: "checkmark.seal", title: "Paso tres", description: "Descripción del tercer paso."),
        ],
        selectedIndex: selection
    )) { selection = $0 }
    .padding()
    .hkBackground()
}
