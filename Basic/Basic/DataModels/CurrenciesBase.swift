//
//  CurrenciesBase.swift
//  Basic
//
//  Created by developer on 11.12.2024.
//

import Foundation

struct CurrenciesBase: Codable {
    var baseCode: String
    var baseSign: String
    var baseIdentifier: String
    var supportedCurrencies: [String: Descriptor]
}

extension CurrenciesBase {
    struct Descriptor: Codable {
        var identifier: String
        var sign: String
    }
}
