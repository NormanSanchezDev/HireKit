import SwiftUI

/// A titled date field on a Liquid Glass surface where people type the date
/// as digits or pick it from a calendar.
///
/// Typing `04061994` shows `04/06/1994`. Deleting a slash also deletes the
/// digit before it. The binding holds a date only when the text names a real
/// day; otherwise it is `nil`. The calendar button opens a graphical calendar
/// limited to the model's range, and Done saves its date.
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
    @FocusState private var isFocused: Bool
    @State private var text = ""
    @State private var isCalendarPresented = false
    @State private var draft = Date.now

    private let model: HKDatePickerModel

    /// Creates a date field.
    ///
    /// - Parameters:
    ///   - model: The content and configuration of the field.
    ///   - date: The date the text describes, or `nil` when it describes none.
    public init(model: HKDatePickerModel, date: Binding<Date?>) {
        self.model = model
        _date = date
    }

    private var isEnabled: Bool { model.isEnabled && parentIsEnabled }

    public var body: some View {
        HKFieldContainer(
            title: model.title,
            validation: model.validation,
            isEnabled: isEnabled,
            isFocused: isFocused || isCalendarPresented
        ) {
            TextField(model.placeholder, text: $text)
                .textFieldStyle(.plain)
                #if os(iOS)
                .keyboardType(.numberPad)
                #endif
                .monospacedDigit()
                .focused($isFocused)
                .accessibilityLabel(Text(fieldTitle: model.title, isRequired: model.isRequired))
                .accessibilityHint(model.validation.feedback(in: theme.colors)?.description ?? Text("common_date_format_hint"))
            Button("common_date_open_calendar", systemImage: "calendar", action: openCalendar)
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
                .foregroundStyle(theme.colors.primary)
                .frame(minWidth: theme.spacing.minimumHitTarget, minHeight: theme.spacing.minimumHitTarget)
                .contentShape(.rect)
                .popover(isPresented: $isCalendarPresented) {
                    calendarPanel
                }
        }
        .disabled(!model.isEnabled)
        .onAppear(perform: showDate)
        .onChange(of: text) { oldText, newText in applyMask(from: oldText, to: newText) }
        .onChange(of: date) { _, newDate in
            if parsedDate != newDate { showDate() }
        }
        .onChange(of: isEnabled) { _, enabled in
            if !enabled {
                isFocused = false
                isCalendarPresented = false
            }
        }
    }

    private var parsedDate: Date? {
        HKDateFormat.date(fromDigits: HKDateFormat.digits(in: text), calendar: calendar)
    }

    private var calendarPanel: some View {
        VStack(spacing: theme.spacing.medium) {
            DatePicker(model.title, selection: $draft, in: model.range, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .labelsHidden()
            Button("common_done", action: confirmCalendar)
                .buttonStyle(.glassProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(theme.spacing.large)
        .frame(minWidth: 320)
        .tint(theme.colors.primary)
        .presentationCompactAdaptation(.popover)
    }

    private func showDate() {
        if let date {
            text = HKDateFormat.text(for: date, calendar: calendar)
        } else if parsedDate != nil {
            text = ""
        }
    }

    private func applyMask(from oldText: String, to newText: String) {
        let formatted = HKDateFormat.edit(from: oldText, to: newText)
        if formatted != newText {
            text = formatted
            return
        }
        let newDate = parsedDate
        if date != newDate { date = newDate }
    }

    private func openCalendar() {
        isFocused = false
        let start = parsedDate ?? model.range.upperBound
        draft = min(max(start, model.range.lowerBound), model.range.upperBound)
        isCalendarPresented = true
    }

    private func confirmCalendar() {
        date = draft
        isCalendarPresented = false
    }
}

#Preview("Date field states") {
    @Previewable @State var empty: Date?
    @Previewable @State var typed: Date? = Date(timeIntervalSince1970: 770_688_000)
    let range = Date.distantPast...Date.now
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            HKDatePicker(model: .init(title: "sign_up_birth_date_txt", range: range, isRequired: true), date: $empty)
            HKDatePicker(model: .init(title: "sign_up_birth_date_txt", range: range), date: $typed)
            HKDatePicker(model: .init(title: "sign_up_birth_date_txt", range: range, errorMessage: "sign_up_birth_date_underage_txt"), date: $typed)
            HKDatePicker(model: .init(title: "sign_up_birth_date_txt", range: range, isEnabled: false), date: $typed)
        }
        .padding()
    }
    .hkBackground()
}
