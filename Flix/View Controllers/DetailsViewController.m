//
//  DetailsViewController.m
//  Flix
//
//  Created by yujinkim on 6/26/19.
//  Copyright © 2019 yujinkim. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MoviesViewController.h"
#import "MoviesGridViewController.h"
#import "TrailerViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backDrop;
@property (weak, nonatomic) IBOutlet UIImageView *posterOverlay;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *posterButton;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Poster image fades in (low resolution image first, then high resolution image)
    NSString *largeURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *smallURLString = @"https://image.tmdb.org/t/p/w200";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullLargeURLString = [largeURLString stringByAppendingString:posterURLString];
    NSString *fullSmallURLString = [smallURLString stringByAppendingString:posterURLString];
    NSURL *urlLarge = [NSURL URLWithString:fullLargeURLString];
    NSURL *urlSmall = [NSURL URLWithString:fullSmallURLString];
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    __weak DetailsViewController *weakSelf = self;
    [self.posterOverlay setImageWithURLRequest:requestSmall
                 placeholderImage:nil
                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                              
                              // smallImageResponse will be nil if the smallImage is already available
                              // in cache (might want to do something smarter in that case).
                              weakSelf.posterOverlay.alpha = 0.0;
                              weakSelf.posterOverlay.image = smallImage;
                              
                              [UIView animateWithDuration:0.3
                                               animations:^{
                                                   
                                                   weakSelf.posterOverlay.alpha = 1.0;
                                                   
                                               } completion:^(BOOL finished) {
                                                   // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                   // per ImageView. This code must be in the completion block.
                                                   [weakSelf.posterOverlay setImageWithURLRequest:requestLarge
                                                                             placeholderImage:smallImage
                                                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                          weakSelf.posterOverlay.image = largeImage;
                                                                                      }
                                                                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                          // do something for the failure condition of the large image request
                                                                                          // possibly setting the ImageView's image to a default image
                                                                                      }];
                                               }];
                          }
                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                              // do something for the failure condition
                              // possibly try to get the large image
                          }];
    
    //Back drop image fades in (low resolution image first, then high resolution image)
    NSString *backDropURLString = self.movie[@"backdrop_path"];
    NSString *largeBackDropURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *smallBackDropURLString = @"https://image.tmdb.org/t/p/w200";
    NSString *fullBackDropLargeURLString = [largeBackDropURLString stringByAppendingString:backDropURLString];
    NSString *fullBackDropSmallURLString = [smallBackDropURLString stringByAppendingString:backDropURLString];
    NSURL *urlBackDropLarge = [NSURL URLWithString:fullBackDropLargeURLString];
    NSURL *urlBackDropSmall = [NSURL URLWithString:fullBackDropSmallURLString];
    NSURLRequest *requestBackDropSmall = [NSURLRequest requestWithURL:urlBackDropSmall];
    NSURLRequest *requestBackDropLarge = [NSURLRequest requestWithURL:urlBackDropLarge];
    
    __weak DetailsViewController *weakSelf2 = self;
    self.backDrop.image = nil;
    [self.backDrop setImageWithURLRequest:requestBackDropSmall
                       placeholderImage:nil
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                                    
                                    // smallImageResponse will be nil if the smallImage is already available
                                    // in cache (might want to do something smarter in that case).
                                    weakSelf2.backDrop.alpha = 0.0;
                                    weakSelf2.backDrop.image = smallImage;
                                    
                                    [UIView animateWithDuration:0.3
                                                     animations:^{
                                                         
                                                         weakSelf2.backDrop.alpha = 1.0;
                                                         
                                                     } completion:^(BOOL finished) {
                                                         // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                         // per ImageView. This code must be in the completion block.
                                                         [weakSelf2.backDrop setImageWithURLRequest:requestBackDropLarge
                                                                                placeholderImage:smallImage
                                                                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                             weakSelf2.backDrop.image = largeImage;
                                                                                         }
                                                                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                             // do something for the failure condition of the large image request
                                                                                             // possibly setting the ImageView's image to a default image
                                                                                         }];
                                                     }];
                                }
                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                    // do something for the failure condition
                                    // possibly try to get the large image
                                }];
    // Set the labels of details view controller
    self.titleLabel.text = self.movie[@"title"];
    self.synopsis.text = self.movie[@"overview"];
    self.dateLabel.text = self.movie[@"release_date"];
    [self.titleLabel sizeToFit];
    [self.synopsis sizeToFit];
    [self.dateLabel sizeToFit];

}
- (IBAction)buttonTriggered:(id)sender {
    //Perform segue when poster button is triggered
    [self performSegueWithIdentifier:@"firstSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movie = self.movie;
}


@end
