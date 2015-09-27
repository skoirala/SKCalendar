
internal class SKCalendarMonth {
    
    let dateComponent: NSDateComponents
    
    internal init(dateComponent: NSDateComponents) {
        self.dateComponent = dateComponent
        self.dateComponent.day = 1
    }
    
    convenience init(date: NSDate!) {
        let components = SKCalendarAttributes.calendar.defaultComponentsFromDate(date)
        self.init(dateComponent: components)
    }
    
    internal var firstDay: Int {
        return SKCalendarAttributes.calendar.firstWeekDayFromDateComponents(dateComponent)
    }
    
    internal var lastDay: Int {
        let component = SKCalendarAttributes.calendar.components(NSCalendarUnit.Weekday, fromDate: lastDate)
        return component.weekday
    }
    
    internal var lastDate: NSDate {
        let component = dateComponent.copy() as! NSDateComponents
        component.day = numberOfDays
        return SKCalendarAttributes.calendar.dateFromComponents(component)!
    }
    internal var numberOfDays: Int {
        return SKCalendarAttributes.calendar.numberOfDaysInMonthFromDateComponents(dateComponent)
    }
}
