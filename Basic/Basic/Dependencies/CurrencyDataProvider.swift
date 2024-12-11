//
//  CurrencyDataProvider.swift
//  Basic
//
//  Created by developer on 10.12.2024.
//

import Foundation
import DependenciesMacros

typealias Currency = String

struct CurrencyDescriptor: Equatable {
    var currency: Currency
    var title: String
    var flagSymbol: String
    var description: String
}

@DependencyClient
struct CurrencyDataProvider {
    var currenciesBase: () throws -> CurrenciesBase
    var supportedCurrencies: () throws -> Set<Currency>
    var getCurrencyDescriptor: (Currency) throws -> CurrencyDescriptor
    var fetchCurrencyCourse: (Currency, Currency) async throws -> Double
}

extension CurrencyDataProvider {
    enum ProviderError: LocalizedError, Codable {
        case loadingFailed(String)
        case notSupported(Currency)
    }
}
