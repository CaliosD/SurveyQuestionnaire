//
//  AnswersheetModel.m
//  SurveyQuestionnaire
//
//  Created by Calios on 12/11/15.
//  Copyright © 2015 Calios. All rights reserved.
//

#import "AnswersheetModel.h"

@implementation AnswersheetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.answers = [[NSMutableArray alloc] initWithCapacity:6];
    }
    return self;
}

- (void)insertObject:(NSArray *)object inAnswersAtIndex:(NSUInteger)index
{
    [self.answers insertObject:object atIndex:index];
}

- (void)replaceObjectInAnswersAtIndex:(NSUInteger)index withObject:(id)object
{
    [self.answers replaceObjectAtIndex:index withObject:object];
    NSLog(@"--------- %lu, %@", (unsigned long)index, object);
}

- (void)removeObjectFromAnswersAtIndex:(NSUInteger)index
{
    [self.answers removeObjectAtIndex:index];
}

@end
