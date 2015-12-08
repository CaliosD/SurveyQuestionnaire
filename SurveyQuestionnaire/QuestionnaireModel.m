//
//  QuestionnaireModel.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "QuestionnaireModel.h"
#import "SingleQuestionModel.h"

@implementation QuestionnaireModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"questions": [SingleQuestionModel class]};
}

@end
