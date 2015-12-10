//
//  QuestionCVCell.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/9/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "QuestionCVCell.h"
#import "SingleQuestionTV.h"

NSString *const QuestionCVCellIdentifier = @"QuestionCVCellIdentifier";

@interface QuestionCVCell ()

@property (nonatomic, strong) SingleQuestionTV *tableView;

@end

@implementation QuestionCVCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[SingleQuestionTV alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_tableView];
    }
    return self;
}

- (void)setModel:(SingleQuestionModel *)model
{
    _model = model;
    _tableView.model = model;
    [_tableView reloadData];
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    _tableView.index = index;
}

//- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
//{
//    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
//    attributes.size = [self systemLayoutSizeFittingSize:layoutAttributes.size withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
//    return attributes;
//}

@end
