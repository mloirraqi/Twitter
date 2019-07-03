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


@interface TimelineViewController ()  <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *tweetArray;  //stored by view controller
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
    //    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self; //set data source equal to the view controller (self). once you're scrolling and want to show cells, use self for the data source methods (STEP 3)
    self.tableView.delegate = self; //set delegate equal to the view controller (self)
    
    [self getTweets];
    [self makeRefreshControl];
}

    - (void)makeRefreshControl {
    //instantiates refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTweets) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0]; //insertSubview is similar to addSubview, but puts the subview at specified index so there's no overlap with other elements. controls where it is in the view hierarchy
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//(STEP 9)
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    //    TweetCell *cell = [[TweetCell alloc] init];
    
    Tweet *tweet = self.tweetArray[indexPath.row];
    
    cell.nameLabel.text = tweet.user.name;
    cell.usernameLabel.text = tweet.user.screenName;
    cell.tweetContentLabel.text = tweet.text;
    cell.dateLabel.text = tweet.createdAtString;
    cell.favoriteCountLabel.text =  [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%i", tweet.retweetCount];
    
    NSLog(@"%@ did retweet: %d the user %@.", tweet.retweetedByUser.name, tweet.retweeted, tweet.retweetedByUser.name);
    if (tweet.retweeted) {
      //  cell.retweetNameLabel.text = [NSString stringWithFormat: @"%@ %@", tweet.retweetedByUser.name, @"Retweeted"];
     //   cell.retweetNameLabel.hidden = NO;
        cell.retweetButton.hidden = NO;
    }
    
    else {
   //     cell.retweetNameLabel.hidden = YES;
        cell.retweetButton.hidden = YES;
    }
    
   // [cell.profileImageView setImageWithURL:tweet.user.profileImageURLHTTPS];
    //   NSLog(@"Name: %@. Username: %@. Tweet text: %@", tweet.user.name, tweet.user.screenName, tweet.text);
    
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
}



@end
