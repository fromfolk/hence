
import ComposableArchitecture
import Hence
import Reminder
import RemindersList
import SwiftUI
import Today

struct AppState {
  var remindersState = RemindersState()
  var todayState: TodayState {
    get {
      TodayState(reminders: remindersState.reminders)
    }
    set {
      remindersState.reminders = newValue.reminders
    }
  }
}

enum AppAction {
  case reminders(RemindersAction)
  case today(TodayAction)
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
  remindersReducer.pullback(
    state: \.remindersState,
    action: /AppAction.reminders,
    environment: { _ in () }
  ),
  todayReducer.pullback(
    state: \.todayState,
    action: /AppAction.today,
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
      TabView {
        NavigationView {
          RemindersList(
            store: store.scope(
              state: \.remindersState,
              action: AppAction.reminders
            )
          )
        }
        .tabItem {
          VStack {
            Image(systemName: "list.bullet")
            Text("Reminders")
          }
        }
        
        NavigationView {
          TodayView(
            store: store.scope(
              state: \.todayState,
              action: AppAction.today
            )
          )
        }
        .tabItem {
          VStack {
            Image(systemName: "checklist")
            Text("Today")
          }
        }
      }
    }
  }
}
