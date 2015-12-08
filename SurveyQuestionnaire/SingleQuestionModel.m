//
//  SingleQuestionModel.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "SingleQuestionModel.h"
#import "OptionModel.h"

@implementation SingleQuestionModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"options": [OptionModel class]};
}

@end
