//
//  AppReducer.swift
//  Basic
//
//  Created by developer on 26.12.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppReducer {
    @ObservableState
    struct State: Equatable {
        var isInitialized = false
        // Scopes
        var contentFeature: ContentReducer.State = .init()
    }

    enum Action {
        case initialize
        case setInitialized(Bool)
        case resetContent
        // Scopes
        case contentFeature(ContentReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .initialize:
                guard !state.isInitialized else { break }
                return .run { send in
                    await send(.contentFeature(.initialize))
                    await send(.setInitialized(true))
                }
            case let .setInitialized(value):
                state.isInitialized = value
            case .resetContent:
                return .send(.contentFeature(.reset))
            case .contentFeature:
                break
            }

            return .none
        }

        Scope(state: \.contentFeature, action: \.contentFeature) {
            ContentReducer()
        }
    }
}
