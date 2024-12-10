//
//  CurrencyDataProvider+LiveValue.swift
//  Basic
//
//  Created by developer on 10.12.2024.
//

import Dependencies

extension CurrencyDataProvider: DependencyKey {
    static public var liveValue: CurrencyDataProvider {
        .init {
            self.supportedCurrencies
        } getCurrencyDescriptor: {
            CurrencyDescriptor(currency: $0, title: $0, flagSymbol: "🇺🇸", description: "US Dollar")
        } fetchCurrencyCourse: { _, _ in
            1.0
        }
    }
}

private extension CurrencyDataProvider {
    static let supportedCurrencies: [Currency] = {
        ["us", "ua", "eu"]
    }()
}
