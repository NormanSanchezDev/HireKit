//
//  WelcomeScreen.swift
//  HireKit
//
//  Created by Norman Sánchez on 24/11/26.
//

import SwiftUI

public struct WelcomeScreen: View {
    public var body: some View {
        VStack {
            Spacer()
            Text("Bienvenido a HireKit")
                .font(Font.largeTitle.weight(.bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            Text("La aplicación que te ayudará en tu proceso de contratación")
            
            Text("Are you ready?")
            Spacer()
            Button(action: {
            }, label: {
                Text("Let's go")
            })
        }
    }
}

#Preview {
    WelcomeScreen()
}
