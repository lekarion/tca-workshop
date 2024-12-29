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
        ContentReducer()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        store.send(.initialize)
    }
}
