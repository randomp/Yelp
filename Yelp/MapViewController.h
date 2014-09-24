//
//  MapViewController.h
//  Yelp
//
//  Created by Peiqi Zheng on 9/23/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSArray *searchResults;

@end
