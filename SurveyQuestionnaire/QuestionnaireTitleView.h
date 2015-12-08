//
//  QuestionnaireTitleView.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/3/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionnaireTitleView : UIView

/**
 *  Configure title view for two situations: with page number(in questionnaire) and without page number(in answer sheet)
 *
 *  @param title title
 *  @param total 0 for without page number, >0 for with page number
 */
- (void)configureTitleViewWithText:(NSString *)title totalPage:(NSInteger)total;
- (void)setCurrentPage:(NSInteger)index;

@end
