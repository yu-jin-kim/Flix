//
//  MoviesViewController.m
//  Flix
//
//  Created by yujinkim on 6/26/19.
//  Copyright © 2019 yujinkim. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navigationItem.title = @"Now Playing";
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.tintColor = [UIColor colorWithRed:0.2078 green:0.0 blue:0.2275 alpha:1.0];
    
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    shadow.shadowOffset = CGSizeMake(2, 2);
    shadow.shadowBlurRadius = 4;
    navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:22],
                                          NSForegroundColorAttributeName : [UIColor colorWithRed:0.2078 green:0.0 blue:0.2275 alpha:1.0],
                                          NSShadowAttributeName : shadow};
    
    [self.activityIndicator startAnimating];
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:(self) action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}



-(void)fetchMovies{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
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
            
            NSLog(@"%@", dataDictionary);
            self.movies = dataDictionary[@"results"];
            for (NSDictionary *movie in self.movies){
                NSLog(@"%@", movie[@"title"]);
            }
            
            [self.tableView reloadData];

        }
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
    }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsis.text = movie[@"overview"];
    
    //Poster table view images fade in (low resolution image first, then high resolution image)
    NSString *largeURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *smallURLString = @"https://image.tmdb.org/t/p/w200";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullLargeURLString = [largeURLString stringByAppendingString:posterURLString];
    NSString *fullSmallURLString = [smallURLString stringByAppendingString:posterURLString];
    NSURL *urlLarge = [NSURL URLWithString:fullLargeURLString];
    NSURL *urlSmall = [NSURL URLWithString:fullSmallURLString];
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    __weak MovieCell *weakSelf = cell;
    cell.poster.image = nil;
    [cell.poster setImageWithURLRequest:requestSmall
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                                           
                                           // smallImageResponse will be nil if the smallImage is already available
                                           // in cache (might want to do something smarter in that case).
                                           weakSelf.poster.alpha = 0.0;
                                           weakSelf.poster.image = smallImage;
                                           
                                           [UIView animateWithDuration:0.3
                                                            animations:^{
                                                                
                                                                weakSelf.poster.alpha = 1.0;
                                                                
                                                            } completion:^(BOOL finished) {
                                                                // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                                // per ImageView. This code must be in the completion block.
                                                                [weakSelf.poster setImageWithURLRequest:requestLarge
                                                                                              placeholderImage:smallImage
                                                                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                                           weakSelf.poster.image = largeImage;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}


@end
