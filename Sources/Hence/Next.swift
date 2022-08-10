
import Foundation
import SwiftDate

fileprivate let daysInWeek = 7

fileprivate enum DateCalculationError: Error {
  case noLastElement
  case noNextOrdinal
}

public extension Recurring {
  func nextOccurence(after today: Date) throws -> Date {
    switch self {
    case let .daily(time):
      let tomorrowMidnightInterval = today.dateAt(.tomorrowAtStart).timeIntervalSinceReferenceDate
      let tomorrowTimeOfDayInterval = time.interval
      
      return Date(timeIntervalSinceReferenceDate: tomorrowMidnightInterval + tomorrowTimeOfDayInterval)
      
    case let .weekly(days, time):
      let sortedDays = days
        .map(\.rawValue)
        .sorted(by: <)
          
      let ordinalDifference = try numberOfDaysBetween(
        todaysOrdinal: today.weekday,
        andNextIn: sortedDays,
        cap: daysInWeek
      )
      
      return dateAfter(days: ordinalDifference, and: time, given: today)

    case let .monthly(days, time):
      let sortedDays = days
        .sorted(by: <)
          
      let ordinalDifference = try numberOfDaysBetween(
        todaysOrdinal: today.dateComponents.day!,
        andNextIn: sortedDays,
        cap: today.monthDays
      )
      
      return dateAfter(days: ordinalDifference, and: time, given: today)
    }
  }
}

fileprivate func numberOfDaysBetween(todaysOrdinal: Int, andNextIn collection: [Int], cap: Int) throws -> Int {
  guard let last = collection.last else { throw DateCalculationError.noLastElement }
  
  if last <= todaysOrdinal {
    let maybeNextOrdinal = collection.first
    
    guard let nextOrdinal = maybeNextOrdinal else { throw DateCalculationError.noNextOrdinal }

    return cap - todaysOrdinal + nextOrdinal
  } else {
    let maybeNextOrdinal = collection
      .filter { $0 > todaysOrdinal }
      .first
    
    guard let nextOrdinal = maybeNextOrdinal else { throw DateCalculationError.noNextOrdinal }
    
    return nextOrdinal - todaysOrdinal
  }
}

fileprivate func dateAfter(days ordinalDifference: Int, and timeOfDay: TimeOfDay, given today: Date) -> Date {
  let nextMidnight = today
    .dateByAdding(ordinalDifference, .day)
    .dateAt(.startOfDay)
  
  let nextMidnightInterval = nextMidnight.date.timeIntervalSinceReferenceDate
  let nextTimeOfDayInterval = timeOfDay.interval
  
  return Date(timeIntervalSinceReferenceDate: nextMidnightInterval + nextTimeOfDayInterval)
}
