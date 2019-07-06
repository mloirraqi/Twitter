//
//  ComposeViewController.m
//  twitter
//
//  Created by mloirraqi on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetTextView.delegate = self;

    // Do any additional setup after loading the view.
}
- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)postTweetButton:(id)sender {
    [[APIManager shared]postStatusWithText:self.tweetTextView.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];  //TimelineView
            [self dismissViewControllerAnimated:true completion:nil];
            // NSLog(@"Compose Tweet Success!");
        }
    }];
}

#pragma mark - setting text view
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int characterLimit = 140;
    NSString *newText = [self.tweetTextView.text stringByReplacingCharactersInRange:range withString:text];
    self.characterCountLabel.text = [NSString stringWithFormat:@"%lu characters typed", (unsigned long)newText.length];
    return newText.length < characterLimit; 
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
