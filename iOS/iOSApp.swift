
import ComposableArchitecture
import Hence
import Reminder
import RemindersList
import SwiftUI
import Today

struct AppState {
  var reminders: IdentifiedArrayOf<Reminder> = []
  
  var _remindersState = RemindersState()
  var remindersState: RemindersState {
    get {
      var state = _remindersState
      state.reminders = self.reminders
      return state
    }
    set {
      _remindersState = newValue
      reminders = newValue.reminders
    }
  }
  
  var _todayState = TodayState()
  var todayState: TodayState {
    get {
      var state = _todayState
      state.reminders = self.reminders
      return state
    }
    set {
      _todayState = newValue
      reminders = newValue.reminders
    }
  }
}

enum AppAction {
  case reminders(RemindersAction)
  case today(TodayAction)
}

struct AppEnvironment {
  let date: () -> Date
  let uuid: () -> UUID
  let mainQueue: AnySchedulerOf<DispatchQueue>
  
  public init(date: @escaping () -> Date, uuid: @escaping () -> UUID, mainQueue: AnySchedulerOf<DispatchQueue>) {
    self.date = date
    self.uuid = uuid
    self.mainQueue = mainQueue
  }
  
  static var live = AppEnvironment(date: Date.init, uuid: UUID.init, mainQueue: .main)
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>
  .combine(
    remindersReducer.pullback(
      state: \.remindersState,
      action: /AppAction.reminders,
      environment: { RemindersEnvironment(date: $0.date, uuid: $0.uuid, mainQueue: $0.mainQueue) }
    ),
    todayReducer.pullback(
      state: \.todayState,
      action: /AppAction.today,
      environment: { TodayEnvironment(date: $0.date) }
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
