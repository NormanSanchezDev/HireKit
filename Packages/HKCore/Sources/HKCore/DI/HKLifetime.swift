/**
 * How long a registered dependency lives inside `HKContainer`.
 */
public enum HKLifetime: Sendable {
    /**
     * One shared instance, created on first resolve.
     */
    case singleton

    /**
     * A new instance on every resolve.
     */
    case transient
}
