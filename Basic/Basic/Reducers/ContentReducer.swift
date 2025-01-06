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

        var isFromCurrencyPresented = false
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
        case setCurrencyRecord(Currency, CurrenciesBase.Descriptor, ExchangeRecord)
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
                var effect: Effect<Action> = .none
                if state.isFromCurrencyPresented {
                    state.fromCurrency = currency
                    effect = .run { _ in
                        try? await contentDataProvider.pushFromCurrency(currency)
                    }
                } else if state.isCurrencyAddingPresented {
                    guard state.currencyAddingIndex >= 0 else { break }
                    state.currencies.insert(currency, at: state.currencyAddingIndex)
                    effect = .run { [currencies = state.currencies.elements] _ in
                        try? await contentDataProvider.pushCurrencies(currencies)
                    }
                }
                return .concatenate( .send(.resetEditing), effect)
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
                state.isFromCurrencyPresented = true
            case let .didRequestUpdateCourse(idx):
                return .run { [currency = state.currencies[idx]] send in
                    guard
                        let base = try? await currencyDataProvider.currenciesBase(),
                        let descriptor = base.supportedCurrencies[currency]
                    else { return }
                    guard let record = try? await currencyDataProvider.fetchCurrencyCourse(currency) else { return }

                    await send(.setCurrencyRecord(currency, descriptor, record))
                }
            case .didRequestUpdateAllCourses:
                // TODO: use currency update API
                break
            case let .didRequestAddCurrency(idx):
                state.currencyAddingIndex = idx
                state.isCurrencyAddingPresented = true
            case let .didRequestRemoveCurrency(idx):
                state.currencies.remove(at: idx)
                return .run { [currencies = state.currencies.elements] _ in
                    try? await contentDataProvider.pushCurrencies(currencies)
                }
            case let .setFromCurrency(name):
                state.fromCurrency = name
            case let .setFromValue(value):
                state.fromValue = value
            case .resetEditing:
                state.isFromCurrencyPresented = false
                state.isCurrencyAddingPresented = false
                state.currencyAddingIndex = -1
            case let .setCurrencyRecord(currency, descriptor, value):
                state.currencyRecords[currency] = CurrencyRecord(
                    identifier: descriptor.identifier,
                    sign: descriptor.sign,
                    exchange: CurrencyExchange(
                        updateDate: Date.now,
                        exchange: value
                    )
                )
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
