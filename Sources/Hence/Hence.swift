
import ComposableArchitecture

public struct HenceState: Equatable {
  public init() {
    
  }
  
  public var text = ""
}

public enum HenceAction {
  case showMessage
}

public struct HenceEnvironment {
  public init() {
    
  }
}

public let appReducer = Reducer<HenceState, HenceAction, HenceEnvironment> { state, action, environment in
  switch(action) {
  case .showMessage:
    state.text = "Hello, Composable Hence!"
    return .none
  }
}
