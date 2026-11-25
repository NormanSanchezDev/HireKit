/// The visual style of an ``HKProgress`` indicator.
public enum HKProgressType: Sendable, Equatable {
    /// A spinning indicator for tasks whose duration is unknown.
    case indeterminate

    /// A circular ring showing determinate completion from `0` to `1`.
    case circular

    /// A horizontal bar showing determinate completion from `0` to `1`.
    case linear
}
