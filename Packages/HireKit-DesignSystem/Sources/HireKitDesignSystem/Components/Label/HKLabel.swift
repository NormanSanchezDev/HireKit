//
//  HKLabel.swift
//  HireKit-DesignSystem
//
//  Created by Norman Sánchez on 24/11/26.
//

import SwiftUI

public struct HKLabel: View {
    @Environment(HKThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    private let model: HKLabelModel

    public init(model: HKLabelModel) {
        self.model = model
    }

    public var body: some View {
        let theme = themeManager.current(for: colorScheme)
        Text(model.text)
            .font(model.type.font(in: theme.typography))
            .foregroundStyle(theme.colors.textPrimary)
    }
}

#Preview("Label styles") {
    VStack(alignment: .leading) {
        HKLabel(model: .init(text: "Interviews", type: .title))
        HKLabel(model: .init(text: "Next interview", type: .headline))
        HKLabel(model: .init(text: "Interview details", type: .subheadline))
        HKLabel(model: .init(text: "Meet the hiring team"))
        HKLabel(model: .init(text: "Updated today", type: .caption))
        HKLabel(model: .init(text: "All times are local", type: .footnote))
    }
    .padding()
    .environment(HKThemeManager(defaults: nil))
}
