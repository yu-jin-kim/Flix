//
//  MovieCell.m
//  Flix
//
//  Created by yujinkim on 6/26/19.
//  Copyright © 2019 yujinkim. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    __weak MovieCell *weakSelf = self;
//    [cell.poster setImageWithURLRequest:request placeholderImage:nil
//                                success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
//
//                                    // imageResponse will be nil if the image is cached
//                                    if (imageResponse) {
//                                        NSLog(@"Image was NOT cached, fade in image");
//                                        weakSelf.poster.alpha = 0.0;
//                                        weakSelf.poster.image = image;
//
//                                        //Animate UIImageView back to alpha 1 over 0.3sec
//                                        [UIView animateWithDuration:0.3 animations:^{
//                                            weakSelf.poster.alpha = 1.0;
//                                        }];
//                                    }
//                                    else {
//                                        NSLog(@"Image was cached so just update the image");
//                                        weakSelf.poster.image = image;
//                                    }
//                                }
//                                failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
//                                    // do something for the failure condition
//                                }];
}

@end
