//
//  SearchListViewController.h
//  Yelp
//
//  Created by Peiqi Zheng on 9/17/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FilterViewController.h"

@interface SearchListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,SearchFilterDelegate, CLLocationManagerDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSDictionary *filterSelection;

@end

