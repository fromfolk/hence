
import Hence
import XCTest

final class RecurringTests: XCTestCase {
  func testDailyRecurrence_atMorning() {
    let recurring = Recurring.daily(at: .morning)
    
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 15, minute: 24)
    let expectedDate = Date(year: 2021, month: 11, day: 30, hour: 6, minute: 0)

    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testDailyRecurrence_atAfternoon() {
    let recurring = Recurring.daily(at: .afternoon)
    
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 15, minute: 24)
    let expectedDate = Date(year: 2021, month: 11, day: 30, hour: 12, minute: 0)

    let calculatedDate = try! recurring.nextOccurence(after: startDate)
    
    XCTAssertEqual(calculatedDate, expectedDate)
  }
  
  func testDailyRecurrence_atEvening() {
    let recurring = Recurring.daily(at: .evening)
    
    let startDate = Date(year: 2021, month: 11, day: 29, hour: 15, minute: 24)
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
