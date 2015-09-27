

internal extension NSDateComponents {
    
    convenience init(day: Int, month: Int, year: Int) {
        self.init()
        self.day = day
        self.month = month
        self.year = year
    }
    
}

internal extension NSCalendar {
    
    internal func defaultComponentsFromDate(date: NSDate) -> NSDateComponents {
        return components([.Day, .Month, .Year], fromDate: date)
    }
    
    internal func numberOfDaysInMonth(date: NSDate) -> Int {
        let range = rangeOfUnit(.Day, inUnit:.Month, forDate: date)
        return range.length
    }
    
    internal func numberOfDaysInMonthFromDateComponents(date: NSDateComponents) -> Int {
        return numberOfDaysInMonth(dateFromComponents(date)!)
    }
    
    internal func numberOfWeeksInMonth(date: NSDate) -> Int {
        let range = rangeOfUnit(.WeekOfMonth, inUnit: NSCalendarUnit.Month, forDate: date)
        return range.length
    }
    
    internal func numberOfDaysBetweenDates(fromDate: NSDate, toDate: NSDate) -> Int {
        let comp = components(.Day, fromDate: fromDate, toDate: toDate, options: [])
        return comp.day
    }
    
    internal func numberOfMonthsBetweenDates(fromDate: NSDate, toDate: NSDate) -> Int {
        let comp = components(.Month, fromDate: fromDate, toDate: toDate, options: [])
        return comp.month
    }
    
    internal func numberOfYearsBetweenDates(fromDate: NSDate, toDate: NSDate) -> Int {
        let comp = components(.Year, fromDate: fromDate, toDate: toDate, options: [])
        return comp.year
    }
    
    internal func firstWeekDayFromDateComponents(dateComponents: NSDateComponents) -> Int {
        return component(.Weekday, fromDate: dateFromComponents(dateComponents)!)
    }
    
    internal func nextDate(to date:NSDate, byAddingDateComponent dateComponent: NSDateComponents) -> NSDate {
        return dateByAddingComponents(dateComponent, toDate: date, options: .MatchNextTime)!
    }
    
    internal func monthBeforeDate(date: NSDate) -> NSDate! {
        let component = NSDateComponents()
        component.month = -1
        return nextDate(to: date, byAddingDateComponent: component)
    }
    
    internal func monthAfterDate(date: NSDate) -> NSDate! {
        let component = NSDateComponents()
        component.month = 1
        return nextDate(to: date, byAddingDateComponent: component)
    }
    
    internal func dayAfterDate(date: NSDate) -> NSDate! {
        let component = NSDateComponents()
        component.day = 1
        return nextDate(to: date, byAddingDateComponent: component)
    }
    
    internal func dayBeforeDate(date: NSDate) -> NSDate! {
        let component = NSDateComponents()
        component.day = -1
        return nextDate(to: date, byAddingDateComponent:component)
    }
}
