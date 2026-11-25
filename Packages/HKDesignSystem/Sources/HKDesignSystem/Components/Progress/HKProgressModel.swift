import SwiftUI

/// The progress value, style and semantic color of an ``HKProgress``.
public struct HKProgressModel: Equatable {
    /// The normalized completion value in the range `0...1`.
    ///
    /// Used by ``HKProgressType/linear`` and ``HKProgressType/circular``.
    public let progress: Double

    /// The visual style of the progress indicator.
    public let type: HKProgressType

    /// The semantic color of the progress indicator.
    public let tone: HKProgressTone

    /// An optional localized label describing the ongoing task.
    public let label: LocalizedStringKey?

    /// Creates a progress model.
    ///
    /// - Parameters:
    ///   - progress: The completion fraction, clamped to `0...1`.
    ///   - type: The visual style of the indicator.
    ///   - tone: The semantic color resolved against the active theme.
    ///   - label: An optional localized description of the task.
    public init(
        progress: Double = 0,
        type: HKProgressType = .indeterminate,
        tone: HKProgressTone = .primary,
        label: LocalizedStringKey? = nil
    ) {
        self.progress = min(max(progress, 0), 1)
        self.type = type
        self.tone = tone
        self.label = label
    }
}
