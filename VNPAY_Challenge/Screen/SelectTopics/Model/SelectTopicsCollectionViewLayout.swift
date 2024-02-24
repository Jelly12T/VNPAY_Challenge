//
//  SelectTopicsCollectionViewLayout.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit
protocol SelectTopicsCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView, heightForHeaderInSection section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, itemSpacingInSection section: Int) -> CGFloat
}

class SelectTopicsCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: SelectTopicsCollectionViewLayoutDelegate?
    private var attributesListItem: [UICollectionViewLayoutAttributes] = []
    private var contentWidth: CGFloat = 0
    private var contentHeight: CGFloat = 0

    override func prepare() {
        super.prepare()

        let numberOfItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        self.attributesListItem = []

        for index in 1 ... numberOfItems {
            let indexPath = IndexPath(item: index - 1, section: 0)
            let attributeCell = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let heightForHeaderInSection = self.delegate?.collectionView(self.collectionView!, heightForHeaderInSection: 0) ?? 0
            let itemSpacingInSection = self.delegate?.collectionView(self.collectionView!, itemSpacingInSection: 0) ?? 0
            guard let cellSize = self.delegate?.collectionView(self.collectionView!, sizeForItemAt: indexPath) else {
                return
            }

            if currentX + cellSize.width >= self.collectionView?.bounds.size.width ?? 0 {
                currentX = 0
                currentY += cellSize.height + heightForHeaderInSection
            }

            attributeCell.frame = CGRect(x: currentX, y: currentY, width: cellSize.width, height: cellSize.height)
            self.contentWidth = max(self.contentWidth, attributeCell.frame.maxX)
            self.contentHeight = max(self.contentHeight, attributeCell.frame.maxY)
            currentX += cellSize.width + itemSpacingInSection
            self.attributesListItem.append(attributeCell)
        }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.contentWidth, height: self.contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributesListItem
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.attributesListItem[indexPath.row]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

