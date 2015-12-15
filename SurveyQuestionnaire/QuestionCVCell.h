//
//  QuestionCVCell.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/9/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SingleQuestionModel;

extern NSString *const QuestionCVCellIdentifier;

@protocol QuestionCVCellDelegate <NSObject>

- (void)questionCVCellDidSelectWithAnswer:(NSArray *)array;

@end
@interface QuestionCVCell : UICollectionViewCell

@property (nonatomic, assign) id<QuestionCVCellDelegate> cellDelegate;

- (void)configureCellWithModel:(SingleQuestionModel *)model;

@end
