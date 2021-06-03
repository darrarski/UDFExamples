import ComposableArchitecture
import XCTest
@testable import CounterApp

final class CounterReducerTests: XCTestCase {
  func testCounter() {
    let store = TestStore(
      initialState: CounterState(count: 5),
      reducer: counterReducer,
      environment: ()
    )

    store.send(.increment) {
      $0.count = 6
    }

    store.send(.decrement) {
      $0.count = 5
    }

    store.send(.reset) {
      $0.count = 0
    }
  }
}
