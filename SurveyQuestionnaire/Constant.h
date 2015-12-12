//
//  Constant.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

typedef NS_ENUM(NSInteger, QuestionType){
    QuestionType_SingleOption = 0,
    QuestionType_MultipleOptions = 1
};

#define QuestionnaireAnswersChangeNotification  @"QuestionnaireAnswersChangeNotification"
#define QuestionnaireScrollNotification         @"QuestionnaireScrollNotification"

/**
 *  Key used for cache.
 */
#define QuestionnaireQuestionArrayCacheKey      @"QuestionnaireQuestionArrayCacheKey"
#define QuestionnaireAnswerArrayCacheKey        @"QuestionnaireAnswerArrayCacheKey"



#define isiPhone                [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define isiPad                  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad

#endif /* Constant_h */
