//
//  Filter.h
//  Yelp
//
//  Created by Peiqi Zheng on 9/22/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject

+ (NSArray *)getCategories;
+ (NSArray *)getDistanceOptions;
+ (NSArray *)getSortOptions;
@end
