//
//  SelectCurrencyView+Preview.swift
//  Basic
//
//  Created by developer on 11.12.2024.
//

import SwiftUI
import ComposableArchitecture

#Preview {
    SelectCurrencyView(store: Store(initialState: SelectCurrencyReducer.State()) {
        SelectCurrencyReducer()
    })
    .frame(minWidth: 350.0, minHeight: 200.0)
    .padding()
}
