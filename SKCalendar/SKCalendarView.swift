
public protocol SKCalendarViewDelegate: NSObjectProtocol {
    func calendarView(calendarView: SKCalendarView!, didSelectDate date: NSDateComponents!)
}

public class SKCalendarView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, SKCalendarMonthNameViewDelegate {

    private let minimumDate: NSDate
    private let maximumDate: NSDate
    
    private let cellIdentifier = "CellIdentifier"
    
    private let headerIdentifier = "HeaderIdentifier"
    
    private let dayNameViewIdentifier = "DayNameViewIdentifier"
    
    
    weak private var collectionView: UICollectionView!
    weak private var collectionViewLayout: SKCalendarHorizontalFlowLayout!
    
    weak private var delegate: SKCalendarViewDelegate!
    
    weak private var selectedDay: SKCalendarDay?
    
    public init(delegate: SKCalendarViewDelegate) {
        self.delegate = delegate
        
        let minimumDateComponent = NSDateComponents()
        minimumDateComponent.day = 1
        minimumDateComponent.year = 2008
        minimumDateComponent.month = 1
        
        let maximumDateComponent = NSDateComponents()
        maximumDateComponent.day = 30
        maximumDateComponent.year = 2199
        maximumDateComponent.month = 12
        
        minimumDate = SKCalendarAttributes.calendar.dateFromComponents(minimumDateComponent)!
        maximumDate = SKCalendarAttributes.calendar.dateFromComponents(maximumDateComponent)!

        
        super.init(frame: CGRectZero)
        createViews()
        setupConstraints()
        
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        
        let collectionViewLayout = SKCalendarHorizontalFlowLayout()
        let collectionView = UICollectionView (
            frame: CGRectZero,
            collectionViewLayout: collectionViewLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionViewLayout.interItemSpacing = 0
        collectionViewLayout.lineSpacing = 0
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.alwaysBounceVertical = false
        
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.registerClass(
            SKCalendarDayCell.self,
            forCellWithReuseIdentifier: cellIdentifier
        )
        collectionView.registerClass(
            SKCalendarMonthNameView.self,
            forSupplementaryViewOfKind: SKCalendarMonthNameViewKind,
            withReuseIdentifier: headerIdentifier)
        collectionView.registerClass(SKCalendarDayNameView.self,
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
            "collectionView": collectionView
        ]
        let hFormat = "H:|[collectionView]|"
        let vFormat = "V:|[collectionView]|"
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat (
            hFormat,
            options: [],
            metrics: nil,
            views: views
        )
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat (
            vFormat,
            options: [],
            metrics: nil,
            views: views
        )
        
        addConstraints(horizontalConstraints)
        addConstraints(verticalConstraints)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let numberOfDaysToShow = 7
        
        let width = self.bounds.size.width / CGFloat(numberOfDaysToShow)
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20)
        collectionViewLayout.headerSize = CGSize(width: width, height: 40)
        collectionViewLayout.dayNameViewSize = CGSizeMake(320, 30)
        
        scrollToSection(todayMonthIndex())
        }
    
    // Mark: UICollectionViewDataSource
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return SKCalendarAttributes.calendar.numberOfMonthsBetweenDates(minimumDate, toDate: maximumDate)
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let month = SKPresentableMonth(minDate: minimumDate, atIndex: section)
        return month.totalDays
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! SKCalendarDayCell
        let month = SKPresentableMonth(minDate: minimumDate, atIndex: indexPath.section)
        let calendarDay = month.dayForDayIndex(indexPath.row)
        cell.dayLabel.text = calendarDay.formattedDay()
        
        if calendarDay.dateComponents.month != month.actualMonth.dateComponent.month {
            cell.dayLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
        } else {
            cell.dayLabel.textColor = UIColor.whiteColor()
        }
        
        if indexPath.compare(todayDayIndex()) == NSComparisonResult.OrderedSame{
            cell.isToday = true
        }
        
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == SKCalendarMonthNameViewKind {
            return monthNameViewAtIndexPath(indexPath)
        }
        let dayNameView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: dayNameViewIdentifier,
            forIndexPath: indexPath) as! SKCalendarDayNameView
        return dayNameView
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let currentMonth = SKPresentableMonth(minDate: minimumDate, atIndex: indexPath.section)
        let calendarDay = currentMonth.dayForDayIndex(indexPath.row)
        

        // selected month is dimmed and is previous month
        if calendarDay.dateComponents.month < currentMonth.actualMonth.dateComponent.month {
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: indexPath.section - 1), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
            return
            
            // selected month is dimmed and is next month
        } else if calendarDay.dateComponents.month > currentMonth.actualMonth.dateComponent.month {
             collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: indexPath.section + 1), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
            return
        }
        
        selectedDay = calendarDay
        delegate?.calendarView(self, didSelectDate: calendarDay.dateComponents)
        
    }
    
    
    // MARK: SKMonthNameViewDelegate
    
    internal func monthNameViewDidSelectPrevious(view: SKCalendarMonthNameView!, atSection section: Int) {
        let newSection = section - 1
        if newSection > 0 {
            scrollToSection(newSection)
        }
    }
    
    internal func monthNameViewDidSelectNext(view: SKCalendarMonthNameView!, atSection section: Int) {
        
        let newSection = section + 1
        
        if newSection < numberOfSectionsInCollectionView(collectionView) {
           scrollToSection(newSection)
        }
    }
    
    private func scrollToSection(section: Int) {
        assert(section < numberOfSectionsInCollectionView(collectionView), "Section cannot be greater than number of sections")
        let contentOffset = CGPoint(x: CGFloat(section) * collectionView.bounds.size.width, y: 0)
        collectionView.setContentOffset(contentOffset, animated: true)
    }
    
    private func todayMonthIndex() -> Int {
        let today = NSDate()
        let month = SKCalendarAttributes.calendar.numberOfMonthsBetweenDates(minimumDate, toDate: today)
        return month
    }
    
    private func todayDayIndex() -> NSIndexPath {
        let month = SKPresentableMonth(minDate: minimumDate, atIndex: todayMonthIndex())
        let dateComponent = SKCalendarAttributes.calendar.defaultComponentsFromDate(NSDate())
        let calendarDay = month.actualMonth.firstDay - 2 + dateComponent.day
        return NSIndexPath(forItem: calendarDay, inSection: todayMonthIndex())
    }
    
    private func monthNameViewAtIndexPath(indexPath: NSIndexPath) -> UICollectionReusableView {
        let month = SKPresentableMonth(minDate: minimumDate, atIndex: indexPath.section)
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind (
            SKCalendarMonthNameViewKind, withReuseIdentifier: headerIdentifier,
            forIndexPath: indexPath) as! SKCalendarMonthNameView
        headerView.title = SKCalendarAttributes.formatMonthNameFromDate(SKCalendarAttributes.calendar.dateFromComponents(month.actualMonth.dateComponent)!)
        headerView.delegate = self
        headerView.sectionIndex = indexPath.section
        
        return headerView
    }
}
