import ComposableArchitecture
import SwiftUI

@main
struct FactsAppApp: App {
  var body: some Scene {
    WindowGroup {
      FactsView(store: Store(
        initialState: FactsState(),
        reducer: factsReducer.debug(),
        environment: FactsEnvironment.mock
      ))
    }
  }
}
