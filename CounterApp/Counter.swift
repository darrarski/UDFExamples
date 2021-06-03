import ComposableArchitecture

struct CounterState: Equatable {
  var count: Int = 0
}

enum CounterAction: Equatable {
  case increment
  case decrement
  case reset
}

let counterReducer = Reducer<CounterState, CounterAction, Void> { state, action, _ in
  switch action {
  case .increment:
    state.count += 1
    return .none

  case .decrement:
    state.count -= 1
    return .none

  case .reset:
    state.count = 0
    return .none
  }
}
