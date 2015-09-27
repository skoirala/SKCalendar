

let SKCalendarDayNameViewKind = "SKCalendarDayNameViewKind"

internal class SKCalendarDayNameView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }
    
    required internal init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        let day1 = SKCalendarDayNameContainerView(frame: CGRectZero)
        let day2 = SKCalendarDayNameContainerView(frame: CGRectZero)
        let day3 = SKCalendarDayNameContainerView(frame: CGRectZero)
        let day4 = SKCalendarDayNameContainerView(frame: CGRectZero)
        let day5 = SKCalendarDayNameContainerView(frame: CGRectZero)
        let day6 = SKCalendarDayNameContainerView(frame: CGRectZero)
        let day7 = SKCalendarDayNameContainerView(frame: CGRectZero)
        
        let weekDays = SKCalendarAttributes.weekDaysSymbols().map({
            string in
            return string.capitalizedString
        })
        
        day1.title = weekDays[0]
        day2.title = weekDays[1]
        day3.title = weekDays[2]
        day4.title = weekDays[3]
        day5.title = weekDays[4]
        day6.title = weekDays[5]
        day7.title = weekDays[6]
        
        addSubview(day1)
        addSubview(day2)
        addSubview(day3)
        addSubview(day4)
        addSubview(day5)
        addSubview(day6)
        addSubview(day7)
        
        let views = [
            "day1": day1,
            "day2": day2,
            "day3": day3,
            "day4": day4,
            "day5": day5,
            "day6": day6,
            "day7": day7
        ]
        
        let hFormat = "H:|[day1][day2(==day1)][day3(==day1)][day4(==day1)][day5(==day1)][day6(==day1)][day7(==day1)]|"
        let vFormat = "V:|[day1]|"
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat(hFormat, options:[.AlignAllBottom, .AlignAllTop], metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(vFormat, options: [], metrics: nil, views: views)
        
        addConstraints(hConstraints)
        addConstraints(vConstraints)
    }
    
    private class SKCalendarDayNameContainerView: UIView {
        
        private weak var titleLabel: UILabel!
        
        private var title: String? {
            set {
                titleLabel.text = newValue
            }
            get {
                return titleLabel.text
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            createViews()
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func createViews() {
            let titleLabel = UILabel(frame: CGRectZero)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.textColor = UIColor.blackColor()
            titleLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
            addSubview(titleLabel)
            
            self.titleLabel = titleLabel
            
            let centerXConstraint = NSLayoutConstraint(item: titleLabel,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterX,
                multiplier: 1.0,
                constant: 0)
            
            let yConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[titleLabel]|", options: [], metrics: nil, views: ["titleLabel": titleLabel])
            
            addConstraint(centerXConstraint)
            addConstraints(yConstraints)
        }
    }
}

