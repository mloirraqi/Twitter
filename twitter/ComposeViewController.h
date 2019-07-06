//
//  ComposeViewController.h
//  twitter
//
//  Created by mloirraqi on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"


NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate
- (void)didTweet:(Tweet *)tweet;
@end

@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;


@end

NS_ASSUME_NONNULL_END
