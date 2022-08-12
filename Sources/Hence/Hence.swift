
import ComposableArchitecture

public struct ReminderCreationState: Equatable {
  public init() {
    
  }
  
  public var name = ""
}

public enum ReminderCreationAction {
  case showName
  case editName(String)
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
  }
}
