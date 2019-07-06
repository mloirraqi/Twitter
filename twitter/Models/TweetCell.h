//
//  TweetCell.h
//  
//
//  Created by mloirraqi on 7/2/19.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TweetCellDelegate;

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetFavoriteButton;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

- (IBAction)didTapUserProfile:(id)sender;
- (IBAction)tweetRetweeted:(id)sender;
- (IBAction)tweetFavorited:(id)sender;

@end

@protocol TweetCellDelegate
- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;

@end

NS_ASSUME_NONNULL_END
