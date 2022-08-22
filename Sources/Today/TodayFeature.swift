
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

public struct TodayEnvironment {
  let date: () -> Date
  
  public static var live = TodayEnvironment(date: Date.init)
  
  public init(date: @escaping () -> Date) {
    self.date = date
  }
}

public let todayReducer = Reducer<TodayState, TodayAction, TodayEnvironment> { state, action, environment in
  switch action {
  case .none:
    return .none
  }
}
