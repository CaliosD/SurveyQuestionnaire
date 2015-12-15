//
//  OptionCVCell.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/8/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionModel.h"

extern NSString *const OptionCVCellIdentifier;

@interface OptionCVCell : UICollectionViewCell

- (void)configureCellWithModel:(OptionModel *)model andType:(QuestionType )type;

@end
