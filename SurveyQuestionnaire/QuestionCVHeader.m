//
//  QuestionCVHeader.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/8/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "QuestionCVHeader.h"

NSString *const QuestionCVHeaderIdentifier = @"QuestionCVHeaderIdentifier";
NSInteger const TypeSize = 50;

@interface QuestionCVHeader ()

@property (nonatomic, strong) UILabel *qTypeLabel;
@property (nonatomic, strong) UILabel *questionLabel;

@property (nonatomic, assign) BOOL    didSetupConstraints;

@end

@implementation QuestionCVHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _qTypeLabel = [UILabel newAutoLayoutView];
        _qTypeLabel.font = [UIFont systemFontOfSize:14];
        _qTypeLabel.textColor = [UIColor colorWithRed:0.f green:153/255.f blue:255/255.f alpha:1.f];

        _questionLabel = [UILabel newAutoLayoutView];
        _questionLabel.font = [UIFont systemFontOfSize:14.f];
        _questionLabel.numberOfLines = 0;
        _questionLabel.preferredMaxLayoutWidth = self.frame.size.width - TypeSize;
        
        [self addSubview:_qTypeLabel];
        [self addSubview:_questionLabel];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_qTypeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        [_qTypeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
        [_qTypeLabel autoSetDimensionsToSize:CGSizeMake(TypeSize, 20)];
        
        [_questionLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(15, 12 * 2 + TypeSize, 12, 12) excludingEdge:ALEdgeBottom];
        [_questionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)setQuestion:(NSString *)question andType:(QuestionType)questionType
{
    _qTypeLabel.text = [NSString stringWithFormat:@"(%@)", [self questionType:questionType]];
    _questionLabel.text = question;
    [_questionLabel sizeToFit];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - Private

- (NSString *)questionType:(QuestionType)type
{
    NSString *question;
    switch (type) {
        case QuestionType_SingleOption:
            question = @"单选";
            break;
        case QuestionType_MultipleOptions:
            question = @"多选";
            break;
        default:
            break;
    }
    return question;
}

@end
