
import Foundation

internal class SKCalendarDay {
    
    
    internal var dateComponents: DateComponents!
    
    init(dateComponent: DateComponents) {
        self.dateComponents = dateComponent
    }
    
    convenience init(day: Date) {
        let components = SKCalendarAttributes.calendar.defaultComponentsFromDate(date: day)
        self.init(dateComponent: components)
    }
    
    func nextDay() -> SKCalendarDay {
        let date = SKCalendarAttributes.calendar.date(from: dateComponents)
        let nextDay = SKCalendarAttributes.calendar.dayAfterDate(date: date!)
        return SKCalendarDay(day: nextDay!)
    }
    
    func previousDay() -> SKCalendarDay  {
        let date = SKCalendarAttributes.calendar.date(from: dateComponents)
        let previousDay = SKCalendarAttributes.calendar.dayBeforeDate(date: date!)
        return SKCalendarDay(day: previousDay!)
    }
    
    func dayByAddingNumberOfDay(days: Int) -> SKCalendarDay {
        let date = SKCalendarAttributes.calendar.date(from: dateComponents)
        var component = DateComponents()
        component.day = days
        let nextDay = SKCalendarAttributes.calendar.nextDate(to: date!, byAddingDateComponent: component)
        return SKCalendarDay(day: nextDay)
    }
    
    func formattedDay() -> String {
        let date = SKCalendarAttributes.calendar.date(from: dateComponents)
        return  SKCalendarAttributes.formatDayNameFromDate(date: date!)
    }
    
    var dayName: String {
        let date = SKCalendarAttributes.calendar.date(from:dateComponents)
        return SKCalendarAttributes.formatDayNameFromDate(date: date!)
    }
}
