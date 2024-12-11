//
//  BasicApp.swift
//  Basic
//
//  Created by developer on 09.12.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct BasicApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: ContentReducer.State()) {
                ContentReducer()
            })
        }
        .windowResizability(.contentSize)
    }
}
