//
//  CurrencyDescriptor.swift
//  Basic
//
//  Created by developer on 26.12.2024.
//

import Foundation

/// Detailed info about the currency (for runtime)
struct CurrencyDescriptor: Equatable {
    /// The currency id
    var currency: Currency
    /// The human readable currency name
    var title: String
    /// The currency country flag symbol
    var flagSymbol: String
    /// The currency resources description (identifier)
    var description: String
}
