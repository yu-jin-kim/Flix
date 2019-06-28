//
//  MoviesGridViewController.m
//  Flix
//
//  Created by yujinkim on 6/26/19.
//  Copyright © 2019 yujinkim. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesGridViewController () 
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;
    
    self.navigationItem.title = @"Search";
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.tintColor = [UIColor colorWithRed:0.9686 green:0.902 blue:0 alpha:1.0];
    
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    shadow.shadowOffset = CGSizeMake(2, 2);
    shadow.shadowBlurRadius = 4;
    navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:22],
                                          NSForegroundColorAttributeName : [UIColor colorWithRed:0.9686 green:0.902 blue:0 alpha:1.0],
                                          NSShadowAttributeName : shadow};
    
    [self.activityIndicator startAnimating];
    [self fetchMovies];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:(self) action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:1];
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

            self.movies = dataDictionary[@"results"];
            self.filteredMovies = self.movies;
            [self.collectionView reloadData];
            [self.activityIndicator stopAnimating];
            
        }
    [self.refreshControl endRefreshing];
    }];
    [task resume];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    // self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    NSDictionary *movie = self.filteredMovies[indexPath.item];
    cell.poster.image = nil;
    
    //Poster collection cell images fade in (low resolution image first, then high resolution image)
    NSString *largeURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *smallURLString = @"https://image.tmdb.org/t/p/w200";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullLargeURLString = [largeURLString stringByAppendingString:posterURLString];
    NSString *fullSmallURLString = [smallURLString stringByAppendingString:posterURLString];
    NSURL *urlLarge = [NSURL URLWithString:fullLargeURLString];
    NSURL *urlSmall = [NSURL URLWithString:fullSmallURLString];
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    __weak MovieCollectionCell *weakSelf = cell;
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
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // Search bar function creates a filtered list of movies when text is entered
    if (searchText.length != 0) {
        NSString *substring = [NSString stringWithString:searchText];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", substring];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredMovies);
        
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.collectionView reloadData];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}


@end
