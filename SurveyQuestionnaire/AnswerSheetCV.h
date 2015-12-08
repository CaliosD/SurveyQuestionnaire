//
//  AnswerSheetCV.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/4/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnswerSheetCVDelegate <NSObject>

- (void)answerCellSelectedWithIndex:(NSInteger)index;

@end

@interface AnswerSheetCV : UICollectionView

@property (nonatomic, assign) id<AnswerSheetCVDelegate> answerSheetDelegate;
@property (nonatomic, strong) NSArray *answers;

@end
