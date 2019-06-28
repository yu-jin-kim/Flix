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

    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterOverlay setImageWithURL:posterURL];
    
    NSString *backDropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackDropURLString = [baseURLString stringByAppendingString:backDropURLString];
    NSURL *backDropURL = [NSURL URLWithString:fullBackDropURLString];
    [self.backDrop setImageWithURL:backDropURL];
    self.titleLabel.text = self.movie[@"title"];
    self.synopsis.text = self.movie[@"overview"];
    self.dateLabel.text = self.movie[@"release_date"];
    
    [self.titleLabel sizeToFit];
    [self.synopsis sizeToFit];
    [self.dateLabel sizeToFit];

}
- (IBAction)buttonTriggered:(id)sender {
    [self performSegueWithIdentifier:@"firstSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movie = self.movie;
}


@end
