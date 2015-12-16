//
//  QuestionCVHeader.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/8/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "QuestionCVHeader.h"

NSString *const QuestionCVHeaderIdentifier = @"QuestionCVHeaderIdentifier";
NSInteger const TypeSize = 38;

@interface QuestionCVHeader ()

@property (nonatomic, strong) UILabel *qTypeLabel;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *currentPageLabel;
@property (nonatomic, strong) UILabel *totalPageLabel;
@property (nonatomic, strong) UIView  *line;

@property (nonatomic, assign) NSInteger total;

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
        _questionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _questionLabel.preferredMaxLayoutWidth = self.frame.size.width - TypeSize - 12 * 2;
        
        if (isiPad) {
            _currentPageLabel = [UILabel newAutoLayoutView];
            _currentPageLabel.textColor = [UIColor redColor];
            _currentPageLabel.font = [UIFont systemFontOfSize:18.f];
            _currentPageLabel.textAlignment = NSTextAlignmentRight;
            
            _totalPageLabel = [UILabel newAutoLayoutView];
            _totalPageLabel.textColor = [UIColor lightGrayColor];
            _totalPageLabel.font = [UIFont systemFontOfSize:13.f];
            
            _line = [UILabel newAutoLayoutView];
            _line.backgroundColor = [UIColor lightGrayColor];
            
            [self addSubview:_currentPageLabel];
            [self addSubview:_totalPageLabel];
            [self addSubview:_line];
        }
        
        [self addSubview:_qTypeLabel];
        [self addSubview:_questionLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger offset = (_total > 0) ? 50 : 50;
    _questionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds) - offset;
    [super layoutSubviews];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        if (isiPhone) {
            [_qTypeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
            [_questionLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(15, 12 * 2 + TypeSize, 12, 12) excludingEdge:ALEdgeBottom];
        }
        else{
            [_currentPageLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
            [_currentPageLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
            [_totalPageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_currentPageLabel];
            [_totalPageLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:12];
            [_totalPageLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
            
            [@[_currentPageLabel] autoSetViewsDimensionsToSize:CGSizeMake(24, 15)];
            
            [_line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
            [_line autoSetDimension:ALDimensionHeight toSize:0.5];
            
            [_qTypeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12.f];
            [_questionLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(15 * 2 + 12, 12 * 2 + TypeSize, 12, 12) excludingEdge:ALEdgeBottom];
        }
        
        [_qTypeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
        [_qTypeLabel autoSetDimensionsToSize:CGSizeMake(TypeSize, 15)];
        
        [_questionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)setQuestion:(NSString *)question andType:(QuestionType)questionType currentIndex:(NSInteger)current total:(NSInteger)total
{
    _qTypeLabel.text = [NSString stringWithFormat:@"(%@)", [self questionType:questionType]];
    _questionLabel.text = question;
    [_questionLabel sizeToFit];
 
    if (isiPad && total > 0) {
        _currentPageLabel.text = [NSString stringWithFormat:@"%ld",(long)current + 1];
        _totalPageLabel.text = [NSString stringWithFormat:@"/%ld",(long)total];
    }
    
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
