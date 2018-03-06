
internal class SKCalendarHorizontalFlowLayout: UICollectionViewLayout {
    
    private let numberOfDaysToShow = 7
    private var itemSize: CGSize = .zero

    
    // MARK: Setters
    
    internal var headerSize: CGSize = .zero {
        didSet {
            invalidateLayout()
        }
    }
    
    internal var dayNameViewSize: CGSize = .zero {
        didSet {
            invalidateLayout()
        }
    }
    
    private var headerBottomSpacing: CGFloat = 2 {
        didSet {
            invalidateLayout()
        }
    }
    
    internal var sectionInset: UIEdgeInsets = .zero {
        didSet {
            invalidateLayout()
        }
    }
    
    internal var interItemSpacing: CGFloat = 2 {
        didSet {
            invalidateLayout()
        }
    }
    
    internal var lineSpacing: CGFloat = 2 {
        didSet {
            invalidateLayout()
        }
    }
    
    // MARK: Layout
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let totalHorizontalSpacing = interItemSpacing * CGFloat(numberOfDaysToShow - 1) + sectionInset.left + sectionInset.right
        
        let itemWidth = (self.collectionView!.bounds.size.width - totalHorizontalSpacing) / CGFloat(numberOfDaysToShow)
        itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        
        let day = indexPath.row
        let month = indexPath.section
        
        let currentColumn = day % numberOfDaysToShow
        
        let currentRow =  day == 0 ?  0 : day / numberOfDaysToShow
        
        
        let indexPath = IndexPath(item: day, section: month)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let originX = CGFloat(currentColumn) * (itemSize.width + interItemSpacing) + CGFloat(month) * collectionView!.bounds.size.width + sectionInset.left
        let originY = sectionInset.top + CGFloat(currentRow) * (itemSize.height + lineSpacing) + headerSize.height + headerBottomSpacing + dayNameViewSize.height
        
        let frame = CGRect(origin: CGPoint(x: originX, y: originY),
                           size: itemSize)
        attributes.frame = frame
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesInsideRect = [UICollectionViewLayoutAttributes]()
        
        let sectionRange = sectionsInsideRect(rect: rect)
        
        for section in sectionRange.minSection ... sectionRange.maxSection {
            
            for row  in 0 ..< collectionView!.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: row, section: section)
                let cellAttributes = layoutAttributesForItem(at: indexPath)!
                attributesInsideRect += [cellAttributes]
            }
            
            let supplementaryViewIndexPath = IndexPath(item: 0, section: section)
            let headerAttributes = layoutAttributesForSupplementaryView(
                ofKind: SKCalendarMonthNameViewKind,
                at: supplementaryViewIndexPath
            )
            attributesInsideRect += [headerAttributes!]
            
            let dayNameAttributes = layoutAttributesForSupplementaryView(
                ofKind: SKCalendarDayNameViewKind,
                at: supplementaryViewIndexPath
            )
            attributesInsideRect += [dayNameAttributes!]
            
        }
        
        return attributesInsideRect
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == SKCalendarMonthNameViewKind {
    
            return layoutAttributesForMonthNameHeaderViewAtIndexPath(indexPath: indexPath)
            
        } else if elementKind == SKCalendarDayNameViewKind {
            
            return layoutAttributesForDayNameViewAtIndexPath(indexPath: indexPath)
            
        }
        return nil
    }
    
    override var collectionViewContentSize: CGSize {
        
        var maxOffset: CGFloat = 0
        
        let numberOfSection = self.collectionView!.numberOfSections
        
        
        for section in 0 ..< numberOfSection {
            for row in 0 ..< self.collectionView!.numberOfItems(inSection: section) {
                let _ = row % numberOfDaysToShow
                
                let currentRow =  row == 0 ?  0 : row / numberOfDaysToShow
                
                maxOffset =  max(maxOffset, sectionInset.top + CGFloat(currentRow) * (itemSize.height + lineSpacing) + itemSize.height)
            }
        }
        
        return CGSize(
            width: max(CGFloat(numberOfSection) * collectionView!.bounds.size.width, collectionView!.bounds.size.width),
            height: max(collectionView!.bounds.size.height, maxOffset + sectionInset.bottom + headerSize.height + headerBottomSpacing + dayNameViewSize.height)
        )
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if !newBounds.equalTo(collectionView!.bounds) {
            return true
        }
        return false
    }
    
    // MARK: Private methods
    
    private func sectionsInsideRect(rect: CGRect) -> (minSection: Int, maxSection: Int){
        
        let minX = rect.minX
        let maxX = rect.maxX
        
        var minSection = Int(minX / collectionView!.bounds.size.width)
        let maxSection = Int(maxX / collectionView!.bounds.size.width)
        
        minSection = max(minSection, 0)
        
        return (minSection, maxSection)
    }
    
    private func layoutAttributesForMonthNameHeaderViewAtIndexPath(indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: SKCalendarMonthNameViewKind,
                                         with: indexPath)
        
        var frame: CGRect = .zero
        frame.origin.y = sectionInset.top
        frame.origin.x = sectionInset.left + CGFloat(indexPath.section) * collectionView!.bounds.size.width
        frame.size.width = collectionView!.bounds.size.width - sectionInset.left - sectionInset.right
        frame.size.height = headerSize.height
        attributes.frame = frame
        return attributes
    }
    
    private func layoutAttributesForDayNameViewAtIndexPath(indexPath: IndexPath) -> UICollectionViewLayoutAttributes{
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: SKCalendarDayNameViewKind,
                                                          with: indexPath)

        var frame: CGRect = .zero
        frame.origin.y = sectionInset.top + headerSize.height
        frame.origin.x = sectionInset.left + CGFloat(indexPath.section) * collectionView!.bounds.size.width
        frame.size.width = collectionView!.bounds.size.width - sectionInset.left - sectionInset.right
        frame.size.height = dayNameViewSize.height
        attributes.frame = frame
        return attributes
    }
}

