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
    @AppStorage(AppSettings.Key.fromCurrencyKey) private var fromCurrency: String?
    @AppStorage(AppSettings.Key.currencyRecordsKey) private var currencyRecords: Data?

    private(set) lazy var store = Store(initialState: .init()) {
        ContentReducer()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        var records: [CurrencyRecord]?
        if let encodedData = currencyRecords {
            let decoder = JSONDecoder()
            records = try? decoder.decode([CurrencyRecord].self, from: encodedData)
        }

        store.send(.initialFetchData(fromCurrency, records))
    }
}

extension AppDelegate {
    enum Stage {
        case didFinishLaunching
    }
}
