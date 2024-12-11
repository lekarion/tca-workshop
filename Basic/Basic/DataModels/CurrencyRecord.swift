//
//  CurrencyRecord.swift
//  Basic
//
//  Created by developer on 11.12.2024.
//

import Foundation

struct CurrencyRecord: Codable, Equatable {
    var identifier: String
    var sign: String
    var exchange: CurrencyExchange?
}

struct CurrencyExchange: Codable, Equatable {
    var baseSign: String
    var updateDate: Date
    var units: Int
    var amount: Double
}
