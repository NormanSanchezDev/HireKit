/// The pages of an ``HKStepCarousel`` and the page on screen.
///
/// ```swift
/// HKStepCarouselModel(items: steps, selectedIndex: 1)
/// ```
public struct HKStepCarouselModel {
    /// The pages, in order.
    public let items: [HKStepCarouselItem]

    /// The position of the page on screen, always inside ``items``.
    public let selectedIndex: Int

    /// Creates a carousel model.
    ///
    /// - Parameters:
    ///   - items: The pages, in order.
    ///   - selectedIndex: The position of the page on screen. Values outside
    ///     `items` are clamped to the first or last page.
    public init(items: [HKStepCarouselItem], selectedIndex: Int = 0) {
        self.items = items
        self.selectedIndex = min(max(selectedIndex, 0), max(items.count - 1, 0))
    }
}
