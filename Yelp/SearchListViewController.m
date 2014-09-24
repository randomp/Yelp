//
//  SearchListViewController.m
//  Yelp
//
//  Created by Peiqi Zheng on 9/17/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "SearchListViewController.h"
#import "FilterViewController.h"
#import "YelpClient.h"
#import "UIColor+FlatUI.h"
#import "SearchResultCell.h"
#import "TSMessage.h"
#import "MapViewController.h"

NSString * const kYelpConsumerKey = @"0BdugAkJFIzs3LHlfo7_qw";
NSString * const kYelpConsumerSecret = @"D2DObzyBZWxhDbOmqYTjKpCTldE";
NSString * const kYelpToken = @"zJzylJ3R3nVMI-0H8lo8W8Pg7kY7EuMB";
NSString * const kYelpTokenSecret = @"r-hmzpaWVrY_2sY3JfoB4cn_1j0";

@interface SearchListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *searchListTableView;
@property (strong, nonatomic) YelpClient *client;
@property (strong, nonatomic) NSMutableArray *searchResult;
@property (strong, nonatomic) SearchResultCell *prototypeCell;

@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) CLLocation *location;
@property NSInteger offset;

@end

@implementation SearchListViewController{
    BOOL isLoading;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        self.searchResult = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpNavigationBar];
    
    // table view settings
    self.searchListTableView.delegate = self;
    self.searchListTableView.dataSource = self;
    self.searchListTableView.separatorInset = UIEdgeInsetsZero;
    [self.searchListTableView registerNib:[UINib nibWithNibName:@"SearchResultCell" bundle:nil] forCellReuseIdentifier:[SearchResultCell cellIdentifier]];
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
    }
    [self.locationManager startUpdatingLocation];
}

-(void)viewDidAppear:(BOOL)animated {
    NSString *model = [[UIDevice currentDevice] model];
    if ([model isEqualToString:@"iPhone Simulator"]) {
        self.location = [[CLLocation alloc] initWithLatitude:37.7873589 longitude:-122.408227];
    } else {
        self.location = self.locationManager.location;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation {
    self.location = newLocation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchData
{
    [self.client
     searchWithTerm:self.searchTerm
     withFilters:self.filterSelection
     atLocation:self.location
     withOffset:self.offset
     success:^(AFHTTPRequestOperation *operation, id response) {
         if (![[SearchResult searchItemsWithObject:response] isEqualToArray:self.searchResult]) {
             [self.searchResult addObjectsFromArray:[SearchResult searchItemsWithObject:response]];
             self.offset = self.searchResult.count;
             [self.searchListTableView reloadData];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [TSMessage showNotificationInViewController:self title:@"Can not fetch data" subtitle:@"Please check your network and try again." type:TSMessageNotificationTypeError duration:3 canBeDismissedByUser:YES];
     }];
}

- (void)filterSelectionDone:(NSDictionary *)filters {
    self.offset = 0;
    self.filterSelection = filters;
    [self.searchResult removeAllObjects];
    [self fetchData];
}

- (SearchResultCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.searchListTableView dequeueReusableCellWithIdentifier:[SearchResultCell cellIdentifier]];
    }
    return _prototypeCell;
}

#pragma mark - Search Bar methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.searchTerm = searchBar.text;
    [self fetchData];
}

#pragma mark - set up UI
- (void)setUpNavigationBar {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:196.0f/255.0f green:18.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    
    // UISearchBar settings
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.0f)];
    [searchBar sizeToFit];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    // Filter button and Map button
    UIButton *fButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fButton setTitle:@"Filter" forState:UIControlStateNormal];
    [fButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [fButton setBackgroundColor:[UIColor alizarinColor]];
    [fButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [fButton.layer setBorderWidth:0.25f];
    [fButton.layer setCornerRadius:4.0f];
    fButton.frame=CGRectMake(0.0, 100.0, 50.0, 25.0);
    [fButton addTarget:self action:@selector(onClickFilterButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithCustomView:fButton];
    self.navigationItem.leftBarButtonItem = filterButton;
    
    UIButton *mButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mButton setTitle:@"Map" forState:UIControlStateNormal];
    [mButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [mButton setBackgroundColor:[UIColor alizarinColor]];
    [mButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [mButton.layer setBorderWidth:0.25f];
    [mButton.layer setCornerRadius:4.0f];
    mButton.frame=CGRectMake(0.0, 100.0, 50.0, 25.0);
    [mButton addTarget:self action:@selector(onClickMapButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithCustomView:mButton];
    self.navigationItem.rightBarButtonItem = mapButton;
}

#pragma mark - Navigation Click on buttons on navigation bar

- (void)onClickFilterButton {
    FilterViewController *fvc = [[FilterViewController alloc] init];
    fvc.myDelegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onClickMapButton {
    MapViewController *mvc = [[MapViewController alloc] init];
    mvc.location = self.location;
    mvc.searchResults = self.searchResult;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:mvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultCell *cell = (SearchResultCell *) [self.searchListTableView dequeueReusableCellWithIdentifier:[SearchResultCell cellIdentifier] forIndexPath:indexPath];
    if (!cell) {
        cell = [[SearchResultCell alloc] init];
    }
    //cell.searchResult = self.searchResult[indexPath.row];
    [cell setSearchResult:self.searchResult[indexPath.row] withIndex:indexPath.row];
    if (indexPath.row == self.searchResult.count - 1) {
        isLoading = NO; // finishes loading
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.prototypeCell setSearchResult:self.searchResult[indexPath.row] withIndex:indexPath.row];
    [self.prototypeCell layoutIfNeeded];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.searchResult count] - 1) //self.array is the array of items you are displaying
    {
        [self fetchData];
    }
}

@end
