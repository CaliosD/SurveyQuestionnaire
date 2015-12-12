//
//  QuestionnaireCV.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/8/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "QuestionnaireCV.h"
#import "QuestionCVCell.h"
#import "QuestionCVHeader.h"
#import "OptionCVCell.h"
#import "SingleQuestionModel.h"

@interface QuestionnaireCV ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation QuestionnaireCV

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _itemHeight = 0.f;
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        if (isiPhone) {
            [self registerClass:[QuestionCVCell class] forCellWithReuseIdentifier:QuestionCVCellIdentifier];
        }
        else{
            [self registerClass:[OptionCVCell class] forCellWithReuseIdentifier:OptionCVCellIdentifier];
            [self registerClass:[QuestionCVHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:QuestionCVHeaderIdentifier];
        }
    }
    return self;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return isiPhone ? 1 : _questions.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return isiPhone ? _questions.count : [[(SingleQuestionModel *)[_questions objectAtIndex:section] options] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (isiPhone) {
        cell = (QuestionCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:QuestionCVCellIdentifier forIndexPath:indexPath];
    
        if (_questions && _questions.count > 0) {
            ((QuestionCVCell *)cell).model = [_questions objectAtIndex:indexPath.item];
            ((QuestionCVCell *)cell).index = indexPath.item;
            
            NSIndexPath *test = [collectionView indexPathForCell:cell];
            NSLog(@"   %ld, %ld",(long)indexPath.item, (long)test.item);
        }
    }
    else{
        cell = (OptionCVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:OptionCVCellIdentifier forIndexPath:indexPath];
        
        if (_questions && _questions.count > 0) {
            OptionModel *option = [[(SingleQuestionModel *)[_questions objectAtIndex:indexPath.section] options] objectAtIndex:indexPath.row];
            ((OptionCVCell *)cell).option = option;
            ((OptionCVCell *)cell).questionType = [(SingleQuestionModel *)[_questions objectAtIndex:indexPath.section] questionType];
        }
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return isiPhone ? CGSizeMake([[UIScreen mainScreen] bounds].size.width, _itemHeight) : CGSizeMake(1024, 100);
}

#if TARGET_OS_IPHONE
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = nil;
    if (isiPad && _questions && _questions.count > 0) {
        header = (QuestionCVHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:QuestionCVHeaderIdentifier forIndexPath:indexPath];

        SingleQuestionModel *question = (SingleQuestionModel *)[_questions objectAtIndex:indexPath.section];
        [(QuestionCVHeader *)header setQuestion:question.question andType:question.questionType];
    }
    
    return header;
}
#endif

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isiPad) {
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = (NSInteger)scrollView.contentOffset.x/375;

    if ([self.cvDelegate respondsToSelector:@selector(updateCurrentIndex:)]) {
        [self.cvDelegate updateCurrentIndex:currentIndex - 1];
    }
}

@end
