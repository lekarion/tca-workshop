//
//  ContentDataProvider+TestValue.swift
//  Basic
//
//  Created by developer on 26.12.2024.
//

import Foundation
import Dependencies

extension ContentDataProvider: TestDependencyKey {
    static var testValue: ContentDataProvider {
        .init {
            "980"
        } pushFromCurrency: { _ in
        } fetchCurrencies: {
            Self.mockedData.currencies
        } pushCurrencies: { _ in
        } fetchCurrencyRecords: {
            Self.mockedData.records
        } pushCurrencyRecords: { _ in
        }
    }

    static var previewValue: ContentDataProvider {
        .testValue
    }
}

private extension ContentDataProvider {
    struct TestDataStruct {
        var currencies: [Currency]
        var records: [Currency: CurrencyRecord]
    }
    static let mockedData = {
        let decoder = JSONDecoder()

        var currencies: [Currency]?
        let currenciesURL = Bundle.main.url(forResource: "testCurrencies", withExtension: "json")
        if
            let currenciesURL,
            let data = try? Data(contentsOf: currenciesURL) {
            currencies = try? decoder.decode([Currency].self, from: data)
        }

        var records: [Currency: CurrencyRecord]?
        let recordsURL = Bundle.main.url(forResource: "testCurrencyRecords", withExtension: "json")
        if
            let recordsURL,
            let data = try? Data(contentsOf: recordsURL) {
            records = try? decoder.decode([Currency: CurrencyRecord].self, from: data)
        }

        return TestDataStruct(
            currencies: currencies ?? [],
            records: records ?? [:]
        )
    }()
}
