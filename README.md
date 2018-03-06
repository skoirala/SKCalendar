# SKCalendar

Simple iOS calendar with Custom collection view layout. 

Fast and easy to customize


![alt text](https://raw.githubusercontent.com/skoirala/SKCalendar/master/Calendar.png "With zero configuration")


# Usage 

```swift 

        let calendarView = SKCalendarView(delegate: self)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            calendarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
```

*SKCalendarViewDelegate* has single method for detecting date selection

```
    func calendarView(calendarView: SKCalendarView!, didSelectDate date: DateComponents) 
```


## More to come


