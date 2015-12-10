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

@interface QuestionCVCell : UICollectionViewCell

@property (nonatomic, strong) SingleQuestionModel *model;

@end
