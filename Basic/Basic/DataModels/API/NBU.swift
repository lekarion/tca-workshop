//
//  NBU.swift
//  Basic
//
//  Created by developer on 27.12.2024.
//

import Foundation

actor NBU: API {
    let baseCurrency: Currency = "980"

    func exchangeInfo(for currency: Currency) async -> ExchangeRecord? {
        records[currency]
    }

    func updateExchangeInfo(for currency: Currency? = nil) async {
        records = [:]
    }

    private var records: [Currency: ExchangeRecord] = [:]
}

extension NBU {
    struct CurrencyExchange: Codable {
        var currencyCode: String
        var currencySign: String
        var units: Int
        var amount: Double
    }
}

extension NBU.CurrencyExchange {
    enum CodingKeys: String, CodingKey {
        case currencyCode = "CurrencyCode"
        case currencySign = "CurrencyCodeL"
        case units = "Units"
        case amount = "Amount"
    }
}
