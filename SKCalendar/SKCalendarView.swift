
public protocol SKCalendarViewDelegate: NSObjectProtocol {
    func calendarView(calendarView: SKCalendarView!, didSelectDate date: DateComponents)
}

public class SKCalendarView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, SKCalendarMonthNameViewDelegate {

    private let minimumDate: Date
    private let maximumDate: Date
    
    private let cellIdentifier = "CellIdentifier"
    
    private let headerIdentifier = "HeaderIdentifier"
    
    private let dayNameViewIdentifier = "DayNameViewIdentifier"
    
    
    weak private var collectionView: UICollectionView!
    weak private var collectionViewLayout: SKCalendarHorizontalFlowLayout!
    
    weak private var delegate: SKCalendarViewDelegate!
    
    weak private var selectedDay: SKCalendarDay?
    
    public init(delegate: SKCalendarViewDelegate) {
        self.delegate = delegate
        
        var minimumDateComponent = DateComponents()
        minimumDateComponent.day = 1
        minimumDateComponent.year = 2008
        minimumDateComponent.month = 1
        
        var maximumDateComponent = DateComponents()
        maximumDateComponent.day = 30
        maximumDateComponent.year = 2199
        maximumDateComponent.month = 12
        
        minimumDate = SKCalendarAttributes.calendar.date(from: minimumDateComponent)!
        maximumDate = SKCalendarAttributes.calendar.date(from:maximumDateComponent)!

        
        super.init(frame: .zero)
        createViews()
        setupConstraints()
        
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        
        let collectionViewLayout = SKCalendarHorizontalFlowLayout()
        let collectionView = UICollectionView (
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionViewLayout.interItemSpacing = 0
        collectionViewLayout.lineSpacing = 0
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(SKCalendarDayCell.self,
                                forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.register(SKCalendarMonthNameView.self,
                                forSupplementaryViewOfKind: SKCalendarMonthNameViewKind,
                                withReuseIdentifier: headerIdentifier)
        collectionView.register(SKCalendarDayNameView.self,
                                forSupplementaryViewOfKind: SKCalendarDayNameViewKind,
                                withReuseIdentifier: dayNameViewIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        
        self.collectionView = collectionView
        self.collectionViewLayout = collectionViewLayout
    }
    
    
    private func setupConstraints() {
        let views = [
            "collectionView": collectionView!
        ] as [String: Any]
        
        let hFormat = "H:|[collectionView]|"
        let vFormat = "V:|[collectionView]|"
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat,
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: views)
            
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat,
                                                                 options: [],
                                                                 metrics: nil,
                                                                 views: views)
        
        
        addConstraints(horizontalConstraints)
        addConstraints(verticalConstraints)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let numberOfDaysToShow = 7
        
        let width = self.bounds.size.width / CGFloat(numberOfDaysToShow)
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20)
        collectionViewLayout.headerSize = CGSize(width: width, height: 40)
        collectionViewLayout.dayNameViewSize = CGSize(width: 320, height: 30)
        scrollToSection(section: todayMonthIndex())
        }
    
    // Mark: UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SKCalendarAttributes.calendar.numberOfMonthsBetweenDates(fromDate: minimumDate,
                                                                        toDate: maximumDate)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let month = SKPresentableMonth(minDate: minimumDate, atIndex: section)
        return month.totalDays
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! SKCalendarDayCell
        let month = SKPresentableMonth(minDate: minimumDate, atIndex: indexPath.section)
        let calendarDay = month.dayForDayIndex(index: indexPath.row)
        cell.dayLabel.text = calendarDay.formattedDay()
        
        if calendarDay.dateComponents.month != month.actualMonth.dateComponent.month {
            cell.dayLabel.textColor = UIColor.white.withAlphaComponent(0.4)
        } else {
            cell.dayLabel.textColor = UIColor.white
        }
        
        if indexPath.compare(todayDayIndex()) == .orderedSame {
            cell.isToday = true
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == SKCalendarMonthNameViewKind {
            return monthNameViewAtIndexPath(indexPath: indexPath)
        }
        let dayNameView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                          withReuseIdentifier: dayNameViewIdentifier,
                                                                          for: indexPath) as! SKCalendarDayNameView
        return dayNameView
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentMonth = SKPresentableMonth(minDate: minimumDate, atIndex: indexPath.section)
        let calendarDay = currentMonth.dayForDayIndex(index: indexPath.row)
        

        // selected month is dimmed and is previous month
        if calendarDay.dateComponents.month! < currentMonth.actualMonth.dateComponent.month! {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: indexPath.section - 1),
                                        at: .left,
                                        animated: true)
            collectionView.deselectItem(at: indexPath, animated: true)
            return
            
            // selected month is dimmed and is next month
        } else if calendarDay.dateComponents.month! > currentMonth.actualMonth.dateComponent.month! {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: indexPath.section + 1),
                                        at: .left,
                                        animated: true)
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        selectedDay = calendarDay
        delegate.calendarView(calendarView: self,
                              didSelectDate: calendarDay.dateComponents)
    }
    
    
    // MARK: SKMonthNameViewDelegate
    
    internal func monthNameViewDidSelectPrevious(view: SKCalendarMonthNameView!, atSection section: Int) {
        let newSection = section - 1
        if newSection > 0 {
            scrollToSection(section: newSection)
        }
    }
    
    internal func monthNameViewDidSelectNext(view: SKCalendarMonthNameView!, atSection section: Int) {
        
        let newSection = section + 1
        
        if newSection < numberOfSections(in: collectionView) {
           scrollToSection(section: newSection)
        }
    }
    
    private func scrollToSection(section: Int) {
        assert(section < numberOfSections(in: collectionView), "Section cannot be greater than number of sections")
        let contentOffset = CGPoint(x: CGFloat(section) * collectionView.bounds.size.width, y: 0)
        collectionView.setContentOffset(contentOffset, animated: true)
    }
    
    private func todayMonthIndex() -> Int {
        let today = Date()
        let month = SKCalendarAttributes.calendar.numberOfMonthsBetweenDates(fromDate: minimumDate,
                                                                             toDate: today)
        return month
    }
    
    private func todayDayIndex() -> IndexPath {
        let month = SKPresentableMonth(minDate: minimumDate, atIndex: todayMonthIndex())
        let dateComponent = SKCalendarAttributes.calendar.defaultComponentsFromDate(date: Date())
        let calendarDay = month.actualMonth.firstDay - 2 + dateComponent.day!
        return IndexPath(item: calendarDay, section: todayMonthIndex())
    }
    
    private func monthNameViewAtIndexPath(indexPath: IndexPath) -> UICollectionReusableView {
        let month = SKPresentableMonth(minDate: minimumDate, atIndex: indexPath.section)
        
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SKCalendarMonthNameViewKind,
                                                                         withReuseIdentifier: headerIdentifier,
                                                                         for: indexPath) as! SKCalendarMonthNameView
        let date = SKCalendarAttributes.calendar.date(from: month.actualMonth.dateComponent)
        headerView.title = SKCalendarAttributes.formatMonthNameFromDate(date: date!)
        headerView.delegate = self
        headerView.sectionIndex = indexPath.section
        
        return headerView
    }
}
