//
//  ViewController.m
//  WildKingdom
//
//  Created by Josef Hilbert on 23.01.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "ViewController.h"
#import "FlickrPhotoCell.h"
#define kFlickrAPIKey @"12b21e49e93ed585d6e2bd20bea9f41a"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate, UITabBarDelegate>
{
    __weak IBOutlet UICollectionView *collectionView;
    NSArray *flickrPhotos;
    NSDictionary *flickrPhoto;
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchString = @"lion";
    [self getFlickrImages];
    
    NSLog(@"View Did Load - instance %@", self);
 //   [self.tabBarController setViewControllers:@[self, self, self]];
    


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
 }

- (void)getFlickrImages
{
    NSLog(@"search string identified as ... %@", _searchString);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=10&page=1&format=json&nojsoncallback=1", @"12b21e49e93ed585d6e2bd20bea9f41a", _searchString]];
    
    NSLog(@"Did Select item - instance of self %@", self);
    NSLog(@"URL %@", url);
    NSLog(@"search string %@", _searchString);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
         NSLog(@"BLOCK - instance of self %@", self);
         NSLog(@"Connection error %@", connectionError);
         flickrPhotos = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError][@"photos"][@"photo"];
         NSLog(@"JSON error %@", connectionError);
         
         NSLog(@"Flickr photos %@", flickrPhoto);
         [NSThread sleepForTimeInterval:2.0f];
         NSLog(@"Flickr photos %@", flickrPhoto);
         
         [collectionView reloadData];
     }
     ];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    _searchString = @"";
    _searchString = item.title;
    
    [self getFlickrImages];
  

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
 
    FlickrPhotoCell *photoCell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    flickrPhoto = flickrPhotos[indexPath.row];
    
    NSLog(@"IndexPath.row %ld", (long)indexPath.row);
    
    NSString *url = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg",flickrPhoto[@"farm"], flickrPhoto[@"server"], flickrPhoto[@"id"], flickrPhoto[@"secret"]];
    
 // model of http:   http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
    NSLog(@"%@", url);
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    CGSize size=CGSizeMake(photoCell.imageView.bounds.size.width, photoCell.imageView.bounds.size.height);
    
    //set the width and height
    
    UIImage *resizedImage = [self resizeImage:image imageSize:size];
    
    photoCell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    photoCell.imageView.clipsToBounds = NO;
    photoCell.imageView.image = resizedImage;
    return photoCell;
    
}

-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return flickrPhotos.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
