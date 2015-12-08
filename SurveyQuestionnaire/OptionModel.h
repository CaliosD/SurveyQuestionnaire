//
//  OptionModel.h
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionModel : NSObject

@property (nonatomic, strong) NSString *optionContent;
@property (nonatomic, assign) BOOL     isSelected;

@end
