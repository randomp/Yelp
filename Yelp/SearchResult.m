//
//  SearchResult.m
//  Yelp
//
//  Created by Peiqi Zheng on 9/21/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "SearchResult.h"

@implementation SearchResult

+ (NSArray *) searchItemsWithObject:(id)object {
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    id items = object[@"businesses"];
    for(NSDictionary *dictionary in items)
    {
        NSUInteger index = [items indexOfObject:dictionary];
        SearchResult *searchResult = [[SearchResult alloc] initWithDictionary:dictionary index:index];
        [searchResults addObject:searchResult];
    }
    return [searchResults copy];
}
- (id) initWithDictionary:(NSDictionary *)dictionary index:(NSUInteger)index {
    self = [super init];
    if (self) {
        self.index = index + 1;
        self.dictionary = dictionary;
        self.name = [NSString stringWithFormat:@"%@", self.dictionary[@"name"]];
        self.numberOfReviews = [NSString stringWithFormat:@"%@ Reviews", self.dictionary[@"review_count"]];
        self.address = self.dictionary[@"location"][@"display_address"][0];
        self.categories = [NSString stringWithFormat:@"%@", self.dictionary[@"categories"]];
        self.distance = [self.dictionary[@"distance"] floatValue];
        self.reviewCount = [self.dictionary[@"review_count"] integerValue];
        NSString *imageUrl;
        if (self.dictionary[@"image_url"]) {
            imageUrl = self.dictionary[@"image_url"];
        } else{
            // sometimes the api doesn't return an image so use yelp's logo
            imageUrl = @"http://thaigreenvillage.com/wp-content/uploads/2013/09/yelp-ios-app-icon1.png";
        }
        self.imageUrl = [[NSURL alloc] initWithString:imageUrl];
        
        self.ratingsUrl = [[NSURL alloc] initWithString:self.dictionary[@"rating_img_url_large"]];
        
        NSMutableArray *a = [[NSMutableArray alloc] init];
        for(NSArray *n in self.dictionary[@"categories"]){
            [a addObject:n[0]];
        }
        self.categories = [a componentsJoinedByString:@", "];
    }
    return self;
}

@end
