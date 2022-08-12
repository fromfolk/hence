
import ComposableArchitecture

public enum DateFrequency: String, CaseIterable {
  case daily = "Day"
  case weekly = "Week"
  case monthly = "Month"
}

public struct ReminderCreationState: Equatable {
  public init() {
    
  }
  
  public var name = ""
  public var dateFrequency = DateFrequency.daily
}

public enum ReminderCreationAction {
  case showName
  case editName(String)
  case dateFrequencyChanged(DateFrequency)
}

public struct ReminderCreationEnvironment {
  public init() {
    
  }
}

public let reminderCreationReducer = Reducer<ReminderCreationState, ReminderCreationAction, ReminderCreationEnvironment> { state, action, environment in
  switch(action) {
  case .showName:
    state.name = "Hello, Composable Hence!"
    return .none
    
  case .editName(let update):
    state.name = update
    return .none
    
  case .dateFrequencyChanged(let update):
    state.dateFrequency = update
    return .none
  }
}
