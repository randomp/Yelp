//
//  FilterViewController.h
//  Yelp
//
//  Created by Peiqi Zheng on 9/21/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

@protocol SearchFilterDelegate <NSObject>

-(void) filterSelectionDone:(NSDictionary *)filters;

@end

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Filter *filter;
@property (nonatomic, assign) id<SearchFilterDelegate> myDelegate;

@end
