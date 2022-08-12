
import ComposableArchitecture
import Hence
import SwiftUI

let store = Store(
  initialState: ReminderCreationState(),
  reducer: reminderCreationReducer,
  environment: ReminderCreationEnvironment()
)

@main
struct iOSApp: App {  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ReminderCreationView(store: store)
      }
    }
  }
}
