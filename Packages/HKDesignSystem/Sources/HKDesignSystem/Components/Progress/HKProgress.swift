import SwiftUI

/// A themed progress indicator supporting indeterminate, circular and linear styles.
///
/// Configure the value, style and semantic tone with ``HKProgressModel``:
///
/// ```swift
/// HKProgress(model: .init(progress: 0.6, type: .linear, tone: .primary))
///
/// HKProgress(type: .indeterminate, label: "common_loading")
/// ```
///
/// Every tone resolves against the active ``HKTheme`` so the indicator adapts
/// to light, dark and high-contrast appearances.
public struct HKProgress: View {
    @Environment(\.hkTheme) private var theme

    @ScaledMetric(relativeTo: .body) private var circularSize: CGFloat = 32
    @ScaledMetric(relativeTo: .body) private var circularLineWidth: CGFloat = 4

    private let model: HKProgressModel

    /// Creates a progress indicator from its configuration.
    ///
    /// - Parameter model: The value, style and semantic tone of the indicator.
    public init(model: HKProgressModel) {
        self.model = model
    }

    /// Creates a progress indicator.
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
        self.model = HKProgressModel(progress: progress, type: type, tone: tone, label: label)
    }

    public var body: some View {
        let accentColor = model.tone.color(in: theme.colors)

        switch model.type {
        case .indeterminate:
            VStack(spacing: theme.spacing.medium) {
                ProgressView()
                    .tint(accentColor)
                if let label = model.label {
                    labelView(label, theme: theme)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(model.label.map { Text($0) } ?? Text("common_loading"))

        case .circular:
            VStack(spacing: theme.spacing.medium) {
                ZStack {
                    Circle()
                        .stroke(accentColor.opacity(0.2), lineWidth: circularLineWidth)
                    Circle()
                        .trim(from: 0, to: model.progress)
                        .stroke(
                            accentColor,
                            style: StrokeStyle(lineWidth: circularLineWidth, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.smooth, value: model.progress)
                }
                .frame(width: circularSize, height: circularSize)

                if let label = model.label {
                    labelView(label, theme: theme)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(model.label.map { Text($0) } ?? Text("common_loading"))
            .accessibilityValue(Text(model.progress, format: .percent.precision(.fractionLength(0))))

        case .linear:
            VStack(alignment: .leading, spacing: theme.spacing.small) {
                if let label = model.label {
                    labelView(label, theme: theme)
                }
                ProgressView(value: model.progress)
                    .progressViewStyle(.linear)
                    .tint(accentColor)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(model.label.map { Text($0) } ?? Text("common_loading"))
            .accessibilityValue(Text(model.progress, format: .percent.precision(.fractionLength(0))))
        }
    }

    private func labelView(_ text: LocalizedStringKey, theme: HKTheme) -> some View {
        Text(text)
            .font(theme.typography.caption)
            .foregroundStyle(theme.colors.textSecondary)
    }
}

#Preview("Progress styles") {
    VStack(spacing: 24) {
        HKProgress()
        HKProgress(progress: 0.65, type: .circular, label: "common_saving")
        HKProgress(progress: 0.45, type: .linear, label: "common_loading")
        HKProgress(model: .init(progress: 1.0, type: .linear, tone: .success))
        HKProgress(model: .init(progress: 0.8, type: .circular, tone: .warning))
        HKProgress(model: .init(progress: 0.25, type: .linear, tone: .error))
    }
    .padding()
    .hkBackground()
}

#Preview("Progress, dark and large text") {
    VStack(spacing: 24) {
        HKProgress(model: .init(type: .indeterminate, tone: .secondary, label: "common_loading"))
        HKProgress(model: .init(progress: 0.6, type: .circular, tone: .primary))
        HKProgress(model: .init(progress: 0.75, type: .linear, tone: .primary))
    }
    .padding()
    .hkBackground()
    .environment(\.dynamicTypeSize, .accessibility3)
    .preferredColorScheme(.dark)
}
