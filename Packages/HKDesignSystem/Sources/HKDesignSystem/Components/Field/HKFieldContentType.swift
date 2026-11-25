import SwiftUI

#if os(macOS)
/// The semantic meaning of a field's text, used for AutoFill and keyboards.
///
/// On macOS it is `NSTextContentType`, on iOS `UITextContentType`, so callers
/// write `.emailAddress` or `.password` on both platforms.
public typealias HKFieldContentType = NSTextContentType
#else
/// The semantic meaning of a field's text, used for AutoFill and keyboards.
///
/// On macOS it is `NSTextContentType`, on iOS `UITextContentType`, so callers
/// write `.emailAddress` or `.password` on both platforms.
public typealias HKFieldContentType = UITextContentType
#endif
