import ComposableArchitecture
import SwiftUI

struct CounterView: View {
  let store: Store<CounterState, CounterAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 16) {
        Text("\(viewStore.count)").font(.largeTitle)
        Button("Increment") { viewStore.send(.increment) }
        Button("Decrement") { viewStore.send(.decrement) }
        Button("Reset") { viewStore.send(.reset) }
      }
    }
  }
}
