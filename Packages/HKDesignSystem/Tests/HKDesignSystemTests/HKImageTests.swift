import SwiftUI
import Testing
@testable import HKDesignSystem

#if os(macOS)
import AppKit
#else
import UIKit
#endif

struct HKImageTests {
    @Test func mediaCatalogShipsInsideThePackage() {
        #if os(macOS)
        #expect(Bundle.module.image(forResource: "hk_placeholder") != nil)
        #else
        #expect(UIImage(named: "hk_placeholder", in: .module, with: nil) != nil)
        #endif
    }

    @Test func onlySystemSourcesAreSymbols() {
        #expect(HKImageSource.system("star").isSymbol)
        #expect(!HKImageSource.media("hk_placeholder").isSymbol)
        #expect(!HKImageSource.asset("logo").isSymbol)
        #expect(!HKImageSource.image(Image(systemName: "star")).isSymbol)
    }

    @Test func decorativeByDefault() {
        #expect(HKImageModel(source: .system("star")).accessibilityLabel == nil)
        #expect(HKImageModel(source: .system("star")).contentMode == .fit)
    }
}
