//
//  SingleQuestionTV.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SingleQuestionModel;

@interface SingleQuestionTV : UITableView

@property (nonatomic, strong) SingleQuestionModel *model;
@property (nonatomic, strong) NSMutableArray *answerArray;
@property (nonatomic, assign) NSInteger index;

@end
