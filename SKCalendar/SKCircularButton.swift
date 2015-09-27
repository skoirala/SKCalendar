
internal class SKCircularButton: UIButton {
    
    private var highlightedColor: UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
    
    override internal var highlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required internal init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var circularPath: UIBezierPath {
        get {
            let dimension = min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 2.0 - strokeWidth
            
            let bezierPath = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds)), radius: dimension, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
            return bezierPath
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        self.opaque = true
        self.backgroundColor = UIColor.clearColor()
    }
    
    internal var strokeWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    internal var strokeColor: UIColor = UIColor.whiteColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override internal func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        if let image = self.imageForState(.Normal) {
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
        return CGRectZero
    }
    
    override internal func drawRect(rect: CGRect) {
        
        strokeColor.setStroke()
        
        circularPath.lineWidth = strokeWidth
        
        if self.highlighted {
            highlightedColor.setFill()
            circularPath.fill()
        }
        
        circularPath.stroke()
    }
    
    override internal func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return circularPath.containsPoint(point)
    }
}
