
internal class SKCalendarHorizontalFlowLayout: UICollectionViewLayout {
    
    private let numberOfDaysToShow = 7
    private var itemSize: CGSize = CGSizeZero

    
    // MARK: Setters
    
    internal var headerSize: CGSize = CGSizeZero {
        didSet {
            invalidateLayout()
        }
    }
    
    internal var dayNameViewSize: CGSize = CGSizeZero {
        didSet {
            invalidateLayout()
        }
    }
    
    private var headerBottomSpacing: CGFloat = 2 {
        didSet {
            invalidateLayout()
        }
    }
    
    internal var sectionInset: UIEdgeInsets = UIEdgeInsetsZero {
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
    
    override internal func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes    {
        
        let totalHorizontalSpacing = interItemSpacing * CGFloat(numberOfDaysToShow - 1) + sectionInset.left + sectionInset.right
        
        let itemWidth = (self.collectionView!.bounds.size.width - totalHorizontalSpacing) / CGFloat(numberOfDaysToShow)
        itemSize = CGSizeMake(itemWidth, itemWidth)
        
        
        let day = indexPath.row
        let month = indexPath.section
        
        let currentColumn = day % numberOfDaysToShow
        
        let currentRow =  day == 0 ?  0 : day / numberOfDaysToShow
        
        
        let indexPath = NSIndexPath(forRow: day, inSection: month)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        let originX = CGFloat(currentColumn) * (itemSize.width + interItemSpacing) + CGFloat(month) * collectionView!.bounds.size.width + sectionInset.left
        let originY = sectionInset.top + CGFloat(currentRow) * (itemSize.height + lineSpacing) + headerSize.height + headerBottomSpacing + dayNameViewSize.height
        
        let frame = CGRectMake(originX , originY, itemSize.width, itemSize.height)
        attributes.frame = frame
        
        return attributes
    }
    
    override internal func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesInsideRect = [UICollectionViewLayoutAttributes]()
        
        let sectionRange = sectionsInsideRect(rect)
        
        for section in sectionRange.minSection ... sectionRange.maxSection {
            
            for row  in 0 ..< collectionView!.numberOfItemsInSection(section) {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                let cellAttributes = layoutAttributesForItemAtIndexPath(indexPath)
                attributesInsideRect += [cellAttributes]
            }
            
            let supplementaryViewIndexPath = NSIndexPath(forRow: 0, inSection: section)
            let headerAttributes = layoutAttributesForSupplementaryViewOfKind(
                SKCalendarMonthNameViewKind,
                atIndexPath: supplementaryViewIndexPath
            )
            attributesInsideRect += [headerAttributes!]
            
            let dayNameAttributes = layoutAttributesForSupplementaryViewOfKind(
                SKCalendarDayNameViewKind,
                atIndexPath: supplementaryViewIndexPath
            )
            attributesInsideRect += [dayNameAttributes!]
            
        }
        
        return attributesInsideRect
    }
    
    override internal func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        if elementKind == SKCalendarMonthNameViewKind {
    
            return layoutAttributesForMonthNameHeaderViewAtIndexPath(indexPath)
            
        } else if elementKind == SKCalendarDayNameViewKind {
            
            return layoutAttributesForDayNameViewAtIndexPath(indexPath)
            
        }
        return nil
    }
    
    override internal func collectionViewContentSize() -> CGSize {
        
        var maxOffset: CGFloat = 0
        
        let numberOfSection = self.collectionView!.numberOfSections()
        
        
        for section in 0 ..< numberOfSection {
            for row in 0 ..< self.collectionView!.numberOfItemsInSection(section) {
                let _ = row % numberOfDaysToShow
                
                let currentRow =  row == 0 ?  0 : row / numberOfDaysToShow
                
                maxOffset =  max(maxOffset, sectionInset.top + CGFloat(currentRow) * (itemSize.height + lineSpacing) + itemSize.height)
            }
        }
        
        return CGSizeMake (
            max(CGFloat(numberOfSection) * collectionView!.bounds.size.width, collectionView!.bounds.size.width),
            max(collectionView!.bounds.size.height, maxOffset + sectionInset.bottom + headerSize.height + headerBottomSpacing + dayNameViewSize.height)
        )
    }

    override internal func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        if !(CGRectEqualToRect(newBounds, self.collectionView!.bounds)) {
            return true
        }
        return false
    }
    
    // MARK: Private methods
    
    private func sectionsInsideRect(rect: CGRect) -> (minSection: Int, maxSection: Int){
        
        let minX = CGRectGetMinX(rect)
        let maxX = CGRectGetMaxX(rect)
        
        var minSection = Int(minX / collectionView!.bounds.size.width)
        let maxSection = Int(maxX / collectionView!.bounds.size.width)
        
        minSection = max(minSection, 0)
        
        return (minSection, maxSection)
    }
    
    private func layoutAttributesForMonthNameHeaderViewAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes (
            forSupplementaryViewOfKind: SKCalendarMonthNameViewKind,
            withIndexPath: indexPath
        )
        var frame = CGRectZero
        frame.origin.y = sectionInset.top
        frame.origin.x = sectionInset.left + CGFloat(indexPath.section) * collectionView!.bounds.size.width
        frame.size.width = collectionView!.bounds.size.width - sectionInset.left - sectionInset.right
        frame.size.height = headerSize.height
        attributes.frame = frame
        return attributes
    }
    
    private func layoutAttributesForDayNameViewAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes{
        let attributes = UICollectionViewLayoutAttributes (
            forSupplementaryViewOfKind: SKCalendarDayNameViewKind,
            withIndexPath: indexPath
            )
        var frame = CGRectZero
        frame.origin.y = sectionInset.top + headerSize.height
        frame.origin.x = sectionInset.left + CGFloat(indexPath.section) * collectionView!.bounds.size.width
        frame.size.width = collectionView!.bounds.size.width - sectionInset.left - sectionInset.right
        frame.size.height = dayNameViewSize.height
        attributes.frame = frame
        return attributes
    }
}

