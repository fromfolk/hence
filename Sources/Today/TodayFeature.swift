
import ComposableArchitecture
import Foundation
import Reminder

public struct TodayState: Equatable {
  var doneReminders: IdentifiedArrayOf<Reminder> = []
  var dueReminders: IdentifiedArrayOf<Reminder> = []
  var laterReminders: IdentifiedArrayOf<Reminder> = []
    
  public var reminders: IdentifiedArrayOf<Reminder>
  
  public init(reminders: IdentifiedArrayOf<Reminder> = []) {
    self.reminders = reminders
  }
}

public enum TodayAction {
  case onAppear
  case dueTapped(Reminder)
}

public struct TodayEnvironment {
  let date: () -> Date
  
  public static var live = TodayEnvironment(date: Date.init)
  
  public init(date: @escaping () -> Date) {
    self.date = date
  }
}

public let todayReducer = Reducer<TodayState, TodayAction, TodayEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    state.dueReminders = state.reminders.filter { $0.recurring.isToday(environment.date()) && !state.doneReminders.contains($0) }
    state.laterReminders = state.reminders.filter { !$0.recurring.isToday(environment.date()) }
    return .none
    
  case .dueTapped(let reminder):
    state.doneReminders.append(reminder)
    state.dueReminders.removeAll { $0 == reminder }
    return .none
  }
}
