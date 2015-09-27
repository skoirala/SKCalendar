
internal class SKCalendarDayCell: UICollectionViewCell {
    
    internal weak var dayLabel: UILabel!
    
    internal weak var todayIndicator: CAShapeLayer?
    
    class SKCalendarDayCellHighlightedView: UIView {
        lazy private var indicatorLayer: CAShapeLayer = {

            let shapeLayer = CAShapeLayer()

            shapeLayer.fillColor = UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor
            return shapeLayer
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.addSublayer(indicatorLayer)
        }

        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let bezierPath = UIBezierPath(ovalInRect: CGRectInset(bounds, 5, 5))
            indicatorLayer.path = bezierPath.CGPath
            indicatorLayer.position = self.center
            indicatorLayer.bounds = bounds
        }
        
        
    }
    
    func indicatorBounds() -> CGRect {
        return CGRectInset(bounds, 5, 5)
    }
    
    required internal init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isToday: Bool = false {
        didSet {
            if isToday {
                let indicator = createTodayIndicator()
                layer.insertSublayer(indicator, atIndex:0)
                todayIndicator = indicator
            }
        }
    }
    
    func createTodayIndicator() -> CAShapeLayer {
        let bezierPath = UIBezierPath(ovalInRect: indicatorBounds())
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.position = self.center
        shapeLayer.path = bezierPath.CGPath
        shapeLayer.fillColor = UIColor.redColor().CGColor
        return shapeLayer
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setupConstraints()
        
        selectedBackgroundView = SKCalendarDayCellHighlightedView(frame: CGRectZero)
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        todayIndicator?.frame = self.bounds
    }
    
    internal override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        todayIndicator?.frame = self.bounds
    }
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
        todayIndicator?.removeFromSuperlayer()
    }
    
    private func createViews() {
        let dayLabel = UILabel(frame: CGRectZero)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textAlignment = .Center
        dayLabel.textColor = UIColor.whiteColor()
        dayLabel.font = UIFont(name: "AlNile-Bold", size: 24.0)
        contentView.addSubview(dayLabel)
        self.dayLabel = dayLabel
    }
    
    private func setupConstraints() {
        
        let hFormat = "H:|-5-[dayLabel]-5-|"
        let vFormat = "V:|-5-[dayLabel]-5-|"
        let views = ["dayLabel": dayLabel]
        for format in [hFormat, vFormat] {
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
                format,
                options: [],
                metrics: nil,
                views: views)
            )
        }
    }
}
