//
//  MovieCell.h
//  Flix
//
//  Created by yujinkim on 6/26/19.
//  Copyright © 2019 yujinkim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;
@property (weak, nonatomic) IBOutlet UIImageView *poster;

@end

NS_ASSUME_NONNULL_END
