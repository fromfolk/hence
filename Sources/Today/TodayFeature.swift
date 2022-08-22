
import ComposableArchitecture
import Reminder

public struct TodayState: Equatable {
  public var dueReminders: IdentifiedArrayOf<Reminder>
  public var laterReminders: IdentifiedArrayOf<Reminder>
    
  public init(
    dueReminders: IdentifiedArrayOf<Reminder> = [],
    laterReminders: IdentifiedArrayOf<Reminder> = []
  ) {
    self.dueReminders = dueReminders
    self.laterReminders = laterReminders
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
