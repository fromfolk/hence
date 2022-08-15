
import ComposableArchitecture
import Hence
import SwiftUI

//let store = Store(
//  initialState: ReminderCreationState(),
//  reducer: reminderCreationReducer.debug(),
//  environment: .live
//)
//
//@main
//struct iOSApp: App {
//  var body: some Scene {
//    WindowGroup {
//      NavigationView {
//        ReminderCreationView(store: store)
//      }
//    }
//  }
//}

//struct AppState {
//  var reminders: [Reminder]
//  
//  var remindersState: RemindersState {
//    get {
//      ReminderState()
//    }
//    set {
//      self.reminders = newValue.reminders
//    }
//  }
//  var reminderCreationState: ReminderCreationState?
//}

let appReducer = Reducer<RemindersState, RemindersAction, RemindersEnvironment>.combine(
  remindersReducer,
  reminderCreationReducer
    .optional()
    .pullback(
      state: \RemindersState.reminderCreation,
      action: /RemindersAction.reminderCreation,
      environment: { _ in ReminderCreationEnvironment(uuid: UUID.init)}
    )
)

let store = Store(
  initialState: RemindersState(),
  reducer: appReducer.debug(),
  environment: RemindersEnvironment()
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
