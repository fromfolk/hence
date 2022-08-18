
import ComposableArchitecture
import Reminder

public struct TodayState: Equatable {
  public var reminders: IdentifiedArrayOf<Reminder>
  
  public init(reminders: IdentifiedArrayOf<Reminder> = []) {
    self.reminders = reminders
  }
}

public enum TodayAction {
  case none
}

public let todayReducer = Reducer<TodayState, TodayAction, ()> { state, action, _ in
  switch action {
  case .none:
    return .none
  }
}
