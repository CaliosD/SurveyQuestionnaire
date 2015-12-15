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

static void *QuestionnaireViewControllerAnswerArrayObservationContext = &QuestionnaireViewControllerAnswerArrayObservationContext;

@interface QuestionnaireCV ()<UICollectionViewDataSource, UICollectionViewDelegate, QuestionCVCellDelegate>

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableDictionary *testDict;

@end

@implementation QuestionnaireCV

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _itemHeight = 0.f;
        _currentIndex = 0;
        _testDict = [NSMutableDictionary dictionary];
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
            [self configureCVCell:(QuestionCVCell *)cell forIndex:indexPath.row];
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

- (void)configureCVCell:(QuestionCVCell *)cell forIndex:(NSInteger)index
{
    cell.cellDelegate = self;
    SingleQuestionModel *model = [_questions objectAtIndex:index];

//    NSLog(@"------------ %@,%@, %ld",model.question,model.options,(long)index);

    [cell configureCellWithModel:model];
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
    if (isiPhone) {
        
    }
}

- (void)questionCVCellDidSelectWithAnswer:(NSArray *)array
{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)_currentIndex];
    [_testDict setObject:array forKey:key];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex = (NSInteger)scrollView.contentOffset.x/375;

    NSLog(@"~~~~~~~~~~~~~~_currentIndex: %ld",(long)_currentIndex);
    [[MockData sharedData] setCurrentIndex:_currentIndex];

    if ([self.cvDelegate respondsToSelector:@selector(updateCurrentIndex:)]) {
        [self.cvDelegate updateCurrentIndex:_currentIndex];
    }
}

@end
