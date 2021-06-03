import Combine
import ComposableArchitecture
import XCTest
@testable import FactsApp

final class FactsReducerTests: XCTestCase {
  func testFetchingFact() {
    let factsSubject = PassthroughSubject<String, Error>()
    let mainScheduler = DispatchQueue.test

    let store = TestStore(
      initialState: FactsState(),
      reducer: factsReducer,
      environment: FactsEnvironment(
        fetchRandomFact: { factsSubject.eraseToAnyPublisher() },
        mainScheduler: mainScheduler.eraseToAnyScheduler()
      )
    )

    store.send(.fetchFact) {
      $0.isFetchingFact = true
    }

    let testFact = "Test fact"
    factsSubject.send(testFact)
    factsSubject.send(completion: .finished)
    mainScheduler.advance()

    store.receive(.didFetchFact(testFact)) {
      $0.isFetchingFact = false
      $0.fact = testFact
    }
  }

  func testFetchingFactFailure() {
    let factsSubject = PassthroughSubject<String, Error>()
    let mainScheduler = DispatchQueue.test

    let store = TestStore(
      initialState: FactsState(),
      reducer: factsReducer,
      environment: FactsEnvironment(
        fetchRandomFact: { factsSubject.eraseToAnyPublisher() },
        mainScheduler: mainScheduler.eraseToAnyScheduler()
      )
    )

    store.send(.fetchFact) {
      $0.isFetchingFact = true
    }

    factsSubject.send(completion: .failure(NSError(domain: "test", code: 0, userInfo: nil)))
    mainScheduler.advance()

    store.receive(.didFailFetchingFact) {
      $0.isFetchingFact = false
      $0.fetchDidFail = true
    }
  }
}
