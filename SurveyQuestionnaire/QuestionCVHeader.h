//
//  QuestionCVHeader.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/8/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const QuestionCVHeaderIdentifier;

@interface QuestionCVHeader : UICollectionReusableView

- (void)setQuestion:(NSString *)question andType:(QuestionType)questionType;

@end
