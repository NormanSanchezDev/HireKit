//
//  AddressInfo.swift
//  HKPresentation
//
//  Created by Norman Sánchez on 25/11/26.
//

import SwiftUI


public struct AddressInfo: View {
    
    @State private var viewModel: AddressInfoViewModel
    
    public init(viewModel: AddressInfoViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            if let state = viewModel.uiState {
                content(state)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
    
    @ViewBuilder
    func content(_ state: AddressInfoUIState) -> some View {
        
    }
    
}

#Preview {
    AddressInfo(viewModel: AddressInfoViewModel())
}
