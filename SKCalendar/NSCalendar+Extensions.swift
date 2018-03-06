

internal extension DateComponents {
    
    init(day: Int, month: Int, year: Int) {
        self.init()
        self.day = day
        self.month = month
        self.year = year
    }
    
}

internal extension Calendar {
    
    internal func defaultComponentsFromDate(date: Date) -> DateComponents {
        return dateComponents([.day, .month, .year], from: date)
    }
    
    internal func numberOfDaysInMonth(date: Date) -> Int {
        let dayRange = range(of: .day, in: .month, for: date)
        return (dayRange!.upperBound - dayRange!.lowerBound)
    }
    
    internal func numberOfDaysInMonthFromDateComponents(component: DateComponents) -> Int {
        return numberOfDaysInMonth(date: date(from: component)!)
    }
    
    internal func numberOfWeeksInMonth(date: Date) -> Int {
        let dayRange = range(of: .weekOfMonth, in: .month, for: date)

        return dayRange!.upperBound - dayRange!.lowerBound
    }
    
    internal func numberOfDaysBetweenDates(fromDate: Date, toDate: Date) -> Int {
        let comp = dateComponents([.day], from: fromDate, to: toDate)
        return comp.day!
    }
    
    internal func numberOfMonthsBetweenDates(fromDate: Date, toDate: Date) -> Int {
        let comp = dateComponents([.month], from: fromDate, to: toDate)
        return comp.month!
    }
    
    internal func numberOfYearsBetweenDates(fromDate: Date, toDate: Date) -> Int {
        let comp = dateComponents([.year], from: fromDate, to: toDate)
        return comp.year!
    }
    
    internal func firstWeekDayFromDateComponents(dateComponents: DateComponents) -> Int {
        return component(.weekday, from: date(from: dateComponents)!)
    }
    
    internal func nextDate(to forDate:Date, byAddingDateComponent dateComponent: DateComponents) -> Date {
        return date(byAdding: dateComponent, to: forDate)!
    }
    
    internal func monthBeforeDate(date: Date) -> Date! {
        var component = DateComponents()
        component.month = -1
        return nextDate(to: date, byAddingDateComponent: component)
    }
    
    internal func monthAfterDate(date: Date) -> Date! {
        var component = DateComponents()
        component.month = 1
        return nextDate(to: date, byAddingDateComponent: component)
    }
    
    internal func dayAfterDate(date: Date) -> Date! {
        var component = DateComponents()
        component.day = 1
        return nextDate(to: date, byAddingDateComponent: component)
    }
    
    internal func dayBeforeDate(date: Date) -> Date! {
        var component = DateComponents()
        component.day = -1
        return nextDate(to: date, byAddingDateComponent:component)
    }
}
