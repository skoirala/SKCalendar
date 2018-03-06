
internal class SKCalendarDayCell: UICollectionViewCell {
    
    internal weak var dayLabel: UILabel!
    
    internal weak var todayIndicator: CAShapeLayer?
    
    class SKCalendarDayCellHighlightedView: UIView {
        lazy private var indicatorLayer: CAShapeLayer = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.rasterizationScale = UIScreen.main.scale
            shapeLayer.shouldRasterize = true
            shapeLayer.fillColor = UIColor.white.withAlphaComponent(0.2).cgColor
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
            let bezierPath = UIBezierPath(ovalIn: bounds.insetBy(dx: 5, dy: 5))
            indicatorLayer.path = bezierPath.cgPath
            indicatorLayer.position = self.center
            indicatorLayer.bounds = bounds
        }
    }
    
    func indicatorBounds() -> CGRect {
        return bounds.insetBy(dx: 5, dy: 5)
    }
    
    required internal init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isToday: Bool = false {
        didSet {
            if isToday {
                let indicator = createTodayIndicator()
                layer.insertSublayer(indicator, at: 0)
                todayIndicator = indicator
            }
        }
    }
    
    func createTodayIndicator() -> CAShapeLayer {
        let bezierPath = UIBezierPath(ovalIn: indicatorBounds())
        let shapeLayer = CAShapeLayer()
        shapeLayer.rasterizationScale = UIScreen.main.scale
        shapeLayer.bounds = self.bounds
        shapeLayer.position = self.center
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        return shapeLayer
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setupConstraints()
        
        selectedBackgroundView = SKCalendarDayCellHighlightedView(frame: .zero)
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        todayIndicator?.frame = self.bounds
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        todayIndicator?.frame = self.bounds
    }
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
        todayIndicator?.removeFromSuperlayer()
    }
    
    private func createViews() {
        let dayLabel = UILabel(frame: .zero)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textAlignment = .center
        dayLabel.textColor = UIColor.white
        dayLabel.font = UIFont(name: "AlNile-Bold", size: 24.0)
        contentView.addSubview(dayLabel)
        self.dayLabel = dayLabel
    }
    
    private func setupConstraints() {
        
        let hFormat = "H:|-5-[dayLabel]-5-|"
        let vFormat = "V:|-5-[dayLabel]-5-|"
        let views = ["dayLabel": dayLabel] as [String: Any]
        for format in [hFormat, vFormat] {
            let constraints = NSLayoutConstraint.constraints(withVisualFormat:format,
                                                             options: [],
                                                             metrics: nil,
                                                             views: views)
            contentView.addConstraints(constraints)
        }
    }
}
