//
//  SelectCurrencyView.swift
//  Basic
//
//  Created by developer on 11.12.2024.
//

import SwiftUI
import Dependencies
import ComposableArchitecture

struct SelectCurrencyView: View {
    @Perception.Bindable var store: StoreOf<SelectCurrencyReducer>
    @Dependency(CurrencyDataProvider.self) private var currencyDataProvider

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.medium) {
                makeCurrenciesContentView()
                    .onAppear {
                        store.send(.fetchData)
                    }
                Divider()
                HStack {
                    Spacer()
                    HStack(alignment: .firstTextBaseline, spacing: UIConstants.Spacing.standard) {
                        Button {
                            store.send(.didRequestCancelSelection)
                        } label: {
                            Text("Cancel")
                        }

                        Button {
                            store.send(.didRequestConformSelection)
                        } label: {
                            Text("Select")
                        }
                        .disabled(nil == store.state.selectedCurrency)
                    }
                }
            }
        }
    }
}

private extension SelectCurrencyView {
    func makeCurrenciesContentView() -> some View {
        List(
            selection: .init(
                get: { store.state.selectedCurrency },
                set: { store.send(.setSelectedCurrency($0)) }
            )
        ) {
            ForEach(store.currencies, id: \.currency) { descriptor in
                HStack {
                    HStack(alignment: .firstTextBaseline, spacing: UIConstants.Spacing.standard) {
                        Text(descriptor.flagSymbol)
                            .font(.headline)
                        Text(descriptor.title)
                            .font(.headline)
                        Text(descriptor.description)
                            .font(.footnote)
                    }
                    Spacer()
                }
            }
        }
    }
}
