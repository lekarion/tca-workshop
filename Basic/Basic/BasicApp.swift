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
        Window("Basic", id: Constants.windowIdentifier) {
            AppView(store: appDelegate.store)
                .frame(
                    minWidth: UIConstants.Geometry.minContentSize.width,
                    minHeight: UIConstants.Geometry.minContentSize.height
                )
                .padding()
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(after: CommandGroupPlacement.newItem) {
                Button {
                    appDelegate.store.send(.resetContent)
                } label: {
                    Text("Reset...")
                }
            }
        }
    }
}

private extension BasicApp {
    enum Constants {
        static let windowIdentifier = "com.basic.mainWindow"
    }
}
