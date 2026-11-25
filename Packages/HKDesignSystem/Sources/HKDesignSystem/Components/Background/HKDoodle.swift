import CoreGraphics
import Foundation

/// One drawing of the ``HKBackground`` pattern and how it drifts over time.
struct HKDoodle: Hashable, Sendable {
    /// The theme color that strokes a doodle.
    enum Tint: CaseIterable, Sendable {
        case primary
        case secondary
        case neutral
    }

    /// The farthest a doodle moves from its resting center, in points.
    static let driftRadius: CGFloat = 10

    /// The largest extra turn a doodle sways by, in radians.
    static let swayAngle: Double = 0.3

    let kind: HKDoodleKind
    let center: CGPoint
    let size: CGFloat
    let rotation: Double
    let phase: Double
    let speed: Double
    let tint: Tint

    /// Returns where the doodle is drawn at a moment of the animation.
    ///
    /// The doodle drifts on a slow loop around ``center`` and sways around
    /// ``rotation``. Time zero is a fixed pose, which the background uses when
    /// Reduce Motion is on.
    ///
    /// - Parameter time: Seconds since the animation started.
    /// - Returns: A transform that moves the drawing's origin to its position
    ///   and turns it.
    func transform(at time: TimeInterval) -> CGAffineTransform {
        let angle = time * speed + phase
        let offsetX = sin(angle) * Self.driftRadius
        let offsetY = cos(angle * 0.8 + phase) * Self.driftRadius
        let turn = rotation + sin(angle * 0.7) * Self.swayAngle
        return CGAffineTransform(translationX: center.x + offsetX, y: center.y + offsetY)
            .rotated(by: turn)
    }
}
