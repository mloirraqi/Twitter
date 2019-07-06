//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"



@interface TimelineViewController ()  <ComposeViewControllerDelegate,UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *tweetArray;  //stored by view controller
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TimelineViewController

- (void)getTweets {
    // Get timeline from API network request (STEP 4)
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweetArray = tweets;  //(STEP 6)
            [self.tableView reloadData];  //(STEP 7)
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.tableView reloadData]; //call data source methods again as underlying data (self.movies) may have changed
        [self.refreshControl endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 140;
    self.tableView.dataSource = self; //set data source equal to the view controller (self). once you're scrolling and want to show cells, use self for the data source methods (STEP 3)
    self.tableView.delegate = self; //set delegate equal to the view controller (self)
    
    [self getTweets];
    [self getRefreshControl];
}

    - (void)getRefreshControl {
    //instantiates refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTweets) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0]; //insertSubview is similar to addSubview, but puts the subview at specified index so there's no overlap with other elements. controls where it is in the view hierarchy
}

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//(STEP 9)
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweetArray[indexPath.row];
    
    cell.tweet = tweet;
    cell.nameLabel.text = tweet.user.name;
    cell.usernameLabel.text = tweet.user.screenName;
    cell.tweetContentLabel.text = tweet.text;
    cell.dateLabel.text = tweet.createdAtString;
    cell.favoriteCountLabel.text =  [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%i", tweet.retweetCount];
    NSURL *profilePictureURL = [NSURL URLWithString:tweet.user.profilePictureString];
    [cell.profileImageView setImageWithURL:profilePictureURL];
    cell.delegate = self;
    return cell;
}

//(STEP 8)
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    NSLog(@"tweetArray is %@", self.tweetArray);
    //    NSLog(@"tweetArray is a %@", NSStringFromClass([self.tweetArray class]));
    //    NSLog(@"tweetArray.count is %lu", self.tweetArray.count);
    return self.tweetArray.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Sets as delegate for ComposeTweetController
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
}

- (void)didTweet:(Tweet *)tweet {
        [self.tweetArray addObject:tweet];
        [self.tableView reloadData];
    }


@end
