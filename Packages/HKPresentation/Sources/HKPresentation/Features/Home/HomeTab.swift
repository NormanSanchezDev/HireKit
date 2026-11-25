/// The tabs of the home shell. Each tab keeps its own navigation stack.
public enum HomeTab: Hashable, Sendable, CaseIterable {
    /// The summary of the user's hiring processes.
    case dashboard

    /// The app settings.
    case settings
}
