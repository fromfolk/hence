
import SwiftDate
import ComposableArchitecture

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
  var name = ""
  var dateFrequency = DateFrequency.daily
  var selectedWeekDays: [WeekDay] = Array()
  var selectedMonthDays: [Int] = Array()
  var timeFrequency = TimeFrequency.morning
  
  var isSaveDisabled: Bool {
    name.isEmpty || (dateFrequency == .weekly && selectedWeekDays.isEmpty) || (dateFrequency == .monthly && selectedMonthDays.isEmpty)
  }
  
  public init() {}
}

public enum ReminderCreationAction {
  case editName(String)
  case dateFrequencyChanged(DateFrequency)
  case selectedWeekDaysChanged(WeekDay)
  case selectedMonthDaysChanged(Int)
  case timeFrequencyChanged(TimeFrequency)
}

public struct ReminderCreationEnvironment {
  public init() {}
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
  }
}
