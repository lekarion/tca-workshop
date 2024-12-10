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
        var selectedIndex: Int = -1
    }

    enum Action {
        enum Delegate {
            case didSelectCurrency(Currency)
            case didCancelSelection
        }
        case delegate(Delegate)
        // User actions
        case requestCancelSelection
        case requestConformSelection
        // Handle changes
        case fetchData
        case setSelectedIndex(Int)
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
            case .requestCancelSelection:
                return .send(.delegate(.didCancelSelection))
            case .requestConformSelection:
                guard 0 <= state.selectedIndex else { break }
                return .send(.delegate(.didSelectCurrency(state.currencies[state.selectedIndex].currency)))
            case let .setSelectedIndex(idx):
                state.selectedIndex = idx
            }

            return .none
        }
    }
}
