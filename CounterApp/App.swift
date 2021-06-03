import ComposableArchitecture
import SwiftUI

@main
struct App: SwiftUI.App {
  let counterStore = Store<CounterState, CounterAction>(
    initialState: CounterState(),
    reducer: counterReducer.debug(),
    environment: ()
  )

  var body: some Scene {
    WindowGroup {
      CounterView(store: counterStore)

      // UIKitViewController {
      //   CounterViewController(store: counterStore)
      // }
      // .ignoresSafeArea()
    }
  }
}
