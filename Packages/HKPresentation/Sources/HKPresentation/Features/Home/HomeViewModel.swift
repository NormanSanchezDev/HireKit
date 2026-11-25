import Foundation
import Observation

@MainActor
@Observable
public final class HomeViewModel {
    public enum Greeting: Equatable, Sendable {
        case morning
        case afternoon
        case evening
    }

    private let now: () -> Date
    private let calendar: Calendar

    public init(now: @escaping () -> Date = Date.init, calendar: Calendar = .current) {
        self.now = now
        self.calendar = calendar
    }

    public var greeting: Greeting {
        switch calendar.component(.hour, from: now()) {
        case 5..<12: .morning
        case 12..<19: .afternoon
        default: .evening
        }
    }
}
