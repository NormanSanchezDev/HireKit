import CoreGraphics
import SwiftUI
import Testing
@testable import HKDesignSystem

struct HKDoodleFieldTests {
    private let size = CGSize(width: 390, height: 844)

    @Test func sameSeedGivesSamePattern() {
        #expect(HKDoodleField().doodles(in: size) == HKDoodleField().doodles(in: size))
    }

    @Test func otherSeedGivesOtherPattern() {
        #expect(HKDoodleField(seed: 1).doodles(in: size) != HKDoodleField(seed: 2).doodles(in: size))
    }

    @Test(arguments: [CGSize.zero, CGSize(width: 0, height: 500), CGSize(width: 500, height: 0)])
    func emptyAreaHasNoDoodles(size: CGSize) {
        #expect(HKDoodleField().doodles(in: size).isEmpty)
    }

    @Test func leavesSomeCellsEmpty() {
        let field = HKDoodleField(cellSize: 92)
        let cells = Int((size.width / 92).rounded(.up)) * Int((size.height / 92).rounded(.up))
        let count = field.doodles(in: size).count
        #expect(count > cells / 2)
        #expect(count < cells)
    }

    @Test func doodlesStayNearTheArea() {
        let margin = HKDoodleField().cellSize
        let bounds = CGRect(origin: .zero, size: size).insetBy(dx: -margin, dy: -margin)
        #expect(HKDoodleField().doodles(in: size).allSatisfy { bounds.contains($0.center) })
    }

    @Test func mixesLineDrawingsAndSymbols() {
        let kinds = HKDoodleField().doodles(in: size).map(\.kind)
        #expect(kinds.contains { $0.symbolName == nil })
        #expect(kinds.contains { $0.symbolName != nil })
    }

    @Test func driftStaysWithinRadius() throws {
        let doodle = try #require(HKDoodleField().doodles(in: size).first)
        for time in stride(from: 0.0, through: 120, by: 7.5) {
            let origin = CGPoint.zero.applying(doodle.transform(at: time))
            #expect(abs(origin.x - doodle.center.x) <= HKDoodle.driftRadius + 0.001)
            #expect(abs(origin.y - doodle.center.y) <= HKDoodle.driftRadius + 0.001)
        }
    }

    @Test func lineDrawingsHavePathsAndSymbolsDoNot() {
        let rect = CGRect(x: 0, y: 0, width: 24, height: 24)
        for kind in HKDoodleKind.allCases {
            #expect(kind.path(in: rect).isEmpty == (kind.symbolName != nil))
        }
    }
}
