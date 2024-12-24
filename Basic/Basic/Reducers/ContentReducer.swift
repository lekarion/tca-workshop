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
        var currencies: OrderedSet<Currency> = []
        var courses: [String: CourseInfo] = [:]

        var isCurrencySelectionPresented = false
        var isCurrencyAddingPresented = false
        var currencyAddingIndex: Int = -1

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
        case resetEditing
        // Scopes
        case selectCurrencyReducer(SelectCurrencyReducer.Action)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .selectCurrencyReducer(.delegate(.didCancelSelection)):
                return .send(.resetEditing)
            case let .selectCurrencyReducer(.delegate(.didSelectCurrency(currency))):
                if state.isCurrencySelectionPresented {
                    state.fromCurrency = currency
                } else if
                    state.isCurrencyAddingPresented,
                    state.currencyAddingIndex >= 0 {
                    state.currencies.insert(currency, at: state.currencyAddingIndex)
                }
                return .send(.resetEditing)
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
                state.currencyAddingIndex = idx
                state.isCurrencyAddingPresented = true
            case let .didRequestRemoveCurrency(idx):
                state.currencies.remove(at: idx)
            case let .setFromCurrency(name):
                state.fromCurrency = name
            case let .setFromValue(value):
                state.fromValue = value
            case .resetEditing:
                state.isCurrencySelectionPresented = false
                state.isCurrencyAddingPresented = false
                state.currencyAddingIndex = -1
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
