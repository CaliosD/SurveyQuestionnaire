//
//  SingleAnswerCVCell.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/4/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "SingleAnswerCVCell.h"

NSString *const AnswerSheetCVCellIdentifier = @"AnswerSheetCVCellIdentifier";
NSInteger const textSize = 30;

@interface SingleAnswerCVCell ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SingleAnswerCVCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat x = (frame.size.width - textSize)/2.f;
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, x, textSize, textSize)];
        [_textLabel setClipsToBounds:YES];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.cornerRadius = textSize/2.f;
        _textLabel.layer.borderWidth = 1.f;
        
        [self.contentView addSubview:_textLabel];
    }
    return self;
}

- (void)setCellIndex:(NSInteger)cellIndex
{
    _textLabel.text = [NSString stringWithFormat:@"%ld",(long)cellIndex];
}

- (void)setIsAnswered:(BOOL)isAnswered
{
    if (isAnswered) {
        _textLabel.layer.borderColor = [UIColor redColor].CGColor;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor redColor];
    }
    else{
        _textLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textLabel.textColor = [UIColor lightGrayColor];
        _textLabel.backgroundColor = [UIColor whiteColor];
    }
}


@end
