//
//  BasicTests.swift
//  BasicTests
//
//  Created by developer on 09.12.2024.
//

import Testing
import ComposableArchitecture
@testable import Basic

struct BasicTests {
    @Test func testAppInitReset() async throws {
        let store = await TestStore(initialState: AppReducer.State()) {
            AppReducer()
        }

        await store.send(.initialize)
        await store.receive(\.contentFeature)
        await store.receive(\.setInitialized) {
            $0.isInitialized = true
        }
        await store.skipReceivedActions()

        await store.send(.resetContent)
        await store.receive(\.contentFeature)
        await store.skipReceivedActions()
    }

    @Test func testContentInit() async throws {
        let store = await TestStore(initialState: ContentReducer.State()) {
            ContentReducer()
        }

        await store.send(.initialize)
        await store.skipReceivedActions()
    }
}
