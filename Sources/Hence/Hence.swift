
import SwiftDate
import ComposableArchitecture

public enum DateFrequency: String, CaseIterable {
  case daily = "Day"
  case weekly = "Week"
  case monthly = "Month"
}

public struct ReminderCreationState: Equatable {
  let weekDays: [WeekDay] = [
    .monday,
    .tuesday,
    .wednesday,
    .thursday,
    .friday,
    .saturday,
    .sunday
  ]
  
  public var name = ""
  public var dateFrequency = DateFrequency.daily
  public var selectedWeekDays: [WeekDay] = Array()
  
  public init() {}
}

public enum ReminderCreationAction {
  case editName(String)
  case dateFrequencyChanged(DateFrequency)
  case selectedWeekDaysChanged(WeekDay)
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
  }
}
