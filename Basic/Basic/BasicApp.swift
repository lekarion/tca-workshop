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
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(store: appDelegate.store)
                .frame(
                    minWidth: UIConstants.Geometry.minContentSize.width,
                    minHeight: UIConstants.Geometry.minContentSize.height
                )
                .padding()
        }
        .windowResizability(.contentSize)
    }
}
