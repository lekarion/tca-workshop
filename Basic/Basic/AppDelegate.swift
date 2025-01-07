//
//  AppDelegate.swift
//  Basic
//
//  Created by developer on 12.12.2024.
//

import AppKit
import SwiftUI
import ComposableArchitecture

final class AppDelegate: NSObject, NSApplicationDelegate {
    private(set) lazy var store = Store(initialState: .init()) {
        AppReducer()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        store.send(.initialize)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
