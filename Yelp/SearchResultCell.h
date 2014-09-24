//
//  SearchResultCell.h
//  Yelp
//
//  Created by Peiqi Zheng on 9/21/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"

@interface SearchResultCell : UITableViewCell

@property (strong, nonatomic) SearchResult *searchResult;

+ (NSString *)cellIdentifier;
- (void)setSearchResult:(SearchResult *)searchResult withIndex:(NSInteger) index;
@end