//
//  AnswerSheetCV.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/4/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "AnswerSheetCV.h"
#import "SingleAnswerCVCell.h"

@interface AnswerSheetCV ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end
@implementation AnswerSheetCV

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[SingleAnswerCVCell class] forCellWithReuseIdentifier:AnswerSheetCVCellIdentifier];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _answers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SingleAnswerCVCell *cell = (SingleAnswerCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:AnswerSheetCVCellIdentifier forIndexPath:indexPath];
    cell.cellIndex = indexPath.row;
    id answer = [_answers objectAtIndex:indexPath.row];
    if ([answer isKindOfClass:[NSArray class]] && [(NSArray *)answer count] > 0) {
        cell.isAnswered = YES;
    }
    else{
        cell.isAnswered = NO;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = self.bounds.size.width / 5.f - 1;
    return CGSizeMake(size, size);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.answerSheetDelegate respondsToSelector:@selector(answerCellSelectedWithIndex:)]) {
        [self.answerSheetDelegate answerCellSelectedWithIndex:indexPath.row];
    }
}


@end
