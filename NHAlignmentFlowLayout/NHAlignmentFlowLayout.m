//
//  NHAlignmentFlowLayout.m
//  Hukkster
//
//  Created by Nils Hayat on 7/1/13.
//  Copyright (c) 2013 Hukkster. All rights reserved.
//

#import "NHAlignmentFlowLayout.h"

@implementation NHAlignmentFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (nil == attributes.representedElementKind) {
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return array;
}

-(UIEdgeInsets)nh_insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insetForSection = self.sectionInset;
    id delegate = self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        insetForSection = [(id)delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    
    return insetForSection;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes;
	
	switch (self.alignment) {
		case NHAlignmentTopLeftAligned:
		{
			if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
				attributes = [self layoutAttributesForLeftAlignmentForItemAtIndexPath:indexPath];
			} else {
				attributes = [self layoutAttributesForTopAlignmentForItemAtIndexPath:indexPath];
			}
			break;
		}
		case NHAlignmentBottomRightAligned:
		{
			if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
				attributes = [self layoutAttributesForRightAlignmentForItemAtIndexPath:indexPath];
			} else {
				attributes = [self layoutAttributesForBottomAlignmentForItemAtIndexPath:indexPath];
			}
			break;
		}
		default:
			attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
			break;
	}
	
	return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForLeftAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
	CGRect frame = attributes.frame;
	
    UIEdgeInsets sectionInset = [self nh_insetForSectionAtIndex:indexPath.section];
	if (attributes.frame.origin.x <= sectionInset.left) {
		return attributes;
	}
	
	if (indexPath.item == 0) {
		frame.origin.x = sectionInset.left;
	} else {
		NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
		UICollectionViewLayoutAttributes *previousAttributes = [self layoutAttributesForItemAtIndexPath:previousIndexPath];
		
		if (attributes.frame.origin.y > previousAttributes.frame.origin.y) {
			frame.origin.x = sectionInset.left;
		} else {
			frame.origin.x = CGRectGetMaxX(previousAttributes.frame) + self.minimumInteritemSpacing;
		}
	}
	
	attributes.frame = frame;

	return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForTopAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
	CGRect frame = attributes.frame;
	
    UIEdgeInsets sectionInset = [self nh_insetForSectionAtIndex:indexPath.section];
	if (attributes.frame.origin.y <= sectionInset.top) {
		return attributes;
	}
	
	if (indexPath.item == 0) {
		frame.origin.y = sectionInset.top;
	} else {
		NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
		UICollectionViewLayoutAttributes *previousAttributes = [self layoutAttributesForItemAtIndexPath:previousIndexPath];
		
		if (attributes.frame.origin.x > previousAttributes.frame.origin.x) {
			frame.origin.y = sectionInset.top;
		} else {
			frame.origin.y = CGRectGetMaxY(previousAttributes.frame) + self.minimumInteritemSpacing;
		}
	}
	
	attributes.frame = frame;
	
	return attributes;
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForRightAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
	CGRect frame = attributes.frame;
	
    UIEdgeInsets sectionInset = [self nh_insetForSectionAtIndex:indexPath.section];
	if (CGRectGetMaxX(attributes.frame) >= self.collectionViewContentSize.width - sectionInset.right) {
		return attributes;
	}
	
	if (indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section] - 1) {
		frame.origin.x = self.collectionViewContentSize.width - sectionInset.right - frame.size.width;
	} else {
		
		NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
		UICollectionViewLayoutAttributes *nextAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
		
		if (attributes.frame.origin.y < nextAttributes.frame.origin.y) {
			frame.origin.x = self.collectionViewContentSize.width - sectionInset.right - frame.size.width;
		} else {
			frame.origin.x = nextAttributes.frame.origin.x - self.minimumInteritemSpacing - attributes.frame.size.width;
		}
	}

	attributes.frame = frame;

	return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForBottomAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
	CGRect frame = attributes.frame;
	
    UIEdgeInsets sectionInset = [self nh_insetForSectionAtIndex:indexPath.section];
	if (CGRectGetMaxY(attributes.frame) >= self.collectionViewContentSize.height - sectionInset.left) {
		return attributes;
	}
	
	if (indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section]) {
		frame.origin.y = self.collectionViewContentSize.height - sectionInset.bottom - frame.size.height;
	} else {
		NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
		UICollectionViewLayoutAttributes *nextAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
		
		if (attributes.frame.origin.x < nextAttributes.frame.origin.x) {
			frame.origin.y = self.collectionViewContentSize.height - sectionInset.bottom - frame.size.height;
		} else {
			
			frame.origin.y = nextAttributes.frame.origin.y - self.minimumInteritemSpacing - attributes.frame.size.height;
		}
	}
	
	attributes.frame = frame;

	return attributes;
}

@end
