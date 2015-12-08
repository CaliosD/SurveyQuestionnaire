//
//  SingleAnswerCVCell.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/4/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const AnswerSheetCVCellIdentifier;

@interface SingleAnswerCVCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger cellIndex;
@property (nonatomic, assign) BOOL      isAnswered;

@end
