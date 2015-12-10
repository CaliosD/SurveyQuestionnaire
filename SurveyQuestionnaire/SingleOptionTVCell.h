//
//  SingleOptionTVCell.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionModel.h"

@interface SingleOptionTVCell : UITableViewCell

@property (nonatomic, assign) QuestionType questionType;
@property (nonatomic, strong) OptionModel *option;

- (void)updateWithSelected:(BOOL)selected;

@end
