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
        case setCurrencies([CurrencyDescriptor])
        case setSelectedCurrency(Currency?)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                break
            case .fetchData:
                return .run { send in
                    let supported = try await currencyDataProvider.supportedCurrencies()

                    var result = [CurrencyDescriptor]()
                    result.reserveCapacity(supported.count)

                    let currencies = Set(supported).sorted(by: <)
                    for currency in currencies {
                        guard let info = try? await currencyDataProvider.getCurrencyDescriptor(currency) else { continue }
                        result.append(info)
                    }

                    await send(.setCurrencies(result))
                }
            case .didRequestCancelSelection:
                return .send(.delegate(.didCancelSelection))
            case .didRequestConformSelection:
                guard let currency = state.selectedCurrency else {
                    return .send(.delegate(.didCancelSelection))
                }
                return .send(.delegate(.didSelectCurrency(currency)))
            case let .setCurrencies(descriptors):
                state.currencies = descriptors
            case let .setSelectedCurrency(currency):
                state.selectedCurrency = currency
            }

            return .none
        }
    }
}
