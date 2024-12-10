//
//  SelectCurrencyReducer.swift
//  Basic
//
//  Created by developer on 10.12.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SelectCurrencyReducer {
    @Dependency(CurrencyDataProvider.self) private var currencyDataProvider

    @ObservableState
    struct State: Equatable {
        var currencies: [CurrencyDescriptor] = []
        var selectedCurrency: Currency?
    }

    enum Action {
        enum Delegate {
            case didSelectCurrency(Currency)
            case didCancelSelection
        }
        case delegate(Delegate)
        // User actions
        case didRequestCancelSelection
        case didRequestConformSelection
        // Handle changes
        case fetchData
        case setSelectedCurrency(Currency?)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                break
            case .fetchData:
                guard let currencies = try? currencyDataProvider.supportedCurrencies() else { break }
                state.currencies = Set(currencies).sorted(by: <).compactMap {
                    try? currencyDataProvider.getCurrencyDescriptor($0)
                }
            case .didRequestCancelSelection:
                return .send(.delegate(.didCancelSelection))
            case .didRequestConformSelection:
                guard let currency = state.selectedCurrency else {
                    return .send(.delegate(.didCancelSelection))
                }
                return .send(.delegate(.didSelectCurrency(currency)))
            case let .setSelectedCurrency(currency):
                state.selectedCurrency = currency
            }

            return .none
        }
    }
}
