//
//  ContentView+Preview.swift
//  Basic
//
//  Created by developer on 09.12.2024.
//

import SwiftUI
import ComposableArchitecture

#Preview {
    let store = Store(initialState: ContentReducer.State(
        fromCurrency: "980",
        fromValue: 1.0
    )) {
        ContentReducer()
    }
    ContentView(store: store)
        .padding()
        .frame(minWidth: 350.0, minHeight: 200.0)
        .onAppear {
            store.send(.initialize)
        }
}
