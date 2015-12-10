//
//  SingleQuestionModel.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleQuestionModel : NSObject

@property (nonatomic, strong) NSString *question;
@property (nonatomic, assign) QuestionType questionType;
@property (nonatomic, strong) NSMutableArray *options;

@end
