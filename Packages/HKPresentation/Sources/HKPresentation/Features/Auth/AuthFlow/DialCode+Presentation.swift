import HKDesignSystem
import HKDomain
import SwiftUI

extension DialCode {
    /// The calling codes as dropdown options, with a flag and a spoken name.
    static var dropdownOptions: [HKDropdownOption<DialCode>] {
        allCases.map { HKDropdownOption(value: $0, title: "\($0.flag) \($0.rawValue)", accessibilityLabel: $0.accessibilityLabel) }
    }

    private var flag: String {
        switch self {
        case .mexico: "🇲🇽"
        case .unitedStates: "🇺🇸"
        }
    }

    private var accessibilityLabel: LocalizedStringKey {
        switch self {
        case .mexico: "common_dial_code_mexico"
        case .unitedStates: "common_dial_code_united_states"
        }
    }
}
