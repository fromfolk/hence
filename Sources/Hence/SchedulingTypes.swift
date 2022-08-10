
import Foundation
import SwiftDate

public struct Time: Hashable {
  let hour: Int
  let minute: Int
  
  public init(hour: Int, minute: Int) {
    self.hour = hour
    self.minute = minute
  }
  
  var interval: TimeInterval {
    return TimeInterval(hour * 60 * 60 + minute * 60)
  }
}

public enum TimeOfDay: Hashable {
  case morning
  case afternoon
  case evening
  case allDay
  case custom(Time)
  
  public var interval: TimeInterval {
    switch self {
    case .morning:
      return 6 * 60 * 60
    case .afternoon:
      return 12 * 60 * 60
    case .evening:
      return 18 * 60 * 60
    case .allDay:
      return 0
    case let .custom(offset):
      return offset.interval
    }
  }
}

public enum Recurring {
  case daily(at: TimeOfDay)
  case weekly(on: [WeekDay], at: TimeOfDay)
  case monthly(on: [Int], at: TimeOfDay)
}
