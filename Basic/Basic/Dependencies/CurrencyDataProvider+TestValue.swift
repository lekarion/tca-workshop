//
//  CurrencyDataProvider+TestValue.swift
//  Basic
//
//  Created by developer on 10.12.2024.
//

import Dependencies

extension CurrencyDataProvider: TestDependencyKey {
    static var testValue: CurrencyDataProvider {
        .liveValue
    }
}
