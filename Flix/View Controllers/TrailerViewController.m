//
//  TrailerViewController.m
//  Flix
//
//  Created by yujinkim on 6/27/19.
//  Copyright © 2019 yujinkim. All rights reserved.
//

#import "TrailerViewController.h"
#import "MoviesViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "TrailerViewController.h"
#import <WebKit/WebKit.h>

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;


@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *baseRequestURL = @"https://api.themoviedb.org/3/movie/";
    NSString *movieID = self.movie[@"id"];
    NSString *firstRequestURL = [baseRequestURL stringByAppendingFormat:@"%@",movieID];
    NSString *apiKey = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *requestURLString = [firstRequestURL stringByAppendingString:apiKey];
    NSURL *requestURL = [NSURL URLWithString:requestURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"Could not load movies."
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *trailer = dataDictionary[@"results"][0];
            NSString *trailerKey = trailer[@"key"];
            NSString *baseTrailerURL = @"https://www.youtube.com/watch?v=";
            NSString *trailerURLString = [baseTrailerURL stringByAppendingString:trailerKey];
            NSURL *trailerURL = [NSURL URLWithString:trailerURLString];
            NSURLRequest *request = [NSURLRequest requestWithURL:trailerURL
                                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                 timeoutInterval:10.0];
            // Load Request into WebView.
            [self.webView loadRequest:request];
        }
    }];
    [task resume];
}
- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
