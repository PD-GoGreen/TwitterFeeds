//
//  MasterViewController.m
//  TwitterFeeds
//
//  Created by Pradnya on 10/15/14.
//  Copyright (c) 2014 Pradnya. All rights reserved.
//

#import "FeedsViewController.h"
#import "STTwitter.h"
#import "Feed.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "FeedTableViewCell.h"

#define DATA_LOAD_COUNT 20
#define PRELOAD_DATA_OFFSET 5

static NSString *const kTwitterKey = @"U8hrXT9O0LQnkap1DA0oJxFxR";
static NSString *const kTwitterSecret = @"aznCIGZwYSVr3QTGAqYIKC0stUvJSDRY3SGIncZ0trfzoriuAk";

static NSString *kCellIdentifier = @"CellIdentifier";

@interface FeedsViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSString *twitterScreenName;
@property (nonatomic, strong) NSMutableArray *feedResults;
@property (nonatomic, strong) NSString *maxID;

@end

@implementation FeedsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *screenNameButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                   target:self
                                                                                   action:@selector(screenNameClicked)];
    
    self.navigationItem.leftBarButtonItem = screenNameButton;
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                   target:self
                                                                                   action:@selector(refreshClicked)];
    
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FeedTableViewCell class])
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:kCellIdentifier];
    
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.view.backgroundColor = [UIColor colorWithRed:(241.0/255.0)
                                                green:(241.0/255.0)
                                                 blue:(241.0/255.0)
                                                alpha:1.0];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(141.0/255.0)
                                                                           green:(194.0/255.0)
                                                                            blue:(255.0/255.0)
                                                                           alpha:1.0];
    self.feedResults = [[NSMutableArray alloc] init];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self reloadContents];
}

- (void)getTweetFeed:(NSString*)feedtext {
    
    Reachability* internetAvailable = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [internetAvailable currentReachabilityStatus];
    
    if (netStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet access not available"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    STTwitterAPI* twitterApi = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:kTwitterKey
                                                               consumerSecret:kTwitterSecret];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.color = [UIColor blackColor];
    spinner.frame = CGRectMake(0,0, 25, 25);
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    [twitterApi verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        
        [twitterApi getUserTimelineWithScreenName:self.twitterScreenName
                                          sinceID:nil
                                            maxID:self.maxID
                                            count:DATA_LOAD_COUNT
                                     successBlock:^(NSArray *statuses) {
                                         
                                         [spinner stopAnimating];
                                         [self handleTwitterResponse:statuses];
                                         
                                     } errorBlock:^(NSError *error) {
                                         
                                        [spinner stopAnimating];
                                        [self showErrorMessage];
                                         
                                     }];
        
    } errorBlock:^(NSError *error) {
        
        [spinner stopAnimating];
        [self showErrorMessage];
        
    }];
}

- (void)handleTwitterResponse:(NSArray*)statuses{
    
    if (statuses == nil && [statuses count] <= 0) {
        [self showErrorMessage];
        return;
    }
    
    for (NSDictionary* dict in statuses){
        Feed *feed = [[Feed alloc] initWithDictionary:dict];
        [self.feedResults addObject:feed];
    }
    
    Feed *lastFeed = [self.feedResults lastObject];
    self.maxID = lastFeed.feedID;
    
    [self.tableView reloadData];
}

- (void)showErrorMessage{

    [[[UIAlertView alloc] initWithTitle:@"Service Error"
                               message:@"Please try again."
                              delegate:nil
                     cancelButtonTitle:@"Okay"
                     otherButtonTitles:nil] show];

}

- (void)screenNameClicked{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please enter Twitter Screen Name"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.text = @"";
    [alertView show];
    
}

- (void)refreshClicked {
    [self reloadContents];
}

- (void)setTitleAndReload:(NSString*)string{
    
    self.twitterScreenName = string;
    self.title = [[NSString stringWithFormat:@"@%@",self.twitterScreenName] uppercaseString];
    [self reloadContents];
}

- (void)reloadContents{
    
    [self.feedResults removeAllObjects];
    [self.tableView reloadData];
    self.maxID = nil;
    [self getTweetFeed:self.twitterScreenName];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    Feed *feed = [self.feedResults objectAtIndex:indexPath.row];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate* originalDate = [dateFormatter dateFromString:feed.createDate];
    dateFormatter.dateFormat = @"MMM-dd-yy";
    
    cell.titleLabel.text = [dateFormatter stringFromDate:originalDate];
    cell.subtitleLabel.text = feed.text;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == ([self.feedResults count] - PRELOAD_DATA_OFFSET)) {
        [self getTweetFeed:self.twitterScreenName];
    }
}

#pragma mark - UIAlertView Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {

        UITextField *textfield = [alertView textFieldAtIndex:0];
        
        if (textfield != nil && [textfield.text length] > 0) {
        
            [self setTitleAndReload:textfield.text];
            
        }
        
    }
}


@end
