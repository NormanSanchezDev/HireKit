import SwiftUI
import Testing
@testable import HKDesignSystem

struct HKAnimationModelTests {
    @Test func signUpAnimationShipsInsideThePackage() {
        let model = HKAnimationModel(name: "hk_sign_up", fallback: .system("person.crop.circle.badge.plus"))
        #expect(model.animation != nil)
    }

    @Test func missingAnimationHasNoAnimationSoTheFallbackShows() {
        let model = HKAnimationModel(name: "missing_animation", fallback: .system("star"))
        #expect(model.animation == nil)
        #expect(model.fallback.isSymbol)
    }
}

struct HKStepCarouselModelTests {
    private let items = (0..<3).map {
        HKStepCarouselItem(id: $0, systemImage: "star", title: "titulo", description: "descripcion")
    }

    @Test func selectedIndexStaysInsideTheItems() {
        #expect(HKStepCarouselModel(items: items).selectedIndex == 0)
        #expect(HKStepCarouselModel(items: items, selectedIndex: 2).selectedIndex == 2)
        #expect(HKStepCarouselModel(items: items, selectedIndex: 7).selectedIndex == 2)
        #expect(HKStepCarouselModel(items: items, selectedIndex: -1).selectedIndex == 0)
    }

    @Test func emptyCarouselSelectsTheFirstPosition() {
        #expect(HKStepCarouselModel(items: []).selectedIndex == 0)
    }
}
