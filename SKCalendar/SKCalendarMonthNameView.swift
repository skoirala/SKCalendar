
let SKCalendarMonthNameViewKind = "SKCalendarMonthNameViewKind"

@objc
protocol SKCalendarMonthNameViewDelegate {
    func monthNameViewDidSelectPrevious(view: SKCalendarMonthNameView!, atSection section: Int)
    func monthNameViewDidSelectNext(view: SKCalendarMonthNameView!, atSection section: Int)
}

internal class SKCalendarMonthNameView: UICollectionReusableView {
    
    
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }

    private weak var titleLabel: UILabel!
    private weak var previousButton: SKCircularButton!
    private weak var nextButton: SKCircularButton!
    weak var delegate: SKCalendarMonthNameViewDelegate!
    var sectionIndex: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setupConstraints()
    }
    
    required internal init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        let titleLabel = UILabel(frame: CGRectZero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 22.0)
        
        let previousButton = SKCircularButton()
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        previousButton.setTitle("<", forState: .Normal)
        previousButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        previousButton.addTarget(self,
            action: "previousButtonPressed:",
            forControlEvents: .TouchUpInside)
        
        let nextButton = SKCircularButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        nextButton.setTitle(">", forState: .Normal)
        nextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        nextButton.addTarget(self,
                action: "nextButtonPressed:",
                forControlEvents: .TouchUpInside)

        
        addSubview(titleLabel)
        addSubview(previousButton)
        addSubview(nextButton)
        
        self.titleLabel = titleLabel
        self.previousButton = previousButton
        self.nextButton = nextButton
    }
    
    private func setupConstraints() {
        let xConstraint = NSLayoutConstraint(item: titleLabel,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0)
        let yConstraint = NSLayoutConstraint(item: titleLabel,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0)
        
        let previousButtonCenterY = NSLayoutConstraint(item: previousButton,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0)
        
        let previousButtonHeightConstraint = NSLayoutConstraint(item: previousButton,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Height,
            multiplier: 0.75,
            constant: 0)
        
        let previousButtonEqualWidthConstraint = NSLayoutConstraint(item: previousButton,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: previousButton,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0)
        
        let previousButtonXConstraint = NSLayoutConstraint(item: previousButton,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Left,
            multiplier: 1.0,
            constant: 10)
        
        let nextButtonCenterY = NSLayoutConstraint(item: nextButton,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0)
        
        let nextButtonHeightConstraint = NSLayoutConstraint(item: nextButton,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Height,
            multiplier: 0.75,
            constant: 0)
        
        let nextButtonEqualWidthConstraint = NSLayoutConstraint(item: nextButton,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nextButton,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0)
        
        let nextButtonXConstraint = NSLayoutConstraint(item: nextButton,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Right,
            multiplier: 1.0,
            constant: -10)
        
        
        addConstraints(
            [
                xConstraint,
                yConstraint,
                previousButtonCenterY,
                previousButtonHeightConstraint,
                previousButtonEqualWidthConstraint,
                previousButtonXConstraint,
                nextButtonCenterY,
                nextButtonHeightConstraint,
                nextButtonEqualWidthConstraint,
                nextButtonXConstraint,
            ]
        )
    }
    
    private dynamic func previousButtonPressed(sender: AnyObject) {
        delegate?.monthNameViewDidSelectPrevious(self, atSection:sectionIndex)
    }
    
    private dynamic func nextButtonPressed(sender: AnyObject) {
        delegate?.monthNameViewDidSelectNext(self, atSection:sectionIndex)
    }
}
