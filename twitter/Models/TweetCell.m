//
//  TweetCell.m
//  
//
//  Created by mloirraqi on 7/2/19.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateSelected];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    [self.tweetFavoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateSelected];
    [self.tweetFavoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
    [self.delegate tweetCell:self didTap:self.tweet.user];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapRetweet:(id)sender {
    
    if (self.tweet.retweeted) {
        self.retweetButton.selected = NO;
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error rewtweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    
    else{
        self.retweetButton.selected = YES;
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}


-(IBAction)didTapFavorite:(id)sender {
    // already favorited
    if (self.tweet.favorited){
        // set button view to grey
        self.tweetFavoriteButton.selected = NO;
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    
    else {
        self.tweetFavoriteButton.selected = YES;
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}

- (void) refreshData
{
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
}




@end
