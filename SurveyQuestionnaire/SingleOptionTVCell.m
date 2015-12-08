//
//  SingleOptionTVCell.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "SingleOptionTVCell.h"

#define CheckBtnSize    20

@interface SingleOptionTVCell ()

@property (nonatomic, strong) UILabel *optionCheckLabel;
@property (nonatomic, strong) UILabel *optionLabel;

@property (nonatomic, assign) BOOL    didSetupConstraints;

@end

@implementation SingleOptionTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [_optionCheckLabel setClipsToBounds:YES];

    if (_questionType == QuestionType_SingleOption) {
        _optionCheckLabel.layer.cornerRadius = CheckBtnSize/2.f;
    }
    else if (_questionType == QuestionType_MultipleOptions){
        _optionCheckLabel.layer.cornerRadius = 2.f;
    }
    
    _optionLabel.text = _option.optionContent;
    [self updateCheckLabel];
    
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void)updateCheckLabel
{
    _optionCheckLabel.backgroundColor = _option.isSelected ? [UIColor redColor] : [UIColor whiteColor];
    _optionCheckLabel.layer.borderWidth = 1.f;
    _optionCheckLabel.layer.borderColor = _option.isSelected ? [UIColor redColor].CGColor : [UIColor lightGrayColor].CGColor;
    _optionCheckLabel.textColor = _option.isSelected ? [UIColor whiteColor] : [UIColor lightGrayColor];
}

@end