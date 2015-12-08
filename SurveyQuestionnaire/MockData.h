//
//  MockData.h
//  bjjgxxMLearning
//
//  Created by Calios on 8/3/15.
//  Copyright (c) 2015 SHTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockData : NSObject

// 调查问卷
@property (nonatomic, copy) NSDictionary *questionnaire;

+ (MockData *)sharedData;

@end
