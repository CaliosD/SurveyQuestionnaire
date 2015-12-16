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
@property (nonatomic, assign) BOOL isSelected;

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
        [_optionCheckLabel setClipsToBounds:YES];
        
        _optionLabel = [UILabel newAutoLayoutView];
        _optionLabel.font = [UIFont systemFontOfSize:14.f];
        _optionLabel.numberOfLines = 0;
        _optionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _optionLabel.preferredMaxLayoutWidth = 1024 - CheckBtnSize - 12 * 2;
        
        [self.contentView addSubview:_optionCheckLabel];
        [self.contentView addSubview:_optionLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _optionLabel.preferredMaxLayoutWidth = 1024 - CheckBtnSize - 12 * 2;
    [super layoutSubviews];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_optionCheckLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        [_optionCheckLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
        [_optionCheckLabel autoSetDimensionsToSize:CGSizeMake(CheckBtnSize, CheckBtnSize)];
        
        [_optionLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(12, 12 * 2 + CheckBtnSize, 12, 12) excludingEdge:ALEdgeBottom];
        [_optionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)updateCellWithSelected:(BOOL)selected;
{
    _optionCheckLabel.backgroundColor = selected ? [UIColor redColor] : [UIColor whiteColor];
    _optionCheckLabel.layer.borderWidth = 1.f;
    _optionCheckLabel.layer.borderColor = selected ? [UIColor redColor].CGColor : [UIColor lightGrayColor].CGColor;
    _optionCheckLabel.textColor = selected ? [UIColor whiteColor] : [UIColor lightGrayColor];
    
}

- (void)configureCellWithModel:(OptionModel *)model andType:(QuestionType)type
{
    _optionLabel.text = model.optionContent;
    
    if (type == QuestionType_SingleOption) {
        _optionCheckLabel.layer.cornerRadius = CheckBtnSize/2.f;
    }
    else if (type == QuestionType_MultipleOptions){
        _optionCheckLabel.layer.cornerRadius = 2.f;
    }
    
    [self updateCellWithSelected:model.isSelected];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

@end
