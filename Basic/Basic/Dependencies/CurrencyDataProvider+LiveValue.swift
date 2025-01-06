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

            let api: API
            switch base.api {
            case .nbu:
                api = NBU()
            }
            guard api.baseCurrency == base.baseCode else { throw ProviderError.invalidAPI }

            apiInstance = api
            return base
        } supportedCurrencies: {
            guard nil != apiInstance else { throw ProviderError.invalidAPI }
            guard !self.supportedCurrencies.isEmpty else { throw ProviderError.loadingFailed("supportedCurrencies") }
            return self.supportedCurrencies
        } getCurrencyDescriptor: {
            guard nil != apiInstance else { throw ProviderError.invalidAPI }
            guard let record = currenciesBase?.supportedCurrencies[$0] else { throw ProviderError.notSupported($0) }
            return CurrencyDescriptor(
                currency: $0,
                title: record.sign,
                flagSymbol: record.identifier.localizedFlag,
                description: record.identifier
            )
        } fetchCurrencyCourse: { currency in
            guard let api = apiInstance else { throw ProviderError.invalidAPI }
            guard
                supportedCurrencies.contains(currency),
                let info = await api.exchangeInfo(for: currency)
            else { throw ProviderError.notSupported(currency) }

            return info
        }
    }
}

private extension CurrencyDataProvider {
    static var apiInstance: API?

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
