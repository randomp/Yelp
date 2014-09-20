//
//  SearchListViewController.m
//  Yelp
//
//  Created by Peiqi Zheng on 9/17/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "SearchListViewController.h"
#import "UIColor+FlatUI.h"

@interface SearchListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *searchListTableView;

@end

@implementation SearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.backgroundColor = [UIColor alizarinColor];
    
    // UISearchBar settings
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.0f)];
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    // table view settings
    self.searchListTableView.delegate = self;
    self.searchListTableView.dataSource = self;
    self.searchListTableView.separatorInset = UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
