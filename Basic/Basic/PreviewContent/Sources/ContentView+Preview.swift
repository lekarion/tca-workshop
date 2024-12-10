//
//  ContentView+Preview.swift
//  Basic
//
//  Created by developer on 09.12.2024.
//

import SwiftUI
import ComposableArchitecture

#Preview {
    ContentView(store: Store(initialState: ContentReducer.State()) {
        ContentReducer()
    }).frame(minWidth: 350.0, minHeight: 200.0)
}
