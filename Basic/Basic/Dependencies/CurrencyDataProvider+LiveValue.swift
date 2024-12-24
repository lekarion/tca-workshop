//
//  CurrencyDataProvider+LiveValue.swift
//  Basic
//
//  Created by developer on 10.12.2024.
//

import Foundation
import Dependencies

extension CurrencyDataProvider: DependencyKey {
    static var liveValue: CurrencyDataProvider {
        .init {
            guard let base = currenciesBase else { throw ProviderError.loadingFailed("currenciesBase") }
            return base
        } supportedCurrencies: {
            self.supportedCurrencies
        } getCurrencyDescriptor: {
            guard let base = currenciesBase else { throw ProviderError.loadingFailed("currenciesBase") }
            guard let record = base.supportedCurrencies[$0] else { throw ProviderError.notSupported($0) }
            return CurrencyDescriptor(
                currency: $0,
                title: record.sign,
                flagSymbol: record.identifier.localizedFlag,
                description: record.identifier
            )
        } fetchCurrencyCourse: { _, _ in
            1.0
        }
    }
}

private extension CurrencyDataProvider {
    static let currenciesBase: CurrenciesBase? = {
        guard let url = Bundle.main.url(forResource: "currenciesBase", withExtension: "json") else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }

        let decoder = JSONDecoder()
        return try? decoder.decode(CurrenciesBase.self, from: data)
    }()

    static let supportedCurrencies: Set<Currency> = {
        guard let base = currenciesBase else { return [] }

        var result = Set(Array(base.supportedCurrencies.keys))
        result.remove(base.baseCode)

        return result
    }()
}
