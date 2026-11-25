//
//  AddressInfo.swift
//  HKPresentation
//
//  Created by Norman Sánchez on 25/11/26.
//

import SwiftUI
import HKDesignSystem

public struct AddressInfo: View {
    
    @Environment(\.hkTheme) private var theme
    @Binding var street: String
    @Binding var exteriorNumber: String
    @Binding var interiorNumber: String?
    
    public init(street: Binding<String> = .constant(""), exteriorNumber: Binding<String> = .constant(""), interiorNumber: Binding<String?> = .constant(nil)) {
        _street = street
        _exteriorNumber = exteriorNumber
        _interiorNumber = interiorNumber
    }
    
    public var body: some View {
        ZStack {
            content()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .hkBackground()
    }
    
    func content() -> some View {
        return VStack(alignment: .leading) {
            header()
            addressFields()
        }
        
        .frame(maxWidth: 460)
    }
    
    func header() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create your resume")
                .font(Font.title.weight(.bold))
                .foregroundColor(theme.colors.primary)
            Text("Your resume is like your profile in this app, then you need to bring us your detail information to make it complete")
            Text("Fill all required fields")
                .fontWeight(.bold)
        }
    }
    
    func addressFields() -> some View {
        VStack(alignment: .leading) {
            TextField("Street", text: $street)
            
            HStack {
                TextField("Exterior number", text: $exteriorNumber)
                TextField("Interior number (Optional)", text: interiorNumberBinding)
            }
        }
    }

    private var interiorNumberBinding: Binding<String> {
        Binding(
            get: { interiorNumber ?? "" },
            set: { interiorNumber = $0.isEmpty ? nil : $0 }
        )
    }
    
}

#if DEBUG
#Preview("Address Information") {
    NavigationStack {
        AddressInfo()
    }
}
#endif
