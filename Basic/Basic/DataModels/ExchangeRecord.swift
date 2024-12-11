//
//  ExchangeRecord.swift
//  Basic
//
//  Created by developer on 11.12.2024.
//

import Foundation

struct ExchangeRecord: Codable {
    var currencyCode: String
    var currencySign: String
    var units: Int
    var amount: Double
}

extension ExchangeRecord {
    enum CodingKeys: String, CodingKey {
        case currencyCode = "CurrencyCode"
        case currencySign = "CurrencyCodeL"
        case units = "Units"
        case amount = "Amount"
    }
}
