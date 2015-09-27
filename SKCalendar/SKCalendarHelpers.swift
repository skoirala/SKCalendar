

internal struct SKCalendarAttributes {
    
    internal static var calendar: NSCalendar =  {
        let calendar = NSCalendar.currentCalendar()
        calendar.locale = SKCalendarAttributes.locale
        calendar.firstWeekday = 1
        return calendar
    }()
    
    internal static var locale: NSLocale = NSLocale.currentLocale()
    internal static var defaultMonthNameFormatterTemplate: String = "MMMMYYYY"
    internal static var defaultDayNameFormatterTempalte: String = "d"
    
    
    internal static func weekDaysSymbols() -> [String] {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = SKCalendarAttributes.locale
        let symbols = dateFormatter.shortWeekdaySymbols as [String]
        
        return symbols.map({
            symbol in
            let range = Range(start: symbol.startIndex, end: symbol.startIndex.advancedBy(1))
            return symbol.substringWithRange(range)
        })
    }
    
    internal static func formatDayNameFromDate(date: NSDate) -> String {
        let dateFormatter = SKCalendarAttributes.dayNameFormatterWithTemplate(SKCalendarAttributes.defaultDayNameFormatterTempalte)
        return dateFormatter.stringFromDate(date)
    }
    
    internal static func formatMonthNameFromDate(date: NSDate) -> String {
        let dateFormatter = SKCalendarAttributes.monthNameFormatterWithTemplate(SKCalendarAttributes.defaultMonthNameFormatterTemplate)
        return dateFormatter.stringFromDate(date)
    }
    
    internal static func monthNameFormatterWithTemplate(template: String) -> NSDateFormatter {
        let formatterTemplate = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale:SKCalendarAttributes.locale)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formatterTemplate
        
        return dateFormatter
    }
    
    private static func dayNameFormatterWithTemplate(template: String) -> NSDateFormatter {
        let formatterTemplate = NSDateFormatter.dateFormatFromTemplate(template, options: 0, locale:SKCalendarAttributes.locale)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formatterTemplate
        
        return dateFormatter
    }

}
