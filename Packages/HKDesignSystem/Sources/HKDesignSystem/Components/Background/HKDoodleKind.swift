import SwiftUI

/// The drawing that a ``HKDoodle`` shows.
///
/// Line drawings are stroked paths. Hiring drawings are SF Symbols, so the
/// background speaks the language of the app without competing with content.
enum HKDoodleKind: CaseIterable, Sendable {
    case squiggle
    case curl
    case sparkle
    case plus
    case ring
    case zigzag
    case dots
    case briefcase
    case document
    case person
    case seal
    case chat

    /// The SF Symbol for hiring drawings, or `nil` for line drawings.
    var symbolName: String? {
        switch self {
        case .briefcase: "briefcase"
        case .document: "doc.text"
        case .person: "person"
        case .seal: "checkmark.seal"
        case .chat: "bubble.left"
        case .squiggle, .curl, .sparkle, .plus, .ring, .zigzag, .dots: nil
        }
    }

    /// Returns the outline of a line drawing that fits in a rectangle.
    ///
    /// - Parameter rect: The rectangle to draw in.
    /// - Returns: The path to stroke. It is empty for hiring drawings.
    func path(in rect: CGRect) -> Path {
        let point = { (x: CGFloat, y: CGFloat) in
            CGPoint(x: rect.minX + x * rect.width, y: rect.minY + y * rect.height)
        }
        var path = Path()
        switch self {
        case .squiggle:
            path.move(to: point(0, 0.5))
            path.addCurve(to: point(0.33, 0.5), control1: point(0.1, 0.15), control2: point(0.23, 0.15))
            path.addCurve(to: point(0.66, 0.5), control1: point(0.43, 0.85), control2: point(0.56, 0.85))
            path.addCurve(to: point(1, 0.5), control1: point(0.76, 0.15), control2: point(0.9, 0.15))
        case .curl:
            path.move(to: point(0, 0.75))
            path.addCurve(to: point(0.6, 0.3), control1: point(0.2, 0.1), control2: point(0.5, 0))
            path.addCurve(to: point(0.4, 0.55), control1: point(0.75, 0.6), control2: point(0.5, 0.75))
            path.addCurve(to: point(1, 0.35), control1: point(0.3, 0.3), control2: point(0.8, 0.15))
        case .sparkle:
            let center = point(0.5, 0.5)
            let tips = [point(0.5, 0), point(1, 0.5), point(0.5, 1), point(0, 0.5), point(0.5, 0)]
            path.move(to: tips[0])
            for tip in tips.dropFirst() {
                path.addQuadCurve(to: tip, control: center)
            }
        case .plus:
            path.move(to: point(0.5, 0.1))
            path.addLine(to: point(0.5, 0.9))
            path.move(to: point(0.1, 0.5))
            path.addLine(to: point(0.9, 0.5))
        case .ring:
            path.addEllipse(in: rect.insetBy(dx: rect.width * 0.12, dy: rect.height * 0.12))
        case .zigzag:
            path.addLines([point(0, 0.65), point(0.25, 0.35), point(0.5, 0.65), point(0.75, 0.35), point(1, 0.65)])
        case .dots:
            let radius = rect.width * 0.06
            for x in [0.15, 0.5, 0.85] {
                let center = point(x, 0.5)
                path.addEllipse(in: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
            }
        case .briefcase, .document, .person, .seal, .chat:
            break
        }
        return path
    }
}
