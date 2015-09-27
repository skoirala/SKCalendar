
import XCTest


@testable import SKCalendar

class SKCalendarDayTests: XCTestCase {
    
    lazy var dateComponents: NSDateComponents = {
        let dateComponents = NSDateComponents(day: 25, month: 9, year: 2015)
        return dateComponents
    }()
    
    func testThatNextDayIsTomorrow() {
        let calendarDay = SKCalendarDay(dateComponent: dateComponents)
        
        let nextCalendarDay = calendarDay.nextDay()
        
        XCTAssert(nextCalendarDay.dateComponents.month == calendarDay.dateComponents.month, "month is not same")
        XCTAssert(nextCalendarDay.dateComponents.year == calendarDay.dateComponents.year, "year is not same")
        XCTAssert(nextCalendarDay.dateComponents.day == calendarDay.dateComponents.day + 1, "day is not same")
        
    }
    
    func testThatPreviousDayIsYesterday() {
        let calendarDay = SKCalendarDay(dateComponent: dateComponents)
        
        let previousCalendarDay = calendarDay.previousDay()
        
        XCTAssert(previousCalendarDay.dateComponents.month == calendarDay.dateComponents.month, "month is not same")
        XCTAssert(previousCalendarDay.dateComponents.year == calendarDay.dateComponents.year, "year is not same")
        XCTAssert(previousCalendarDay.dateComponents.day == calendarDay.dateComponents.day - 1, "day is not same")
    }
    
    
    func testThatDayByAddingDayReturnsCorrectValue() {
        let calendarDay = SKCalendarDay(dateComponent: dateComponents)
        let threeDaysAfter = calendarDay.dayByAddingNumberOfDay(3)
        
        XCTAssert(calendarDay.dateComponents.day + 3 == threeDaysAfter.dateComponents.day, "day is not same")
    }
    
    func testThatNextDayAfterLastDayOfMonthIsValid() {
        let lastDay = NSDateComponents(day: 30, month: 9, year: 2015)
        let calendarDay = SKCalendarDay(dateComponent: lastDay)
        
        let nextDay = calendarDay.nextDay()
        XCTAssert(nextDay.dateComponents.year == 2015)
        XCTAssert(nextDay.dateComponents.month == 10)
        XCTAssert(nextDay.dateComponents.day == 1)
        
        
        let threeDaysAfter = calendarDay.dayByAddingNumberOfDay(3)
        XCTAssert(threeDaysAfter.dateComponents.day == 3)
        XCTAssert(threeDaysAfter.dateComponents.year == 2015)
        XCTAssert(threeDaysAfter.dateComponents.month == 10)
        
        
        let lastDayOfYear = NSDateComponents(day: 31, month: 12, year: 2014)
        let lastCalendarDay = SKCalendarDay(dateComponent: lastDayOfYear)
        let firstDayOfYear = lastCalendarDay.nextDay()
        XCTAssert(firstDayOfYear.dateComponents.day == 1)
        XCTAssert(firstDayOfYear.dateComponents.month == 1)
        XCTAssert(firstDayOfYear.dateComponents.year == 2015)
    }
    
}
