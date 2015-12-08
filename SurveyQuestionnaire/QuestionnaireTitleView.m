//
//  QuestionnaireTitleView.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/3/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "QuestionnaireTitleView.h"

@interface QuestionnaireTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *currentPageLabel;
@property (nonatomic, strong) UILabel *totalPageLabel;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation QuestionnaireTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {       
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
        _titleLabel.font = [UIFont systemFontOfSize:15.f];

        _currentPageLabel = [UILabel newAutoLayoutView];
        _currentPageLabel.textColor = [UIColor redColor];
        _currentPageLabel.font = [UIFont systemFontOfSize:15.f];
        _currentPageLabel.textAlignment = NSTextAlignmentRight;
        
        _totalPageLabel = [UILabel newAutoLayoutView];
        _totalPageLabel.textColor = [UIColor lightGrayColor];
        _totalPageLabel.font = [UIFont systemFontOfSize:13.f];
        
        _line = [UILabel newAutoLayoutView];
        _line.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:_titleLabel];
        [self addSubview:_currentPageLabel];
        [self addSubview:_totalPageLabel];
        [self addSubview:_line];
    }
    return self;
}

//- (void)layoutSublayersOfLayer:(CALayer *)layer
//{
//    [super layoutSublayersOfLayer:layer];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
    [super layoutSubviews];
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(12, 12, 12, 0) excludingEdge:ALEdgeRight];
        
        [_currentPageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_titleLabel withOffset:12];
        [_totalPageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_currentPageLabel];
        [_totalPageLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:12];
        [_totalPageLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
        [@[_currentPageLabel,_totalPageLabel] autoSetViewsDimension:ALDimensionWidth toSize:24];
        [@[_currentPageLabel,_totalPageLabel] autoAlignViewsToEdge:ALEdgeBottom];
        
        [_line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
        [_line autoSetDimension:ALDimensionHeight toSize:0.5];
        
        self.didSetupConstraints = YES;
    }
    
    if (_total == 0) {
        [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
    }
    [super updateConstraints];
}

- (void)configureTitleViewWithText:(NSString *)title totalPage:(NSInteger)total
{
    _total = total;
    _titleLabel.text = title;
    if (total == 0) {
        _currentPageLabel.textColor = [UIColor clearColor];
        _totalPageLabel.textColor = [UIColor clearColor];
    }
    _currentPageLabel.text = @"1";
    _totalPageLabel.text = [NSString stringWithFormat:@"/%ld",(long)total];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setCurrentPage:(NSInteger)index
{
    _currentPageLabel.text = [NSString stringWithFormat:@"%ld",(long)index + 1];
}

@end
