//
//  NHAlignmentFlowLayout.m
//  Hukkster
//
//  Created by Nils Hayat on 7/1/13.
//  Copyright (c) 2013 Hukkster. All rights reserved.
//

#import "NHAlignmentFlowLayout.h"

@implementation NHAlignmentFlowLayout

-(CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)index
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]){
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:index];
    }
    return self.minimumInteritemSpacing;
}

-(UIEdgeInsets)insetForSectionAtIndex:(NSInteger)index
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]){
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    }
    return self.sectionInset;
}

-(NHAlignment)alignmentForSectionAtIndex:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:alignmentForSectionAtIndex:)]) {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self alignmentForSectionAtIndex:section];
    }
    
    return self.alignment;
}

+(NSArray *)arrayDeepCopy:(NSArray *)array {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (UICollectionViewLayoutAttributes *attributes in array) {
        [mutableArray addObject:[attributes copy]];
    }
    return [mutableArray copy];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [NHAlignmentFlowLayout arrayDeepCopy:[super layoutAttributesForElementsInRect:rect]];
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (nil == attributes.representedElementKind) {
            NSIndexPath* indexPath = attributes.indexPath;
            if ([self.collectionView numberOfItemsInSection:indexPath.section] > 0) {
                attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
            }
        }
    }
    return array;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes;
    
	switch ([self alignmentForSectionAtIndex:indexPath.section]) {
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
	UICollectionViewLayoutAttributes *attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
	CGRect frame = attributes.frame;
	
	if (attributes.frame.origin.x <= [self insetForSectionAtIndex:indexPath.section].left) {
		return attributes;
	}
	
	if (indexPath.item == 0) {
		frame.origin.x = [self insetForSectionAtIndex:indexPath.section].left;
	} else {
		NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
		UICollectionViewLayoutAttributes *previousAttributes = [self layoutAttributesForItemAtIndexPath:previousIndexPath];
		
		if (attributes.frame.origin.y > previousAttributes.frame.origin.y) {
			frame.origin.x = [self insetForSectionAtIndex:indexPath.section].left;
		} else {
			frame.origin.x = CGRectGetMaxX(previousAttributes.frame) + [self minimumInteritemSpacingForSectionAtIndex:indexPath.section];
		}
	}
	
	attributes.frame = frame;
    
	return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForTopAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
	CGRect frame = attributes.frame;
	
	if (attributes.frame.origin.y <= [self insetForSectionAtIndex:indexPath.section].top) {
		return attributes;
	}
	
	if (indexPath.item == 0) {
		frame.origin.y = [self insetForSectionAtIndex:indexPath.section].top;
	} else {
		NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
		UICollectionViewLayoutAttributes *previousAttributes = [self layoutAttributesForItemAtIndexPath:previousIndexPath];
		
		if (attributes.frame.origin.x > previousAttributes.frame.origin.x) {
			frame.origin.y = [self insetForSectionAtIndex:indexPath.section].top;
		} else {
			frame.origin.y = CGRectGetMaxY(previousAttributes.frame) + [self minimumInteritemSpacingForSectionAtIndex:indexPath.section];
		}
	}
	
	attributes.frame = frame;
	
	return attributes;
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForRightAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
	CGRect frame = attributes.frame;
	
	if (CGRectGetMaxX(attributes.frame) >= self.collectionViewContentSize.width - [self insetForSectionAtIndex:indexPath.section].right) {
		return attributes;
	}
	
	if (indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section] - 1) {
		frame.origin.x = self.collectionViewContentSize.width - [self insetForSectionAtIndex:indexPath.section].right - frame.size.width;
	} else {
		
		NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
		UICollectionViewLayoutAttributes *nextAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
		
		if (attributes.frame.origin.y < nextAttributes.frame.origin.y) {
			frame.origin.x = self.collectionViewContentSize.width - [self insetForSectionAtIndex:indexPath.section].right - frame.size.width;
		} else {
			frame.origin.x = nextAttributes.frame.origin.x - [self minimumInteritemSpacingForSectionAtIndex:indexPath.section] - attributes.frame.size.width;
		}
	}
    
	attributes.frame = frame;
    
	return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForBottomAlignmentForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
	CGRect frame = attributes.frame;
	
	if (CGRectGetMaxY(attributes.frame) >= self.collectionViewContentSize.height - [self insetForSectionAtIndex:indexPath.section].left) {
		return attributes;
	}
	
	if (indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section] - 1) {
		frame.origin.y = self.collectionViewContentSize.height - [self insetForSectionAtIndex:indexPath.section].bottom - frame.size.height;
	} else {
		NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
		UICollectionViewLayoutAttributes *nextAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
		
		if (attributes.frame.origin.x < nextAttributes.frame.origin.x) {
			frame.origin.y = self.collectionViewContentSize.height - [self insetForSectionAtIndex:indexPath.section].bottom - frame.size.height;
		} else {
			
			frame.origin.y = nextAttributes.frame.origin.y - [self minimumInteritemSpacingForSectionAtIndex:indexPath.section] - attributes.frame.size.height;
		}
	}
	
	attributes.frame = frame;
    
	return attributes;
}

@end
