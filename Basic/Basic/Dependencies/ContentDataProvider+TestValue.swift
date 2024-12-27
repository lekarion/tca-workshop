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
        .liveValue
    }
}
