import Foundation
import Observation

/// The state of the dashboard tab.
@MainActor
@Observable
public final class HomeViewModel {
    /// The part of the day used to greet the user.
    public enum Greeting: Equatable, Sendable {
        /// From 5:00 to 11:59.
        case morning

        /// From 12:00 to 18:59.
        case afternoon

        /// From 19:00 to 4:59.
        case evening
    }

    private let now: () -> Date
    private let calendar: Calendar

    /// Creates the ViewModel.
    ///
    /// - Parameters:
    ///   - now: Returns the current date. Tests pass a fixed date.
    ///   - calendar: The calendar used to read the hour.
    public init(now: @escaping () -> Date = Date.init, calendar: Calendar = .current) {
        self.now = now
        self.calendar = calendar
    }

    /// The greeting for the current time of day.
    public var greeting: Greeting {
        switch calendar.component(.hour, from: now()) {
        case 5..<12: .morning
        case 12..<19: .afternoon
        default: .evening
        }
    }
}
