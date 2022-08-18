
import ComposableArchitecture
import Hence
import Reminder
import RemindersList
import SwiftUI

struct AppState {
  var remindersState = RemindersState()
}

enum AppAction {
  case reminders(RemindersAction)
}

struct AppEnvironment {
  let uuid: () -> UUID
  let mainQueue: AnySchedulerOf<DispatchQueue>
  
  public init(uuid: @escaping () -> UUID, mainQueue: AnySchedulerOf<DispatchQueue>) {
    self.uuid = uuid
    self.mainQueue = mainQueue
  }
  
  static var live = AppEnvironment(uuid: UUID.init, mainQueue: .main)
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  remindersReducer
    .pullback(
      state: \.remindersState,
      action: /AppAction.reminders,
      environment: { _ in () }
    )
)

let store = Store(
  initialState: AppState(),
  reducer: appReducer.debug(),
  environment: .live
)

@main
struct iOSApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        RemindersList(
          store: store.scope(
            state: \.remindersState,
            action: AppAction.reminders
          )
        )
      }
    }
  }
}
