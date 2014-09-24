//
//  FilterViewController.m
//  Yelp
//
//  Created by Peiqi Zheng on 9/21/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "FilterViewController.h"
#import "UIColor+FlatUI.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

@property NSInteger maxCountCollapsed;
@property (nonatomic, strong) NSArray *filters;
@property (nonatomic, strong) NSMutableDictionary *expanded;
@property (nonatomic, strong) NSMutableDictionary *filterSelection;
@property (nonatomic, strong) NSMutableArray *categorySelection;
@end

@implementation FilterViewController

@synthesize myDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filter = [[Filter alloc] init];
        self.filters = @[@{@"title":@"Most Popular",
                           @"data": @[@{@"name":@"Offering a Deal", @"key": @"deals_filter"}],
                           @"type": @"toggle"
                           },
                         @{@"title": @"Distance",
                           @"data": [Filter getDistanceOptions],
                           @"type": @"single",
                           @"key": @"radius_filter"
                           },
                         @{@"title": @"Sort by",
                           @"data": [Filter getSortOptions],
                           @"type": @"single",
                           @"key": @"sort"
                           },
                         @{@"title": @"Categories",
                           @"data": [Filter getCategories],
                           @"type": @"multiple",
                           @"key": @"category_filter"
                           }
                         ];
        self.expanded = [[NSMutableDictionary alloc] init];
        self.categorySelection = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.title = @"Filter";
    [self setUpNavigationBar];
    self.filterTableView.delegate = self;
    self.filterTableView.dataSource = self;
    self.maxCountCollapsed = 5;
    //self.filter = [[Filter alloc] init];
    [self.filterTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

-(void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    self.filterSelection = [[store objectForKey:@"savedFilters"] mutableCopy];
    
    if (self.filterSelection == nil) {
        self.filterSelection = [NSMutableDictionary dictionary];
    }
    
    if ([self.filterSelection objectForKey:@"category_filter"] != nil) {
        NSString *commaSeparated = [self.filterSelection objectForKey:@"category_filter"];
        NSArray *array = [commaSeparated componentsSeparatedByString:@","];
        self.categorySelection = [NSMutableArray arrayWithArray:array];
    }
    
    [self.filterTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filters.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *filterGroup = self.filters[section];
    if ([self.expanded[@(section)] boolValue]) {
        return ((NSArray *)self.filters[section][@"data"]).count;
    } else if ([filterGroup[@"type"] isEqual: @"multiple"]) {
        return self.maxCountCollapsed;
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor grayColor]];
    header.textLabel.text = [NSString stringWithFormat:@"%@",[self.filters[section][@"title"] uppercaseString]];
    [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    BOOL sectionExpanded = [self.expanded[@(indexPath.section)] boolValue];
    
    NSDictionary *filterGroup = self.filters[indexPath.section];
    NSArray *filterOptions = filterGroup[@"data"];
    NSDictionary *currentRowOption = filterOptions[indexPath.row];
    
    cell.textLabel.text = currentRowOption[@"name"];
    
    if ([filterGroup[@"type"] isEqual: @"toggle"]) {
        // Show toggle button
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        BOOL selected = [self.filterSelection objectForKey:currentRowOption[@"key"]] != nil;
        [switchView setOn:selected animated:NO];
        [switchView addTarget:self
                       action:@selector(toggleChanged:)
             forControlEvents:UIControlEventValueChanged];
    } else if ([filterGroup[@"type"] isEqual: @"multiple"]) {
        // Show checkbox; pretend category is the only multiple option
        if ([self.categorySelection containsObject:currentRowOption[@"value"]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (!sectionExpanded && indexPath.row == (self.maxCountCollapsed - 1)) {
            cell.textLabel.text = @"See All";
        }
    } else if ([filterGroup[@"type"] isEqual: @"single"]) {
        NSString *selectedValue = [self.filterSelection objectForKey:filterGroup[@"key"]];
        if (sectionExpanded) {
            if ([selectedValue isEqual:currentRowOption[@"value"]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            cell.textLabel.text = [self findNameInDictionary:filterOptions withValue:selectedValue];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *filterGroup = self.filters[indexPath.section];
    NSArray *filterOptions = filterGroup[@"data"];
    NSDictionary *currentRowOption = filterOptions[indexPath.row];
    
    BOOL sectionExpanded = [self.expanded[@(indexPath.section)] boolValue];
    BOOL disableCollapse = sectionExpanded && [filterGroup[@"type"] isEqual: @"multiple"];
    
    // Record selection only when it's already expanded
    if (sectionExpanded) {
        if ([filterGroup[@"type"] isEqual: @"single"]) {
            self.filterSelection[filterGroup[@"key"]] = currentRowOption[@"value"];
        } else if ([filterGroup[@"type"] isEqual: @"multiple"]) {
            if ([self.categorySelection containsObject:currentRowOption[@"value"]]) {
                [self.categorySelection removeObject:currentRowOption[@"value"]];
            } else {
                [self.categorySelection addObject:currentRowOption[@"value"]];
            }
        }
    }
    
    if (!disableCollapse) {
        self.expanded[@(indexPath.section)] = @(!sectionExpanded);
    }
    
    [self.filterTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)search {
    // Clean up filter values here:
    // - Pass in a comma separated list of `category_filter`
    // - Remove `radius_filter` if its value is `auto`
    [self.categorySelection removeObject:@""];
    self.filterSelection[@"category_filter"] = [self.categorySelection componentsJoinedByString:@","];
    if ([self.filterSelection[@"radius_filter"] isEqual:@"auto"]) {
        [self.filterSelection removeObjectForKey:@"radius_filter"];
    }
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    [store setObject:self.filterSelection forKey:@"savedFilters"];
    [store synchronize];
    
    if([self.myDelegate respondsToSelector:@selector(filterSelectionDone:)]) {
        [self.myDelegate filterSelectionDone:self.filterSelection];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleChanged:(id)sender {
    BOOL state = [sender isOn];
    if (state) {
        // This works only because there's only one toggle filter.
        // Generalize this later.
        self.filterSelection[@"deals_filter"] = @"true";
    } else {
        [self.filterSelection removeObjectForKey:@"deals_filter"];
    }
}

- (id)findNameInDictionary:(NSArray *)array withValue:(NSString *)value {
    id match = array[0][@"name"];
    for (NSDictionary *item in array) {
        if ([item[@"value"] isEqual:value]) {
            match = item[@"name"];
            break;
        }
    }
    return match;
}

#pragma mark - click navigation button
- (void)onClickCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickSearchButton {
    [self.categorySelection removeObject:@""];
    self.filterSelection[@"category_filter"] = [self.categorySelection componentsJoinedByString:@","];
    if ([self.filterSelection[@"radius_filter"] isEqual:@"auto"]) {
        [self.filterSelection removeObjectForKey:@"radius_filter"];
    }
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    [store setObject:self.filterSelection forKey:@"savedFilters"];
    [store synchronize];
    
    if([self.myDelegate respondsToSelector:@selector(filterSelectionDone:)]) {
        [self.myDelegate filterSelectionDone:self.filterSelection];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - set up UI
- (void)setUpNavigationBar {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:196.0f/255.0f green:18.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    self.navigationItem.title = @"Filter";
    //self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor]};
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // Search button and Cancel button
    UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [cButton setBackgroundColor:[UIColor alizarinColor]];
    [cButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [cButton.layer setBorderWidth:0.25f];
    [cButton.layer setCornerRadius:4.0f];
    cButton.frame=CGRectMake(0.0, 100.0, 50.0, 25.0);
    [cButton addTarget:self action:@selector(onClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithCustomView:cButton];
    self.navigationItem.leftBarButtonItem = filterButton;
    
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sButton setTitle:@"Search" forState:UIControlStateNormal];
    [sButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [sButton setBackgroundColor:[UIColor alizarinColor]];
    [sButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [sButton.layer setBorderWidth:0.25f];
    [sButton.layer setCornerRadius:4.0f];
    sButton.frame=CGRectMake(0.0, 100.0, 50.0, 25.0);
    [sButton addTarget:self action:@selector(onClickSearchButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithCustomView:sButton];
    self.navigationItem.rightBarButtonItem = mapButton;
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
