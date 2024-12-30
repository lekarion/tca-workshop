//
//  CurrencyDataProvider.swift
//  Basic
//
//  Created by developer on 10.12.2024.
//

import Foundation
import DependenciesMacros

@DependencyClient
struct CurrencyDataProvider {
    /// Get basic app currencies data base
    var currenciesBase: () async throws -> CurrenciesBase
    /// Get set of supported currencies
    var supportedCurrencies: () async throws -> Set<Currency>
    /// Get currency detailed description
    var getCurrencyDescriptor: (Currency) async throws -> CurrencyDescriptor
    /// Fetch current exchange course for a specified currency 
    var fetchCurrencyCourse: (Currency) async throws -> Double
}

extension CurrencyDataProvider {
    enum ProviderError: LocalizedError, Codable {
        case loadingFailed(String)
        case invalidAPI
        case notSupported(Currency)
    }
}
