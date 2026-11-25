/// A destination inside one navigation flow.
///
/// Each flow declares its own enum, so routes stay type-safe and a router can
/// only push screens of its own flow:
///
/// ```swift
/// enum SettingsRoute: HKRoute {
///     case appearance
///     case about
/// }
/// ```
public protocol HKRoute: Hashable, Identifiable, Sendable {}

extension HKRoute {
    /// The route itself, so routes can drive `sheet(item:)`.
    public var id: Self { self }
}
