//
//  SingleQuestionTV.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleQuestionTV : UITableView

/**
 *  The parameter can be SingleQuestionModel instance or NSArray consisted of SingleQuestionModel instance.
 */
@property (nonatomic, strong) id model;

@end
