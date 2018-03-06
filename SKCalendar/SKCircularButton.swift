
internal class SKCircularButton: UIButton {
    
    private var highlightedColor: UIColor = UIColor.white.withAlphaComponent(0.2)
    
    override internal var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required internal init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var circularPath: UIBezierPath {
        get {
            let dimension = min(bounds.width, bounds.height) / 2.0 - strokeWidth
            
            let bezierPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                          radius: dimension,
                                          startAngle: 0,
                                          endAngle: CGFloat.pi * 2.0,
                                          clockwise: true)
            return bezierPath
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.isOpaque = true
        self.backgroundColor = .clear
    }
    
    internal var strokeWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    internal var strokeColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        if let image = self.image(for: .normal) {
            let size = image.size
            let maxDimension = max(size.width, size.height)
            let ratio = (min(contentRect.size.width, contentRect.size.height) - 40) / maxDimension
            
            let width = size.width * ratio
            let height = size.height * ratio
            
            return CGRect (
                x: (contentRect.size.width - width) * 0.5,
                y: (contentRect.size.height - height) * 0.5,
                width: width,
                height: height
            )
            
        }
        return .zero
    }
    
    override func draw(_ rect: CGRect) {
        strokeColor.setStroke()
        
        circularPath.lineWidth = strokeWidth
        
        if self.isHighlighted {
            highlightedColor.setFill()
            circularPath.fill()
        }
        
        circularPath.stroke()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return circularPath.contains(point)
    }
}
