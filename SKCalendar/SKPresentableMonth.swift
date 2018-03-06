
internal class SKPresentableMonth {
    
    private let startingDay = 1
    private let numberOfDaysPerWeek = 7
    
    internal let actualMonth: SKCalendarMonth
    internal let totalDays: Int
    internal let firstDay: SKCalendarDay
    internal let lastDay: SKCalendarDay
    
    init(date: Date) {
        actualMonth = SKCalendarMonth(date: date)
        
        totalDays = SKCalendarAttributes.calendar.numberOfWeeksInMonth(date: date) * 7
        
        let actualMonthFirstDay =  actualMonth.firstDay
        
        var component = DateComponents()
        component.day = 1 - actualMonthFirstDay
        
        let firstDayDate = SKCalendarAttributes.calendar.nextDate(to: date, byAddingDateComponent: component)
        firstDay = SKCalendarDay(day: firstDayDate)
        
        
        var lastDayComponent = DateComponents()
        lastDayComponent.day = 7 - actualMonth.lastDay
        
        let lastDayDate = SKCalendarAttributes.calendar.nextDate(to: firstDayDate, byAddingDateComponent: lastDayComponent)
        lastDay = SKCalendarDay(day: lastDayDate)
    }
    
    convenience init(minDate: Date, atIndex index: Int) {
        var dateComponent = DateComponents()
        dateComponent.month = index
        
        let date = SKCalendarAttributes.calendar.nextDate(to: minDate, byAddingDateComponent: dateComponent)
        self.init(date: date)
    }
    
    func dayForDayIndex(index: Int) -> SKCalendarDay {
        return  firstDay.dayByAddingNumberOfDay(days: index)
    }
}
