
import Foundation

internal class SKCalendarDay {
    
    
    internal var dateComponents: NSDateComponents!
    
    init(dateComponent: NSDateComponents) {
        self.dateComponents = dateComponent
    }
    
    convenience init(day: NSDate) {
        let components = SKCalendarAttributes.calendar.defaultComponentsFromDate(day)
        self.init(dateComponent: components)
    }
    
    func nextDay() -> SKCalendarDay {
        let date = SKCalendarAttributes.calendar.dateFromComponents(dateComponents)
        let nextDay = SKCalendarAttributes.calendar.dayAfterDate(date!)
        return SKCalendarDay(day: nextDay!)
    }
    
    func previousDay() -> SKCalendarDay  {
        let date = SKCalendarAttributes.calendar.dateFromComponents(dateComponents)
        let previousDay = SKCalendarAttributes.calendar.dayBeforeDate(date!)
        return SKCalendarDay(day: previousDay)
    }
    
    func dayByAddingNumberOfDay(days: Int) -> SKCalendarDay {
        let date = SKCalendarAttributes.calendar.dateFromComponents(dateComponents)
        let component = NSDateComponents()
        component.day = days
        let nextDay = SKCalendarAttributes.calendar.nextDate(to: date!, byAddingDateComponent: component)
        return SKCalendarDay(day: nextDay)
    }
    
    func formattedDay() -> String {
        let date = SKCalendarAttributes.calendar.dateFromComponents(dateComponents)
        return  SKCalendarAttributes.formatDayNameFromDate(date!)
    }
    
    var dayName: String {
        let date = SKCalendarAttributes.calendar.dateFromComponents(dateComponents)
        return SKCalendarAttributes.formatDayNameFromDate(date!)
    }
}
