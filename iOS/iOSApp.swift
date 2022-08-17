
import ComposableArchitecture
import Hence
import SwiftUI

let appReducer = Reducer<RemindersState, RemindersAction, ()>.combine(
  remindersReducer,
  reminderCreationReducer
    .optional()
    .pullback(
      state: \RemindersState.reminderCreation,
      action: /RemindersAction.reminderCreation,
      environment: { _ in ReminderCreationEnvironment(uuid: UUID.init, mainQueue: .main)}
    )
)

let store = Store(
  initialState: RemindersState(),
  reducer: appReducer.debug(),
  environment: ()
)

@main
struct iOSApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        RemindersList(store: store)
      }
    }
  }
}
