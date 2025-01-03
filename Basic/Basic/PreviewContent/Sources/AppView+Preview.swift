//
//  AppView+Preview.swift
//  Basic
//
//  Created by developer on 03.01.2025.
//

import SwiftUI
import ComposableArchitecture

#Preview("Placeholder") {
    AppView(store: Store(initialState: AppReducer.State()) {
        AppReducer()
    }).frame(minWidth: 350.0, minHeight: 200.0)
}

#Preview("Normal") {
    let store = Store(initialState: AppReducer.State()) {
        AppReducer()
    }
    AppView(store: store)
        .padding()
        .frame(minWidth: 350.0, minHeight: 200.0)
        .onAppear {
            store.send(.initialize)
        }
}
