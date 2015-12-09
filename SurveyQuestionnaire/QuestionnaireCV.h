//
//  QuestionnaireCV.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/8/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuestionnaireCVDelegate <NSObject>

- (void)updateCurrentIndex:(NSInteger)index;

@end
@interface QuestionnaireCV : UICollectionView

@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, assign) id<QuestionnaireCVDelegate> cvDelegate;
@property (nonatomic, assign) float itemHeight;

@end
