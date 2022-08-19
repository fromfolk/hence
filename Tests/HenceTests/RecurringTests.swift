
import Hence
import XCTest

final class RecurringTests: XCTestCase {
  func testDailyRecurrence_isToday() {
    let morning = Recurring.daily(at: .morning)
    let afternoon = Recurring.daily(at: .afternoon)
    let evening = Recurring.daily(at: .evening)
    
    XCTAssertTrue(morning.isToday(Date(year: 2000, month: 6, day: 4, hour: 0, minute: 0)))
    XCTAssertTrue(afternoon.isToday(Date(year: 2300, month: 10, day: 3, hour: 0, minute: 0)))
    XCTAssertTrue(evening.isToday(Date()))
  }
  
  func testWeeklyRecurrence_isToday() {
    let monday = Date(year: 2021, month: 11, day: 29, hour: 4, minute: 24)
    let tuesday = Date(year: 2021, month: 11, day: 30, hour: 4, minute: 24)
    let wednesday = Date(year: 2021, month: 12, day: 1, hour: 4, minute: 24)
    let thursday = Date(year: 2021, month: 12, day: 2, hour: 4, minute: 24)
    let friday = Date(year: 2021, month: 12, day: 3, hour: 4, minute: 24)
    let saturday = Date(year: 2021, month: 12, day: 4, hour: 4, minute: 24)
    let sunday = Date(year: 2021, month: 12, day: 5, hour: 4, minute: 24)

    let recurring = Recurring.weekly(on: [.monday, .wednesday, .friday], at: .afternoon)

    XCTAssertTrue(recurring.isToday(monday))
    XCTAssertFalse(recurring.isToday(tuesday))
    XCTAssertTrue(recurring.isToday(wednesday))
    XCTAssertFalse(recurring.isToday(thursday))
    XCTAssertTrue(recurring.isToday(friday))
    XCTAssertFalse(recurring.isToday(saturday))
    XCTAssertFalse(recurring.isToday(sunday))
  }
  
  func testMonthlyRecurrence_isToday() {
    let first = Date(year: 2021, month: 11, day: 1, hour: 4, minute: 24)
    let fifth = Date(year: 2021, month: 11, day: 5, hour: 4, minute: 24)
    let tenth = Date(year: 2021, month: 11, day: 10, hour: 4, minute: 24)
    let fifteenth = Date(year: 2021, month: 11, day: 15, hour: 4, minute: 24)
    let twentieth = Date(year: 2021, month: 11, day: 20, hour: 4, minute: 24)
    let twentyfifth = Date(year: 2021, month: 11, day: 25, hour: 4, minute: 24)
    let thirtieth = Date(year: 2021, month: 11, day: 30, hour: 4, minute: 24)

    let recurring = Recurring.monthly(on: [1, 10, 20], at: .afternoon)

    XCTAssertTrue(recurring.isToday(first))
    XCTAssertFalse(recurring.isToday(fifth))
    XCTAssertTrue(recurring.isToday(tenth))
    XCTAssertFalse(recurring.isToday(fifteenth))
    XCTAssertTrue(recurring.isToday(twentieth))
    XCTAssertFalse(recurring.isToday(twentyfifth))
    XCTAssertFalse(recurring.isToday(thirtieth))
  }
  
  func testDailyRecurrence_atMorning_beforeTodaysOccurence() {
    let recurring = Recurring.daily(at: .morning)
    
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 4, minute: 24)
    let expectedDate = Date(year: 2021, month: 11, day: 29, hour: 6, minute: 0)

    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testDailyRecurrence_atAfternoon_beforeTodaysOccurence() {
    let recurring = Recurring.daily(at: .afternoon)
    
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 11, minute: 24)
    let expectedDate = Date(year: 2021, month: 11, day: 29, hour: 12, minute: 0)

    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testDailyRecurrence_atEvening_beforeTodaysOccurence() {
    let recurring = Recurring.daily(at: .evening)
    
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 12, minute: 24)
    let expectedDate = Date(year: 2021, month: 11, day: 29, hour: 18, minute: 0)

    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testDailyRecurrence_atMorning_afterTodaysOccurence() {
    let recurring = Recurring.daily(at: .morning)
    
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 15, minute: 24)
    let expectedDate = Date(year: 2021, month: 11, day: 30, hour: 6, minute: 0)

    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testDailyRecurrence_atAfternoon_afterTodaysOccurence() {
    let recurring = Recurring.daily(at: .afternoon)
    
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 15, minute: 24)
    let expectedDate = Date(year: 2021, month: 11, day: 30, hour: 12, minute: 0)

    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testDailyRecurrence_atEvening_afterTodaysOccurence() {
    let recurring = Recurring.daily(at: .evening)
    
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 18, minute: 24)
    let expectedDate = Date(year: 2021, month: 11, day: 30, hour: 18, minute: 0)

    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testDailyRecurrence_allDay() {
    let recurring = Recurring.daily(at: .allDay)
    
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 15, minute: 24)
    let expectedDate = Date(year: 2021, month: 11, day: 30, hour: 0, minute: 0)

    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testDailyRecurrence_atCustomTime() {
    let recurring = Recurring.daily(at: .custom(Time(hour: 14, minute: 57)))
    
    let startDate = Date(year: 2021, month: 12, day: 31, hour: 15, minute: 24)
    let expectedDate = Date(year: 2022, month: 1, day: 1, hour: 14, minute: 57)

    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testWeeklyRecurrence_whenStartIsBefore_lastOccurenceThisWeek() {
    let recurring = Recurring.weekly(on: [.monday, .wednesday, .friday], at: .evening)
            
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 15, minute: 24)
    let expectedDate = Date(year: 2021, month: 12, day: 1, hour:18, minute: 0)
    
    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testWeeklyRecurrence_whenStartIsAfter_lastOccurenceThisWeek() {
    let recurring = Recurring.weekly(on: [.monday], at: .evening)
        
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 15, minute: 24)
    let expectedDate = Date(year: 2021, month: 12, day: 6, hour:18, minute: 0)
    
    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testMonthlyRecurrence_whenStartIsBefore_lastOccurenceThisMonth() {
    let recurring = Recurring.monthly(on: [15, 30], at: .afternoon)
    
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 15, minute: 24)
    let expectedDate = Date(year: 2021, month: 11, day: 30, hour:12, minute: 0)
    
    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testMonthlyRecurrence_whenStartIsAfter_lastOccurenceThisMonth() {
    let recurring = Recurring.monthly(on: [1, 15], at: .afternoon)
    
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 15, minute: 24)
    let expectedDate = Date(year: 2021, month: 12, day: 1, hour:12, minute: 0)
    
    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
}
