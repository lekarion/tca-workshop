//
//  ContentDataProvider.swift
//  Basic
//
//  Created by developer on 26.12.2024.
//

import Foundation
import DependenciesMacros

@DependencyClient
struct ContentDataProvider {
    /// Get the latest "From" currency
    var fetchFromCurrency: () async throws -> Currency
    /// Store new "From" currency
    var pushFromCurrency: (Currency) async throws -> Void
    /// Get list of the latest used currencies
    var fetchCurrencies: () async throws -> [Currency]
    /// Store list of the latest used currencies
    var pushCurrencies: ([Currency]) async throws -> Void
    /// Get the latest exchange records
    var fetchCurrencyRecords: () async throws -> [Currency: CurrencyRecord]
    /// Store exchange records
    var pushCurrencyRecords: ([Currency: CurrencyRecord]) async throws -> Void
}

extension ContentDataProvider {
    enum ProviderError: LocalizedError, Codable {
        case loadingFailed(String)
        case invalidFormat(String)
        case storingFailed(String)
    }
}
