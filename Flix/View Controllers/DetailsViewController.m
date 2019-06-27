//
//  DetailsViewController.m
//  Flix
//
//  Created by yujinkim on 6/26/19.
//  Copyright © 2019 yujinkim. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backDrop;
@property (weak, nonatomic) IBOutlet UIImageView *posterOverlay;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;


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
    
    [self.titleLabel sizeToFit];
    [self.synopsis sizeToFit];

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
