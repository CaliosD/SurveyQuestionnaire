//
//  OptionModel.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "OptionModel.h"

@implementation OptionModel

#define kOPTION_CONTENT 						@"optionContent"
#define kIS_SELECTED 						@"isSelected"



//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.optionContent forKey:kOPTION_CONTENT];
    [encoder encodeBool:self.isSelected forKey:kIS_SELECTED];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.optionContent = [decoder decodeObjectForKey:kOPTION_CONTENT];
        self.isSelected = [decoder decodeBoolForKey:kIS_SELECTED];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setOptionContent:[self.optionContent copy]];
    [theCopy setSelected:self.isSelected];
    
    return theCopy;
}

@end
