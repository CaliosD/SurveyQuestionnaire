//
//  SingleQuestionModel.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/2/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "SingleQuestionModel.h"
#import "OptionModel.h"

@implementation SingleQuestionModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"options": [OptionModel class]};
}

#define kQUESTION 						@"question"
#define kQUESTION_TYPE 					@"questionType"
#define kOPTIONS 						@"options"



//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.question forKey:kQUESTION];
    //ivar named: questionType  and of type: QuestionType -- TYPE_NOT_SUPPORTED
    //[encoder encodeType(?):self.questionType forKey:kQUESTION_TYPE];
    [encoder encodeObject:self.options forKey:kOPTIONS];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.question = [decoder decodeObjectForKey:kQUESTION];
        //ivar named: questionType and of type: QuestionType -- TYPE_NOT_SUPPORTED
        //[self setQuestionType:[decoder decodeType(?)ForKey:kQUESTION_TYPE]];
        self.options = [decoder decodeObjectForKey:kOPTIONS];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setQuestion:[self.question copy]];
    [theCopy setQuestionType:self.questionType];
    [theCopy setOptions:[self.options copy]];
    
    return theCopy;
}

@end
