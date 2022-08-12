
import SwiftDate
import ComposableArchitecture

public struct Reminder: Identifiable, Equatable {
  public let id: UUID
  let name: String
  let recurring: Recurring
  
  public static func == (lhs: Reminder, rhs: Reminder) -> Bool {
    lhs.id == rhs.id
  }
}

public enum DateFrequency: String, CaseIterable {
  case daily = "Day"
  case weekly = "Week"
  case monthly = "Month"
}

public enum TimeFrequency: String, CaseIterable {
  case morning = "Morning"
  case afternoon = "Afternoon"
  case evening = "Evening"
}

public struct ReminderCreationState: Equatable {
  var reminders: [Reminder]
  
  var name = ""
  var dateFrequency = DateFrequency.daily
  var selectedWeekDays: [WeekDay] = Array()
  var selectedMonthDays: [Int] = Array()
  var timeFrequency = TimeFrequency.morning
  
  var isSaveDisabled: Bool {
    name.isEmpty || (dateFrequency == .weekly && selectedWeekDays.isEmpty) || (dateFrequency == .monthly && selectedMonthDays.isEmpty)
  }
  
  public init(reminders: [Reminder] = Array()) {
    self.reminders = reminders
  }
}

public enum ReminderCreationAction {
  case editName(String)
  case dateFrequencyChanged(DateFrequency)
  case selectedWeekDaysChanged(WeekDay)
  case selectedMonthDaysChanged(Int)
  case timeFrequencyChanged(TimeFrequency)
  case save
}

public struct ReminderCreationEnvironment {
  let uuid: () -> UUID
  
  public init(uuid: @escaping () -> UUID) {
    self.uuid = uuid
  }
  
  public static var live = ReminderCreationEnvironment(uuid: UUID.init)
}

public let reminderCreationReducer = Reducer<ReminderCreationState, ReminderCreationAction, ReminderCreationEnvironment> { state, action, environment in
  switch(action) {
  case .editName(let update):
    state.name = update
    return .none
    
  case .dateFrequencyChanged(let update):
    state.dateFrequency = update
    return .none
    
  case .selectedWeekDaysChanged(let update):
    if state.selectedWeekDays.contains(update) {
      state.selectedWeekDays.removeAll { $0 == update }
    } else {
      state.selectedWeekDays.append(update)
    }
    state.selectedWeekDays.sort(by: { $0.rawValue < $1.rawValue } )
    return .none
    
  case .selectedMonthDaysChanged(let update):
    if state.selectedMonthDays.contains(update) {
      state.selectedMonthDays.removeAll { $0 == update }
    } else {
      state.selectedMonthDays.append(update)
    }
    state.selectedMonthDays.sort()
    return .none
    
  case .timeFrequencyChanged(let update):
    state.timeFrequency = update
    return .none
    
  case .save:
    let reminder: Reminder
    
    switch state.dateFrequency {
    case .daily:
      reminder = Reminder(
        id: environment.uuid(),
        name: state.name,
        recurring: .daily(at: .init(state.timeFrequency))
      )
      
    case .weekly:
      reminder = Reminder(
        id: environment.uuid(),
        name: state.name,
        recurring: .weekly(on: state.selectedWeekDays, at: .init(state.timeFrequency))
      )
      
    case .monthly:
      reminder = Reminder(
        id: environment.uuid(),
        name: state.name,
        recurring: .monthly(on: state.selectedMonthDays, at: .init(state.timeFrequency))
      )
    }
    
    state.reminders.append(reminder)
    return .none
  }
}

fileprivate extension TimeOfDay {
  init(_ timeFrequency: TimeFrequency) {
    switch timeFrequency {
    case .morning:
      self = .morning
    case .afternoon:
      self = .afternoon
    case .evening:
      self = .evening
    }
  }
}
