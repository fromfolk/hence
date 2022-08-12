
import ComposableArchitecture
import Hence
import SwiftUI

let store = Store(
  initialState: HenceState(),
  reducer: henceReducer,
  environment: HenceEnvironment()
)

@main
struct iOSApp: App {  
  var body: some Scene {
    WindowGroup {
      ReminderCreationView(store: store)
    }
  }
}
