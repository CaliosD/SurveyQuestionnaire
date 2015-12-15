//
//  SingleQuestionTV.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SingleQuestionModel;
@protocol SingleQuestionTVDelegate <NSObject>

- (void)singleQuestionTVDidSelectWithAnswer:(NSArray *)answers;

@end

@interface SingleQuestionTV : UITableView

@property (nonatomic, strong) SingleQuestionModel *model;
@property (nonatomic, assign) id<SingleQuestionTVDelegate> tvDelegate;

@end
