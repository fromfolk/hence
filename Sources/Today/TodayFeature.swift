
import ComposableArchitecture
import Foundation
import Reminder

public struct TodayState: Equatable {
  var dueReminders: IdentifiedArrayOf<Reminder> = []
  var doneReminders: IdentifiedArrayOf<Reminder> = []
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
    sortReminders()
    return .none
    
  case .dueTapped(let reminder):
    let new = Reminder(
      id: reminder.id,
      name: reminder.name,
      image: reminder.image,
      recurring: reminder.recurring,
      lastCompleted: environment.date()
    )
    
    state.reminders.removeAll { $0 == reminder }
    state.reminders.append(new)
    
    sortReminders()
    
    return .none
  }
  
  func sortReminders() {
    state.dueReminders = state.reminders.filter { $0.recurring.isToday(environment.date()) && !$0.lastCompleted.isToday }
    state.doneReminders = state.reminders.filter { $0.recurring.isToday(environment.date()) && $0.lastCompleted.isToday }
    state.laterReminders = state.reminders.filter { !$0.recurring.isToday(environment.date()) }
  }
}
