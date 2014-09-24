//
//  MapViewController.m
//  Yelp
//
//  Created by Peiqi Zheng on 9/23/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "UIColor+FlatUI.h"
#import "SearchResult.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.location && self.searchResults.count > 0) {
        NSLog(@"has data");
        self.mapView.mapType = MKMapTypeStandard;
        self.mapView.showsUserLocation = YES;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 1609.0, 1609.0);
        [self.mapView setRegion:viewRegion];
        for (SearchResult *searchResult in self.searchResults) {
            CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
            [geoCoder geocodeAddressString:searchResult.address completionHandler:^(NSArray* placemarks, NSError* error){
                if (placemarks && placemarks.count > 0) {
                    CLPlacemark *topResult = [placemarks objectAtIndex:0];
                    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                    
                    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                    point.coordinate = placemark.coordinate;
                    point.title = searchResult.name;
                    [self.mapView addAnnotation:point];
                }
            }];
        }
    }
}

- (void)onClickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - set up UI
- (void)setUpNavigationBar {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:196.0f/255.0f green:18.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    self.navigationItem.title = @"Map";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // Back button
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bButton setTitle:@"Back" forState:UIControlStateNormal];
    [bButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [bButton setBackgroundColor:[UIColor alizarinColor]];
    [bButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [bButton.layer setBorderWidth:0.25f];
    [bButton.layer setCornerRadius:4.0f];
    bButton.frame=CGRectMake(0.0, 100.0, 50.0, 25.0);
    [bButton addTarget:self action:@selector(onClickBackButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithCustomView:bButton];
    self.navigationItem.leftBarButtonItem = filterButton;
}

@end
