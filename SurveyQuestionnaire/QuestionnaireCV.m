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

@interface QuestionnaireCV ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation QuestionnaireCV

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _itemHeight = 0.f;
        _currentIndex = 0;
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        if (isiPhone) {
            [self registerClass:[QuestionCVCell class] forCellWithReuseIdentifier:QuestionCVCellIdentifier];
        }
        else{
            _answers = [NSMutableArray array];

            [self registerClass:[OptionCVCell class] forCellWithReuseIdentifier:OptionCVCellIdentifier];
            [self registerClass:[QuestionCVHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:QuestionCVHeaderIdentifier];
        }
    }
    return self;
}

- (void)setQuestions:(NSArray *)questions
{
    _questions = [NSMutableArray arrayWithArray:questions];
    
    NSMutableArray *a = [NSMutableArray array];
    for (NSInteger i = 0; i < questions.count; i++) {
        SingleQuestionModel *question = _questions[i];
        NSMutableArray *q = [NSMutableArray array];
        for (int j = 0; j < question.options.count; j++) {
            OptionModel *option = question.options[j];
            if (option.isSelected) {
                [q addObject:[NSNumber numberWithInt:j]];
            }
        }
        [a addObject:q];
    }
    _answers = a;
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
            [self configureiPadCVCell:(OptionCVCell *)cell forIndex:indexPath];
        }
    }

    return cell;
}

- (void)configureCVCell:(QuestionCVCell *)cell forIndex:(NSInteger)index
{
    SingleQuestionModel *model = [_questions objectAtIndex:index];
    [cell configureCellWithModel:model];
}

- (void)configureiPadCVCell:(OptionCVCell *)cell forIndex:(NSIndexPath *)indexPath
{
    SingleQuestionModel *model = (SingleQuestionModel *)[_questions objectAtIndex:indexPath.section];

    OptionModel *option = [model.options objectAtIndex:indexPath.row];
    [cell configureCellWithModel:option andType:model.questionType];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SingleQuestionModel *question = (SingleQuestionModel *)[_questions objectAtIndex:indexPath.section];
    NSString *option = [[question.options objectAtIndex:indexPath.row] optionContent];
    CGSize size = [option boundingRectWithSize:CGSizeMake(self.frame.size.width - 20 - 12 * 3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]} context:nil].size;
    return isiPhone ? CGSizeMake([[UIScreen mainScreen] bounds].size.width, _itemHeight) : CGSizeMake([[UIScreen mainScreen] bounds].size.width, size.height + 12 * 2);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = nil;
    if (isiPad && _questions && _questions.count > 0) {
        header = (QuestionCVHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:QuestionCVHeaderIdentifier forIndexPath:indexPath];

        SingleQuestionModel *question = (SingleQuestionModel *)[_questions objectAtIndex:indexPath.section];
        [(QuestionCVHeader *)header setQuestion:question.question andType:question.questionType currentIndex:indexPath.section total:_questions.count];
    }
    
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    SingleQuestionModel *question = (SingleQuestionModel *)[_questions objectAtIndex:section];
    CGSize size = [question.question boundingRectWithSize:CGSizeMake(self.frame.size.width - 50 - 12 * 3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]} context:nil].size;

    return CGSizeMake(self.frame.size.width, size.height + 12 * 3 + 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isiPad) {
        SingleQuestionModel *model = [_questions objectAtIndex:indexPath.section];
        OptionModel *option = [model.options objectAtIndex:indexPath.row];
        option.isSelected = !option.isSelected;
        [model.options replaceObjectAtIndex:indexPath.row withObject:option];
        [_questions replaceObjectAtIndex:indexPath.section withObject:model];
        
        
        if (model.questionType == QuestionType_MultipleOptions) {
            if (option.isSelected) {
                [[_answers objectAtIndex:indexPath.section] addObject:[NSNumber numberWithInteger:indexPath.row]];
            }
            else{
                [[_answers objectAtIndex:indexPath.section] removeObject:[NSNumber numberWithInteger:indexPath.row]];
            }
            
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];

        }
        else if (model.questionType == QuestionType_SingleOption){
            if (option.isSelected) {
                if ([[_answers objectAtIndex:indexPath.section] count] > 0) {
                    NSIndexPath *oldIndex = [NSIndexPath indexPathForRow:[_answers[indexPath.section][0] integerValue] inSection:indexPath.section];
                    OptionModel *o = [model.options objectAtIndex:[_answers[indexPath.section][0] integerValue]];
                    o.isSelected = NO;
                    [model.options replaceObjectAtIndex:[_answers[indexPath.section][0] integerValue] withObject:o];
                    [_questions replaceObjectAtIndex:indexPath.section withObject:model];
                    
                    [[_answers objectAtIndex:indexPath.section] removeAllObjects];
                    [[_answers objectAtIndex:indexPath.section] addObject:[NSNumber numberWithInteger:indexPath.row]];
                    [collectionView reloadItemsAtIndexPaths:@[indexPath, oldIndex]];
                }
                else{
                    [[_answers objectAtIndex:indexPath.section] removeAllObjects];
                    [[_answers objectAtIndex:indexPath.section] addObject:[NSNumber numberWithInteger:indexPath.row]];
                    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
            }
            else{
                [[_answers objectAtIndex:indexPath.section] removeObject:[NSNumber numberWithInteger:indexPath.row]];
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex = (NSInteger)scrollView.contentOffset.x/[[UIScreen mainScreen]bounds].size.width;
    [[MockData sharedData] setCurrentIndex:_currentIndex];

    if ([self.cvDelegate respondsToSelector:@selector(updateCurrentIndex:)]) {
        [self.cvDelegate updateCurrentIndex:_currentIndex];
    }
}

@end
