import CoreGraphics

/// A scatter of doodles that covers an area evenly without looking like a grid.
///
/// The field splits the area into square cells, staggers every other row,
/// leaves some cells empty and jitters each doodle inside its cell. The same
/// seed and size always give the same doodles, so the pattern stays put across
/// renders and only the drift animates.
struct HKDoodleField: Sendable {
    /// The side of one cell, in points.
    let cellSize: CGFloat

    /// The value that picks one arrangement among all possible ones.
    let seed: UInt64

    /// The share of cells left empty, from 0 to 1.
    let emptyRatio: Double

    init(cellSize: CGFloat = 92, seed: UInt64 = 2027, emptyRatio: Double = 0.2) {
        self.cellSize = cellSize
        self.seed = seed
        self.emptyRatio = emptyRatio
    }

    /// Returns the doodles that cover an area.
    ///
    /// - Parameter size: The size of the area.
    /// - Returns: The doodles, ordered by row and column. It is empty when the
    ///   area has no width or height.
    func doodles(in size: CGSize) -> [HKDoodle] {
        guard size.width > 0, size.height > 0, cellSize > 0 else { return [] }
        let columns = Int((size.width / cellSize).rounded(.up))
        let rows = Int((size.height / cellSize).rounded(.up))
        var doodles: [HKDoodle] = []
        for row in 0..<rows {
            for column in 0..<columns {
                let index = row * columns + column
                guard random(index, salt: 0) >= emptyRatio else { continue }
                doodles.append(doodle(row: row, column: column, index: index))
            }
        }
        return doodles
    }

    private func doodle(row: Int, column: Int, index: Int) -> HKDoodle {
        let stagger = row.isMultiple(of: 2) ? 0 : 0.5
        let x = (Double(column) + 0.5 + stagger + jitter(index, salt: 1)) * cellSize
        let y = (Double(row) + 0.5 + jitter(index, salt: 2)) * cellSize
        return HKDoodle(
            kind: pick(HKDoodleKind.allCases, index, salt: 3),
            center: CGPoint(x: x, y: y),
            size: 18 + random(index, salt: 4) * 14,
            rotation: (random(index, salt: 5) - 0.5) * .pi / 2,
            phase: random(index, salt: 6) * 2 * .pi,
            speed: 0.12 + random(index, salt: 7) * 0.18,
            tint: pick(HKDoodle.Tint.allCases, index, salt: 8)
        )
    }

    private func jitter(_ index: Int, salt: UInt64) -> Double {
        (random(index, salt: salt) - 0.5) * 0.5
    }

    private func pick<Element>(_ elements: [Element], _ index: Int, salt: UInt64) -> Element {
        elements[min(Int(random(index, salt: salt) * Double(elements.count)), elements.count - 1)]
    }

    private func random(_ index: Int, salt: UInt64) -> Double {
        var value = seed &+ UInt64(truncatingIfNeeded: index) &* 0x9E37_79B9_7F4A_7C15 &+ salt &* 0xD1B5_4A32_D192_ED03
        value = (value ^ (value >> 30)) &* 0xBF58_476D_1CE4_E5B9
        value = (value ^ (value >> 27)) &* 0x94D0_49BB_1331_11EB
        value ^= value >> 31
        return Double(value >> 11) / Double(UInt64(1) << 53)
    }
}
