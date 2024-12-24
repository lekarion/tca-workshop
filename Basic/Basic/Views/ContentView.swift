//
//  ContentView.swift
//  Basic
//
//  Created by developer on 09.12.2024.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @Perception.Bindable var store: StoreOf<ContentReducer>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: UIConstants.Spacing.medium) {
                    makeCurrencyRow(currency: store.state.fromCurrency, value: "1") {
                        Button {
                            store.send(.didRequestUpdateFromCurrency)
                        } label: {
                            Text("Select...")
                        }
                        .disabled(true) // TODO: enable when corresponding functionality is implemented
                    }
                    .sheet(isPresented: $store.state.isCurrencySelectionPresented) {
                        WithPerceptionTracking {
                            SelectCurrencyView(store: store.scope(state: \.selectCurrencyReducer, action: \.selectCurrencyReducer))
                                .frame(
                                    width: UIConstants.Geometry.selectCurrencyContentSize.width,
                                    height: UIConstants.Geometry.selectCurrencyContentSize.height)
                                .padding()
                        }
                    }

                    VStack(alignment: .leading, spacing: UIConstants.Spacing.standard) {
                        Divider()

                        ScrollView {
                            VStack(alignment: .leading, spacing: UIConstants.Spacing.standard) {
                                makeContentView()
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

private extension ContentView {
    func makeCurrencyRow(currency: Currency, value: String, actions: () -> some View) -> some View {
        @Dependency(CurrencyDataProvider.self) var currencyDataProvider

        let descriptor = try? currencyDataProvider.getCurrencyDescriptor(currency)

        return HStack(alignment: .firstTextBaseline) {
            if let descriptor {
                HStack(alignment: .firstTextBaseline, spacing: UIConstants.Spacing.standard) {
                    Text(descriptor.flagSymbol)
                    Text("\(descriptor.title) (\(descriptor.currency))")
                }
                .font(.headline)
            } else {
                Text("Unknown")
                    .foregroundStyle(.red)
                    .font(.headline)
            }

            Spacer(minLength: UIConstants.Spacing.standard)
            Text("\(value)")
            Spacer(minLength: UIConstants.Spacing.standard)

            actions()
        }
    }

    func makeEditButtonsView(index: Int, showReload: Bool = true) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: UIConstants.Spacing.standard) {
            if showReload {
                Button {
                    // TODO: implement
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.headline)
                }
            }

            Button {
                // TODO: implement
            } label: {
                Image(systemName: "minus")
                    .font(.headline)
            }

            Button {
                // TODO: implement
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
            }
        }
    }

    func makeContentView() -> some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    if store.state.currencies.isEmpty {
                        HStack {
                            Spacer()
                            makeEditButtonsView(index: 0, showReload: false)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: UIConstants.Spacing.standard) {
                            ForEach(Array(store.state.currencies.enumerated()), id: \.self.1) {
                                makeCurrencyRow(currency: $0.1, value: "\($0.0 * 20)") {
                                    makeEditButtonsView(index: 0)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
