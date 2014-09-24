//
//  SearchResult.h
//  Yelp
//
//  Created by Peiqi Zheng on 9/21/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResult : NSObject

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *numberOfReviews;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) NSURL *ratingsUrl;
@property float distance;
@property NSInteger reviewCount;
@property (nonatomic, assign) NSUInteger index;
+ (NSArray *) searchItemsWithObject:(id)object;
- (id) initWithDictionary:(NSDictionary *)dictionary index:(NSUInteger)index;

@end
