//
//  ContentDataProvider+LiveValue.swift
//  Basic
//
//  Created by developer on 26.12.2024.
//

import SwiftUI
import Foundation
import Dependencies

extension ContentDataProvider: DependencyKey {
    static var liveValue: ContentDataProvider {
        .init {
            @AppStorage(AppSettings.Key.fromCurrencyKey) var fromCurrency: String?
            guard let result = fromCurrency else { throw ProviderError.loadingFailed(AppSettings.Key.fromCurrencyKey) }
            return result
        } pushFromCurrency: {
            @AppStorage(AppSettings.Key.fromCurrencyKey) var fromCurrency: String?
            fromCurrency = $0
        } fetchCurrencies: {
            @AppStorage(AppSettings.Key.selectedCurrenciesKey) var selectedCurrencies: Data?
            guard let data = selectedCurrencies else { throw ProviderError.loadingFailed(AppSettings.Key.selectedCurrenciesKey) }

            let decoder = JSONDecoder()
            do {
                return try decoder.decode([String].self, from: data)
            } catch {
                throw ProviderError.invalidFormat(AppSettings.Key.selectedCurrenciesKey)
            }
        } pushCurrencies: { currencies in
            @AppStorage(AppSettings.Key.selectedCurrenciesKey) var selectedCurrencies: Data?

            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(currencies)
                selectedCurrencies = data
            } catch {
                throw ProviderError.storingFailed(AppSettings.Key.selectedCurrenciesKey)
            }
        } fetchCurrencyRecords: {
            @AppStorage(AppSettings.Key.currencyRecordsKey) var currencyRecords: Data?
            guard let data = currencyRecords else { throw ProviderError.loadingFailed(AppSettings.Key.currencyRecordsKey) }

            let decoder = JSONDecoder()
            do {
                return try decoder.decode([Currency: CurrencyRecord].self, from: data)
            } catch {
                throw ProviderError.invalidFormat(AppSettings.Key.currencyRecordsKey)
            }
        } pushCurrencyRecords: { records in
            @AppStorage(AppSettings.Key.currencyRecordsKey) var currencyRecords: Data?

            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(records)
                currencyRecords = data
            } catch {
                throw ProviderError.storingFailed(AppSettings.Key.currencyRecordsKey)
            }
        }
    }
}
