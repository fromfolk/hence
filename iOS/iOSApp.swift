
import ComposableArchitecture
import Hence
import SwiftUI

let store = Store(
  initialState: HenceState(),
  reducer: appReducer,
  environment: HenceEnvironment()
)

@main
struct iOSApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(store: store)
    }
  }
}
