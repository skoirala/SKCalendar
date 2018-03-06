
internal class SKCalendarMonth {
    
    let dateComponent: DateComponents
    
    internal init(dateComponent: DateComponents) {
        var component = dateComponent
        component.day = 1
        self.dateComponent = component
    }
    
    convenience init(date: Date) {
        let components = SKCalendarAttributes.calendar.defaultComponentsFromDate(date: date)
        self.init(dateComponent: components)
    }
    
    internal var firstDay: Int {
        return SKCalendarAttributes.calendar.firstWeekDayFromDateComponents(dateComponents: dateComponent)
    }
    
    internal var lastDay: Int {
        return SKCalendarAttributes.calendar.component(.weekday, from: lastDate)
    }
    
    internal var lastDate: Date {
        var component = dateComponent
        component.day = numberOfDays
        return SKCalendarAttributes.calendar.date(from: component)!
    }
    
    internal var numberOfDays: Int {
        return SKCalendarAttributes.calendar.numberOfDaysInMonthFromDateComponents(component: dateComponent)
    }
}
