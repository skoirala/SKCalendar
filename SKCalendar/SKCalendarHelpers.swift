

internal struct SKCalendarAttributes {
    
    internal static var calendar: Calendar =  {
        var calendar = Calendar.current
        calendar.locale = SKCalendarAttributes.locale
        calendar.firstWeekday = 1
        return calendar
    }()
    
    internal static var locale: Locale = Locale.current
    internal static var defaultMonthNameFormatterTemplate: String = "MMMMYYYY"
    internal static var defaultDayNameFormatterTempalte: String = "d"
    
    
    internal static func weekDaysSymbols() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = SKCalendarAttributes.locale
        let symbols = dateFormatter.shortWeekdaySymbols as [String]
        
        return symbols.map({
            symbol in
            let range = symbol.startIndex ..< symbol.index(symbol.startIndex,
                                                           offsetBy: 1)
            
            return String(symbol[range])
        })
    }
    
    internal static func formatDayNameFromDate(date: Date) -> String {
        let dateFormatter = SKCalendarAttributes.dayNameFormatterWithTemplate(template: SKCalendarAttributes.defaultDayNameFormatterTempalte)
        return dateFormatter.string(from:date)
    }
    
    internal static func formatMonthNameFromDate(date: Date) -> String {
        let dateFormatter = SKCalendarAttributes.monthNameFormatterWithTemplate(template: SKCalendarAttributes.defaultMonthNameFormatterTemplate)
        return dateFormatter.string(from:date)
    }
    
    internal static func monthNameFormatterWithTemplate(template: String) -> DateFormatter {
        let formatterTemplate = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale:SKCalendarAttributes.locale)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatterTemplate
        
        return dateFormatter
    }
    
    private static func dayNameFormatterWithTemplate(template: String) -> DateFormatter {
        let formatterTemplate = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale:SKCalendarAttributes.locale)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatterTemplate
        
        return dateFormatter
    }
}
