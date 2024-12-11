//
//  ContentReducer.swift
//  Basic
//
//  Created by develop on 10.12.2024.
//

import Foundation
import OrderedCollections
import ComposableArchitecture

@Reducer
struct ContentReducer {
    @Dependency(CurrencyDataProvider.self) private var currencyDataProvider

    @ObservableState
    struct State: Equatable {
        var fromCurrency: Currency = ""
        var currencyRecords: [CurrencyRecord] = []

        var fromValue: Double = 0.0
        var currencies: OrderedSet<String> = []
        var courses: [String: CourseInfo] = [:]
        var isCurrencySelectionPresented = false

        var selectCurrencyReducer: SelectCurrencyReducer.State = .init()
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case initialFetchData(Currency?, [CurrencyRecord]?)
        // User actions
        case didRequestUpdateFromCurrency
        case didRequestUpdateCourse(Int)
        case didRequestUpdateAllCourses
        case didRequestAddCurrency(Int)
        case didRequestRemoveCurrency(Int)
        // Handle changes
        case setFromCurrency(String)
        case setFromValue(Double)
        case insertCurrency(String, Int)
        case removeCurrency(String)
        // Scopes
        case selectCurrencyReducer(SelectCurrencyReducer.Action)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .selectCurrencyReducer(.delegate(.didCancelSelection)):
                state.isCurrencySelectionPresented = false
            case let .selectCurrencyReducer(.delegate(.didSelectCurrency(currency))):
                state.fromCurrency = currency
                state.isCurrencySelectionPresented = false
            case let .initialFetchData(curency, records):
                guard let currenciesBase = try? currencyDataProvider.currenciesBase() else { break }
                state.fromCurrency = curency ?? currenciesBase.baseCode
                state.currencyRecords = records ?? []
            case .didRequestUpdateFromCurrency:
                state.isCurrencySelectionPresented = true
            case let .didRequestUpdateCourse(idx):
                // TODO: use currency update API
                break
            case .didRequestUpdateAllCourses:
                // TODO: use currency update API
                break
            case let .didRequestAddCurrency(idx):
                // TODO: implement if need
                break
            case let .didRequestRemoveCurrency(idx):
                // TODO: implement if need
                break
            case let .setFromCurrency(name):
                state.fromCurrency = name
            case let .setFromValue(value):
                state.fromValue = value
            case let .insertCurrency(name, idx):
                state.currencies.insert(name, at: idx)
            case let .removeCurrency(name):
                state.currencies.remove(name)
            case .binding, .selectCurrencyReducer:
                break
            }

            return .none
        }

        Scope(state: \.selectCurrencyReducer, action: \.selectCurrencyReducer) {
            SelectCurrencyReducer()
        }

    }
}

extension ContentReducer {
    struct CourseInfo: Equatable, Codable {
        var value: Double
        var updateDate: Date
    }
}
