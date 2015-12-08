//
//  MockData.m
//  bjjgxxMLearning
//
//  Created by Calios on 8/3/15.
//  Copyright (c) 2015 SHTD. All rights reserved.
//

#import "MockData.h"

@implementation MockData

+ (MockData *)sharedData
{
    static MockData *mock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mock = [[MockData alloc] init];
    });
    return mock;
}

#pragma mark - 调查问卷
- (NSDictionary *)questionnaire
{
    if (!_questionnaire) {
        _questionnaire = @{
                           @"questionnaireTitle" : @"大学生就业意向调查问卷（学生）大学生就业意向调查问卷（学生）大学生就业意向调查问卷（学生）大学生就业意向调查问卷（学生）大学生就业意向调查问卷（学生）大学生就业意向调查问卷（学生）",
                           @"questions" :  @[
                                   @{
                                       @"question" : @"1.您的性别？",
                                       @"questionType" : @0,
                                       @"options" : @[
                                                       @{
                                                           @"optionContent" : @"Q1：男",
                                                           @"isSelected" : @NO
                                                       },
                                                       @{
                                                           @"optionContent" : @"Q2：女",
                                                           @"isSelected" : @NO
                                                           },
                                                   ]
                                       },
                                   @{
                                       @"question" : @"2.以下哪项描述符合你毕业后的去向安排？",
                                       @"questionType" : @1,
                                       @"options" : @[
                                               @{
                                                   @"optionContent" : @"Q1：就业",
                                                   @"isSelected" : @NO
                                                   },
                                               @{
                                                   @"optionContent" : @"Q2：自主创业",
                                                   @"isSelected" : @NO
                                                   },
                                               @{
                                                   @"optionContent" : @"Q3：考研",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q4：出国",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q5：暂不就业",
                                                   @"isSelected" : @0
                                                   },
                                               ]
                                       },
                                   @{
                                       @"question" : @"3.你倾向于如何在应聘过程中突显自己？",
                                       @"questionType" : @1,
                                       @"options" : @[
                                               @{
                                                   @"optionContent" : @"Q1: 制作精美、详尽的自荐材料",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q2: 通过直接沟通荣招聘者记住自己",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q3: 面试时在着装形象仪表方面下功夫",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q4: 请有信誉威望的人推荐自己",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q5：事先充分了解单位，表示自己有充分的兴趣和准备 Q5：事先充分了解单位，表示自己有充分的兴趣和准备 Q5：事先充分了解单位，表示自己有充分的兴趣和准备",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q6: 突出自己的特长，表示自己完全能胜任招聘岗位的需求",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q7: 突出自己的学习能力和综合素质，表现自己将是可塑之才",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q8: 突出自己的性格，表现自己能够和单位同事相处愉快",
                                                   @"isSelected" : @0
                                                   },
                                               ]
                                       },
                                   @{
                                       @"question" : @"4.您的性别？",
                                       @"questionType" : @0,
                                       @"options" : @[
                                               @{
                                                   @"optionContent" : @"Q1：男",
                                                   @"isSelected" : @NO
                                                   },
                                               @{
                                                   @"optionContent" : @"Q2：女",
                                                   @"isSelected" : @NO
                                                   },
                                               ]
                                       },
                                   @{
                                       @"question" : @"5.以下哪项描述符合你毕业后的去向安排？",
                                       @"questionType" : @1,
                                       @"options" : @[
                                               @{
                                                   @"optionContent" : @"Q1：就业",
                                                   @"isSelected" : @NO
                                                   },
                                               @{
                                                   @"optionContent" : @"Q2：自主创业",
                                                   @"isSelected" : @NO
                                                   },
                                               @{
                                                   @"optionContent" : @"Q3：考研",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q4：出国",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q5：暂不就业",
                                                   @"isSelected" : @0
                                                   },
                                               ]
                                       },
                                   @{
                                       @"question" : @"6.你倾向于如何在应聘过程中突显自己？",
                                       @"questionType" : @1,
                                       @"options" : @[
                                               @{
                                                   @"optionContent" : @"Q1: 制作精美、详尽的自荐材料",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q2: 通过直接沟通荣招聘者记住自己",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q3: 面试时在着装形象仪表方面下功夫",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q4: 请有信誉威望的人推荐自己",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q5：事先充分了解单位，表示自己有充分的兴趣和准备",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q6: 突出自己的特长，表示自己完全能胜任招聘岗位的需求",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q7: 突出自己的学习能力和综合素质，表现自己将是可塑之才",
                                                   @"isSelected" : @0
                                                   },
                                               @{
                                                   @"optionContent" : @"Q8: 突出自己的性格，表现自己能够和单位同事相处愉快",
                                                   @"isSelected" : @0
                                                   },
                                               ]
                                       }

                                   ]
                           };
        
    }
    return _questionnaire;
}

@end
