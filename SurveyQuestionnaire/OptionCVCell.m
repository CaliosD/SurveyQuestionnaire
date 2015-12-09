//
//  OptionCVCell.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/8/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "OptionCVCell.h"

NSString *const OptionCVCellIdentifier = @"OptionCVCellIdentifier";
NSInteger const CheckBtnSize = 20;

@interface OptionCVCell ()

@property (nonatomic, strong) UILabel *optionCheckLabel;
@property (nonatomic, strong) UILabel *optionLabel;

@property (nonatomic, assign) BOOL    didSetupConstraints;

@end

@implementation OptionCVCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _optionCheckLabel = [UILabel newAutoLayoutView];
        _optionCheckLabel.font = [UIFont systemFontOfSize:14];
        _optionCheckLabel.textAlignment = NSTextAlignmentCenter;
        _optionCheckLabel.text = @"√";
        _optionLabel = [UILabel newAutoLayoutView];
        _optionLabel.font = [UIFont systemFontOfSize:14.f];
        _optionLabel.numberOfLines = 0;
        _optionLabel.preferredMaxLayoutWidth = self.frame.size.width - CheckBtnSize;
        
        [self.contentView addSubview:_optionCheckLabel];
        [self.contentView addSubview:_optionLabel];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_optionCheckLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        [_optionCheckLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
        [_optionCheckLabel autoSetDimensionsToSize:CGSizeMake(CheckBtnSize, CheckBtnSize)];
        
        [_optionLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(15, 12 * 2 + CheckBtnSize, 12, 12) excludingEdge:ALEdgeBottom];
        [_optionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)setOption:(OptionModel *)option
{
    _option = option;
    _optionLabel.text = _option.optionContent;

    [_optionCheckLabel setClipsToBounds:YES];
    _optionCheckLabel.layer.cornerRadius = (_questionType == QuestionType_SingleOption) ?CheckBtnSize/2.f : 2.f;

    [self updateCheckLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateCheckLabel
{
    [self setIsSelected:_option.isSelected];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _optionCheckLabel.backgroundColor = isSelected ? [UIColor redColor] : [UIColor whiteColor];
    _optionCheckLabel.layer.borderWidth = 1.f;
    _optionCheckLabel.layer.borderColor = isSelected ? [UIColor redColor].CGColor : [UIColor lightGrayColor].CGColor;
    _optionCheckLabel.textColor = isSelected ? [UIColor whiteColor] : [UIColor lightGrayColor];
}

@end
