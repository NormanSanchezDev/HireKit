import SwiftUI

/// A titled date field on a Liquid Glass surface that opens a calendar.
///
/// The field shows the date as `dd/mm/yyyy`, or the placeholder while it is
/// empty, with a calendar icon at the end. Tapping it opens a graphical
/// calendar limited to the model's range; the date is saved with Done.
///
/// ```swift
/// HKDatePicker(
///     model: .init(title: "sign_up_birth_date_txt", range: earliest...latest, isRequired: true),
///     date: $viewModel.birthDate
/// )
/// ```
public struct HKDatePicker: View {
    @Environment(\.hkTheme) private var theme
    @Environment(\.isEnabled) private var parentIsEnabled
    @Environment(\.calendar) private var calendar
    @Binding private var date: Date?
    @State private var isPresented = false
    @State private var draft = Date.now

    private let model: HKDatePickerModel

    /// Creates a date picker.
    ///
    /// - Parameters:
    ///   - model: The content and configuration of the field.
    ///   - date: The selected date, or `nil` when there is none.
    public init(model: HKDatePickerModel, date: Binding<Date?>) {
        self.model = model
        _date = date
    }

    private var isEnabled: Bool { model.isEnabled && parentIsEnabled }

    public var body: some View {
        HKFieldContainer(title: model.title, validation: model.validation, isEnabled: isEnabled, isFocused: isPresented) {
            Button(action: open) {
                HStack(spacing: theme.spacing.medium) {
                    dateText
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "calendar")
                        .foregroundStyle(theme.colors.primary)
                }
                .frame(minHeight: theme.spacing.minimumHitTarget)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text(fieldTitle: model.title, isRequired: model.isRequired))
            .accessibilityValue(date.map { Text($0, format: .dateTime.day().month(.wide).year()) } ?? Text("common_date_not_selected"))
            .accessibilityHint(model.validation.feedback(in: theme.colors)?.description ?? Text("common_date_picker_hint"))
            .popover(isPresented: $isPresented) {
                calendarPanel
            }
        }
        .disabled(!model.isEnabled)
        .onChange(of: isEnabled) { _, enabled in
            if !enabled { isPresented = false }
        }
    }

    @ViewBuilder
    private var dateText: some View {
        if let date {
            Text(verbatim: HKDatePickerModel.text(for: date, calendar: calendar))
                .monospacedDigit()
        } else {
            Text(model.placeholder)
                .foregroundStyle(theme.colors.textSecondary)
        }
    }

    private var calendarPanel: some View {
        VStack(spacing: theme.spacing.medium) {
            DatePicker(model.title, selection: $draft, in: model.range, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .labelsHidden()
            Button("common_done", action: confirm)
                .buttonStyle(.glassProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(theme.spacing.large)
        .frame(minWidth: 320)
        .tint(theme.colors.primary)
        .presentationCompactAdaptation(.popover)
    }

    private func open() {
        draft = clamped(date ?? model.range.upperBound)
        isPresented = true
    }

    private func confirm() {
        date = draft
        isPresented = false
    }

    private func clamped(_ value: Date) -> Date {
        min(max(value, model.range.lowerBound), model.range.upperBound)
    }
}

#Preview("Date picker states") {
    @Previewable @State var empty: Date?
    @Previewable @State var picked: Date? = Date(timeIntervalSince1970: 631_152_000)
    let range = Date.distantPast...Date.now
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            HKDatePicker(model: .init(title: "sign_up_birth_date_txt", range: range, isRequired: true), date: $empty)
            HKDatePicker(model: .init(title: "sign_up_birth_date_txt", range: range), date: $picked)
            HKDatePicker(model: .init(title: "sign_up_birth_date_txt", range: range, errorMessage: "sign_up_birth_date_underage_txt"), date: $picked)
            HKDatePicker(model: .init(title: "sign_up_birth_date_txt", range: range, isEnabled: false), date: $picked)
        }
        .padding()
    }
    .hkBackground()
}
