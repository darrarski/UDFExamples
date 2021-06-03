import Combine
import ComposableArchitecture
import SwiftUI

struct FactsState: Equatable {
  var fact: String?
  var isFetchingFact: Bool = false
  var fetchDidFail: Bool = false
}

enum FactsAction: Equatable {
  case fetchFact
  case didFetchFact(String)
  case didFailFetchingFact
}

struct FactsEnvironment {
  var fetchRandomFact: () -> AnyPublisher<String, Error>
  var mainScheduler: AnySchedulerOf<DispatchQueue>
}

extension FactsEnvironment {
  static let mock: Self = {
    let facts = [
      "Number 5 is greater than 3",
      "The sky is not always blue",
      "The grass is always greener on the other side",
      "Water boils in 100℃",
      nil
    ]
    var fetchCount = 0
    return Self(
      fetchRandomFact: {
        Deferred<AnyPublisher<String, Error>> {
          defer { fetchCount += 1 }
          if let fact = facts[fetchCount % facts.count] {
            return Just(fact)
              .setFailureType(to: Error.self)
              .eraseToAnyPublisher()
          } else {
            return Fail(outputType: String.self, failure: NSError(domain: "", code: 0, userInfo: nil))
              .eraseToAnyPublisher()
          }
        }
        .delay(for: .seconds(2), scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
      },
      mainScheduler: .main
    )
  }()
}

let factsReducer = Reducer<FactsState, FactsAction, FactsEnvironment> { state, action, env in
  switch action {
  case .fetchFact:
    state.isFetchingFact = true
    return env.fetchRandomFact()
      .map(FactsAction.didFetchFact)
      .replaceError(with: .didFailFetchingFact)
      .receive(on: env.mainScheduler)
      .eraseToEffect()

  case let .didFetchFact(fact):
    state.isFetchingFact = false
    state.fetchDidFail = false
    state.fact = fact
    return .none

  case .didFailFetchingFact:
    state.isFetchingFact = false
    state.fetchDidFail = true
    return .none
  }
}

struct FactsView: View {
  let store: Store<FactsState, FactsAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 16) {
        Spacer()

        if let fact = viewStore.fact {
          Text(fact).font(.title2)
        }

        Spacer()

        if viewStore.fetchDidFail {
          Text("Unable to fetch fact").foregroundColor(.red)
        }

        if viewStore.isFetchingFact {
          Text("Fetching random fact...").foregroundColor(.gray)
        } else {
          Button("Fetch random fact") {
            viewStore.send(.fetchFact)
          }
        }
      }
      .padding()
      .padding(.vertical, 32)
    }
  }
}

#if DEBUG
struct FactsView_Previews: PreviewProvider {
  static var previews: some View {
    FactsView(store: Store(
      initialState: FactsState(
        fact: "Xcode previews are cool",
        isFetchingFact: false,
        fetchDidFail: false
      ),
      reducer: .empty,
      environment: ()
    ))
  }
}
#endif
