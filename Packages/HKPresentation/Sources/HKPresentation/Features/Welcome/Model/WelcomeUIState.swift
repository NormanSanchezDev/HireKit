//
//  WelcomeState.swift
//  HKPresentation
//
//  Created by Norman Sánchez on 25/11/26.
//

import SwiftUI
import HKDesignSystem

public struct WelcomeUIState {
    public let imageSize: CGFloat = 300
    public let imageResourceName: String = "hk_programming_memoji"
    public let title: LocalizedStringKey = LocalizedStringKey("welcome_title_txt")
    public let description: LocalizedStringKey = LocalizedStringKey("welcome_description_txt")
    public let startButton: HKButtonModel
}
