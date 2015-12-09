//
//  StickyHeaderFlowLayout.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/8/15.
//  Copyright © 2015 Calios. All rights reserved.
//
/**
 *   From https://gist.github.com/vigorouscoding/5155703
 */

#import "StickyHeaderFlowLayout.h"

@implementation StickyHeaderFlowLayout

-(id)init {
    self = [super init];
    
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.headerReferenceSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 50);
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSMutableArray* attributesArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
//    
//    BOOL headerVisible = NO;
//    
//    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
//        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
//            headerVisible = YES;
//            attributes.frame = CGRectMake(self.collectionView.contentOffset.x, 0, self.headerReferenceSize.width, self.headerReferenceSize.height);
//            attributes.alpha = 1;
//            attributes.zIndex = 2;
//        }
//    }
//    
//    if (!headerVisible) {
//        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                                                                            atIndexPath:[NSIndexPath
//                                                                                                         indexPathForItem:0
//                                                                                                         inSection:0]];
//        [attributesArray addObject:attributes];
//    }
//    
//    return attributesArray;
//}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    UICollectionView * const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }
    
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        [answer addObject:layoutAttributes];
        
    }];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
            
            NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
            
            UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
            UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];
            
            
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
                CGPoint origin = layoutAttributes.frame.origin;
                origin.y = MIN(
                               MAX(contentOffset.y, (CGRectGetMinY(firstCellAttrs.frame) - headerHeight)),
                               (CGRectGetMaxY(lastCellAttrs.frame) - headerHeight)
                               );
                
                layoutAttributes.zIndex = 1024;
                layoutAttributes.frame = (CGRect){
                    .origin = origin,
                    .size = layoutAttributes.frame.size
                };
            } else {
                CGFloat headerWidth = CGRectGetWidth(layoutAttributes.frame);
                CGPoint origin = layoutAttributes.frame.origin;
                origin.x = MIN(
                               MAX(contentOffset.x, (CGRectGetMinX(firstCellAttrs.frame) - headerWidth)),
                               (CGRectGetMaxX(lastCellAttrs.frame) - headerWidth)
                               );
                
                layoutAttributes.zIndex = 2;
                layoutAttributes.frame = (CGRect){
                    .origin = origin,
                    .size = layoutAttributes.frame.size
                };
            }
            
        }
    }
    
    return answer;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

@end
