//
//  QuestionnaireModel.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionnaireModel : NSObject

@property (nonatomic, strong) NSString *questionnaireTitle;
@property (nonatomic, strong) NSArray *questions;

@end
