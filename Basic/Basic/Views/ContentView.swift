//
//  ContentView.swift
//  Basic
//
//  Created by developer on 09.12.2024.
//

import SwiftUI
import Foundation
import ComposableArchitecture

struct ContentView: View {
    @Perception.Bindable var store: StoreOf<ContentReducer>

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: UIConstants.Spacing.medium) {
                    makeCurrencyRow(currency: store.state.fromCurrency) {
                        Text("1")
                    } actions: {
                        Button {
                            store.send(.didRequestUpdateFromCurrency)
                        } label: {
                            Text("Select...")
                        }
                        .disabled(true) // TODO: enable when corresponding functionality is implemented
                        .sheet(isPresented: $store.state.isFromCurrencyPresented) {
                            makeCurrencySelectionView()
                        }
                    }

                    VStack(alignment: .leading, spacing: UIConstants.Spacing.standard) {
                        Divider()

                        ScrollView {
                            VStack(alignment: .leading, spacing: UIConstants.Spacing.standard) {
                                makeContentView()
                                    .padding(UIConstants.Padding.content)
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
    func makeCurrencyRow(
        currency: Currency,
        value: () -> some View,
        actions: () -> some View
    ) -> some View {
        HStack(alignment: .firstTextBaseline) {
            if let descriptor = store.state.currencyDescriptors[currency] {
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
            value()
            Spacer(minLength: UIConstants.Spacing.standard)

            actions()
        }
    }

    func makeEditButtonsView(index: Int, showReload: Bool = true, enableMinus: Bool = true) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: UIConstants.Spacing.standard) {
            if showReload {
                Button {
                    store.send(.didRequestUpdateCourse(index))
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.headline)
                }
            }

            Button {
                store.send(.didRequestRemoveCurrency(index))
            } label: {
                Image(systemName: "minus")
                    .font(.headline)
            }
            .disabled(!enableMinus)

            Button {
                store.send(.didRequestAddCurrency(index))
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
            }
            .sheet(isPresented: $store.state.isCurrencyAddingPresented) {
                makeCurrencySelectionView()
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
                            makeEditButtonsView(index: 0, showReload: false, enableMinus: false)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: UIConstants.Spacing.standard) {
                            ForEach(Array(store.state.currencies.elements.enumerated()), id: \.self.1) { currenceInfo in
                                makeCurrencyRow(currency: currenceInfo.1) {
                                    VStack {
                                        if let value = store.state.currencyRecords[currenceInfo.1]?.exchange {
                                            HStack(spacing: UIConstants.Spacing.standard) {
                                                Text("\(value.exchange.units)")
                                                Text("\(value.exchange.amount)")
                                                Text("\(Self.updateDateFormatter.string(from: value.updateDate))")
                                            }
                                        } else {
                                            Text("-")
                                        }
                                    }
                                } actions: {
                                    makeEditButtonsView(index: currenceInfo.0)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func makeCurrencySelectionView() -> some View {
        WithPerceptionTracking {
            SelectCurrencyView(store: store.scope(state: \.selectCurrencyReducer, action: \.selectCurrencyReducer))
                .frame(
                    width: UIConstants.Geometry.selectCurrencyContentSize.width,
                    height: UIConstants.Geometry.selectCurrencyContentSize.height)
                .padding()
        }
    }
}

private extension ContentView {
    static let updateDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}
