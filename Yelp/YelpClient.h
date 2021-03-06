//
//  YelpClient.h
//  Yelp
//
//  Created by Peiqi Zheng on 9/17/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface YelpClient : BDBOAuth1RequestOperationManager

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret;

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term
                               withFilters:(NSDictionary *)filters
                                atLocation:(CLLocation *)location
                                withOffset:(NSInteger)offset
                                   success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
