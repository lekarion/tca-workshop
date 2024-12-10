//
//  ContentView.swift
//  Basic
//
//  Created by developer on 09.12.2024.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.medium) {
                makeCurrencyRow(title: "USA", flag: "🇺🇸", value: "1") {
                    Button {
                        // TODO: implement
                    } label: {
                        Text("Select...")
                    }
                }

                Divider()

                Form {
                    Section {
                        ForEach(0 ..< 5, id: \.self) {
                            makeCurrencyRow(title: "USA", flag: "🇺🇸", value: "\($0 * 20)") {
                                HStack(alignment: .firstTextBaseline, spacing: UIConstants.Spacing.standard) {
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
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
        .frame(
            minWidth: UIConstants.Geometry.minContentSize.width,
            minHeight: UIConstants.Geometry.minContentSize.height
        )
    }
}

private extension ContentView {
    func makeCurrencyRow(title: String, flag: String, value: String, actions: () -> some View) -> some View {
        HStack(alignment: .firstTextBaseline) {
            HStack(alignment: .firstTextBaseline, spacing: UIConstants.Spacing.standard) {
                Text("🇺🇸")
                Text("USA")
            }
            .font(.headline)

            Spacer(minLength: UIConstants.Spacing.standard)
            Text("\(value)")
            Spacer(minLength: UIConstants.Spacing.standard)

            actions()
        }
    }
}
