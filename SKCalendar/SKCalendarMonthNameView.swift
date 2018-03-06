
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
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 22.0)
        
        let previousButton = SKCircularButton()
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.setTitleColor(UIColor.white,
                                     for: .normal)
        previousButton.setTitle("<", for: .normal)
        previousButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        previousButton.addTarget(self,
                                 action: #selector(previousButtonPressed),
                                 for: .touchUpInside)
        
        let nextButton = SKCircularButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitle(">", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        nextButton.addTarget(self,
                             action: #selector(nextButtonPressed),
                             for: .touchUpInside)
        
        
        addSubview(titleLabel)
        addSubview(previousButton)
        addSubview(nextButton)
        
        self.titleLabel = titleLabel
        self.previousButton = previousButton
        self.nextButton = nextButton
    }
    
    private func setupConstraints() {
        let xConstraint = NSLayoutConstraint(item: titleLabel,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerX,
                                             multiplier: 1.0,
                                             constant: 0)
        let yConstraint = NSLayoutConstraint(item: titleLabel,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerY,
                                             multiplier: 1.0,
                                             constant: 0)
        
        let previousButtonCenterY = NSLayoutConstraint(item: previousButton,
                                                       attribute: .centerY,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .centerY,
                                                       multiplier: 1.0,
                                                       constant: 0)
        
        let previousButtonHeightConstraint = NSLayoutConstraint(item: previousButton,
                                                                attribute: .height,
                                                                relatedBy: .equal,
                                                                toItem: self,
                                                                attribute: .height,
                                                                multiplier: 0.75,
                                                                constant: 0)
        
        let previousButtonEqualWidthConstraint = NSLayoutConstraint(item: previousButton,
                                                                    attribute: .height,
                                                                    relatedBy: .equal,
                                                                    toItem: previousButton,
                                                                    attribute: .width,
                                                                    multiplier: 1.0,
                                                                    constant: 0)
        
        let previousButtonXConstraint = NSLayoutConstraint(item: previousButton,
                                                           attribute: .left,
                                                           relatedBy: .equal,
                                                           toItem: self,
                                                           attribute: .left,
                                                           multiplier: 1.0,
                                                           constant: 10)
        
        let nextButtonCenterY = NSLayoutConstraint(item: nextButton,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerY,
                                                   multiplier: 1.0,
                                                   constant: 0)
        
        let nextButtonHeightConstraint = NSLayoutConstraint(item: nextButton,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: self,
                                                            attribute: .height,
                                                            multiplier: 0.75,
                                                            constant: 0)
        
        let nextButtonEqualWidthConstraint = NSLayoutConstraint(item: nextButton,
                                                                attribute: .height,
                                                                relatedBy: .equal,
                                                                toItem: nextButton,
                                                                attribute: .width,
                                                                multiplier: 1.0,
                                                                constant: 0)
        
        let nextButtonXConstraint = NSLayoutConstraint(item: nextButton,
                                                       attribute: .right,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .right,
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
    
    @objc private dynamic func previousButtonPressed(sender: AnyObject) {
        delegate?.monthNameViewDidSelectPrevious(view: self, atSection:sectionIndex)
    }
    
    @objc private dynamic func nextButtonPressed(sender: AnyObject) {
        delegate?.monthNameViewDidSelectNext(view: self, atSection:sectionIndex)
    }
}

