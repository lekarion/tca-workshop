//
//  CurrenciesBase.swift
//  Basic
//
//  Created by developer on 11.12.2024.
//

import Foundation

/// The internal data base date format
struct CurrenciesBase: Codable {
    /// Data provider API type
    var api: API
    /// Base currency unique code
    var baseCode: Currency
    /// Base currency unique sign (literal identifier)
    var baseSign: String
    /// Base currency unique identifier to get access to localized resources
    var baseIdentifier: String
    /// The list of supported currencies
    var supportedCurrencies: [Currency: Descriptor]
}

/// Single currency record
extension CurrenciesBase {
    /// The exchange courses getting API type
    enum API: String, Codable {
        /// NBU API
        case nbu
    }

    /// Single currency descriptor
    struct Descriptor: Codable {
        /// The unique identifier to get access to localized resources
        var identifier: String
        /// The unique currency sign
        var sign: String
    }
}
