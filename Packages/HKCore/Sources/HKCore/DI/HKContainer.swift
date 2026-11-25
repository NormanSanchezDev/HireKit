import Foundation

/**
 * Lightweight, type-safe dependency container used only by the app's
 * composition root. Features never resolve from it directly: they receive
 * their dependencies through initializers.
 */
@MainActor
public final class HKContainer {
    private struct Registration {
        let lifetime: HKLifetime
        let factory: (HKContainer) -> Any
    }

    private var registrations: [ObjectIdentifier: Registration] = [:]
    private var instances: [ObjectIdentifier: Any] = [:]

    public init() {}

    /**
     * Registers how to build `Service`. Registering the same type again
     * replaces the previous registration and drops any cached instance.
     */
    public func register<Service>(
        _ type: Service.Type,
        lifetime: HKLifetime = .transient,
        factory: @escaping (HKContainer) -> Service
    ) {
        let key = ObjectIdentifier(type)
        registrations[key] = Registration(lifetime: lifetime) { factory($0) }
        instances[key] = nil
    }

    /**
     * Returns the registered `Service`, or nil when nothing was registered.
     */
    public func resolveIfRegistered<Service>(_ type: Service.Type = Service.self) -> Service? {
        let key = ObjectIdentifier(type)
        if let cached = instances[key] as? Service {
            return cached
        }
        guard let registration = registrations[key],
              let service = registration.factory(self) as? Service else {
            return nil
        }
        if registration.lifetime == .singleton {
            instances[key] = service
        }
        return service
    }

    /**
     * Returns the registered `Service`. A missing registration is a
     * programming error in the composition root and stops execution.
     */
    public func resolve<Service>(_ type: Service.Type = Service.self) -> Service {
        guard let service = resolveIfRegistered(type) else {
            preconditionFailure("HKContainer: no registration for \(Service.self)")
        }
        return service
    }
}
