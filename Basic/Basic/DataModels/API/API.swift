//
//  API.swift
//  Basic
//
//  Created by developer on 27.12.2024.
//

import Foundation

typealias Currency = String

protocol API {
    var baseCurrency: Currency { get }
    var exchangeInfo: [ExchangeRecord] { get async }

    func updateExchangeInfo(for currency: Currency?) async
}

struct ExchangeRecord: Codable, Equatable {
    var currencyCode: String
    var currencySign: String
    var units: Int
    var amount: Double
}
