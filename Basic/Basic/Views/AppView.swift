//
//  AppView.swift
//  Basic
//
//  Created by developer on 27.12.2024.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    @Perception.Bindable var store: StoreOf<AppReducer>

    var body: some View {
        WithPerceptionTracking {
            if store.state.isInitialized {
                VStack {
                    ContentView(store: store.scope(state: \.contentFeature, action: \.contentFeature))
                    Spacer()
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}
