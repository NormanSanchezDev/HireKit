import HKCore
import Testing

@MainActor
struct HKContainerTests {
    private final class Counter {
        let id: Int
        init(id: Int) { self.id = id }
    }

    private protocol Greeter { func greet() -> String }
    private struct SpanishGreeter: Greeter { func greet() -> String { "Hola" } }

    @Test func transientCreatesNewInstanceEachTime() {
        let container = HKContainer()
        var next = 0
        container.register(Counter.self) { _ in
            next += 1
            return Counter(id: next)
        }
        #expect(container.resolve(Counter.self).id == 1)
        #expect(container.resolve(Counter.self).id == 2)
    }

    @Test func singletonReusesInstance() {
        let container = HKContainer()
        container.register(Counter.self, lifetime: .singleton) { _ in Counter(id: 7) }
        #expect(container.resolve(Counter.self) === container.resolve(Counter.self))
    }

    @Test func resolvesProtocolRegistrations() {
        let container = HKContainer()
        container.register((any Greeter).self) { _ in SpanishGreeter() }
        #expect(container.resolve((any Greeter).self).greet() == "Hola")
    }

    @Test func factoriesCanResolveTheirDependencies() {
        let container = HKContainer()
        container.register(Int.self) { _ in 3 }
        container.register(Counter.self) { Counter(id: $0.resolve()) }
        #expect(container.resolve(Counter.self).id == 3)
    }

    @Test func missingRegistrationReturnsNil() {
        #expect(HKContainer().resolveIfRegistered(Counter.self) == nil)
    }

    @Test func reRegisteringDropsCachedSingleton() {
        let container = HKContainer()
        container.register(Counter.self, lifetime: .singleton) { _ in Counter(id: 1) }
        _ = container.resolve(Counter.self)
        container.register(Counter.self, lifetime: .singleton) { _ in Counter(id: 2) }
        #expect(container.resolve(Counter.self).id == 2)
    }
}
