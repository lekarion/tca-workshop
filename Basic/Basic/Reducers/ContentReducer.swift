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
    @Dependency(ContentDataProvider.self) private var contentDataProvider

    @ObservableState
    struct State: Equatable {
        var fromCurrency: Currency = ""
        var fromValue: Double = 0.0
        var currencies: OrderedSet<Currency> = []
        var currencyRecords: [Currency: CurrencyRecord] = [:]
        var currencyDescriptors: [Currency: CurrencyDescriptor] = [:]

        var isCurrencySelectionPresented = false
        var isCurrencyAddingPresented = false
        var currencyAddingIndex: Int = -1

        var selectCurrencyReducer: SelectCurrencyReducer.State = .init()
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case initialize
        // User actions
        case didRequestUpdateFromCurrency
        case didRequestUpdateCourse(Int)
        case didRequestUpdateAllCourses
        case didRequestAddCurrency(Int)
        case didRequestRemoveCurrency(Int)
        // Handle changes
        case setCurrencyDescriptors([Currency: CurrencyDescriptor])
        case setInitialData(Currency, [Currency], [Currency: CurrencyRecord])
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
            case .initialize:
                return .run { send in
                    let currenciesBase = try await currencyDataProvider.currenciesBase()
                    var supportedCurrencies = try await currencyDataProvider.supportedCurrencies()

                    let fromCurrency = (try? await contentDataProvider.fetchFromCurrency()) ?? currenciesBase.baseCode
                    let currencies = ((try? await contentDataProvider.fetchCurrencies()) ?? []).compactMap {
                        supportedCurrencies.contains($0) ? $0 : nil
                    }
                    let records = (try? await contentDataProvider.fetchCurrencyRecords()) ?? [:]

                    var descriptors = [Currency: CurrencyDescriptor]()
                    supportedCurrencies.insert(fromCurrency)
                    for currency in supportedCurrencies {
                        guard let info = try? await currencyDataProvider.getCurrencyDescriptor(currency) else { continue }
                        descriptors[currency] = info
                    }

                    await send(.setCurrencyDescriptors(descriptors))
                    await send(.setInitialData(fromCurrency, currencies, records))
                }
            case let .setInitialData(fromCurrency, currencies, currencyRecords):
                state.fromCurrency = fromCurrency
                state.currencies = OrderedSet(currencies)
                state.currencyRecords = currencyRecords
            case let .setCurrencyDescriptors(value):
                state.currencyDescriptors = value
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
