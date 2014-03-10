//
//  OtherArtworkViewController.m
//  WildKingdomActualGame
//
//  Created by Siddharth Sukumar on 1/26/14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "OtherArtworkViewController.h"
#import "FlickrPhotoCell.h"


@interface OtherArtworkViewController () <UICollectionViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    
    

    IBOutlet UICollectionView *collectionView;
    NSDictionary *dictionaryWithAllThePhotos;
    NSArray *photos;
    NSDictionary *valuesForEachPhoto;
    CGRect interscapeOrientationLevel;
    UICollectionViewFlowLayout *flowLayout;

    
    
}

@end

@implementation OtherArtworkViewController
@synthesize stringWithTheUserID;



- (void)viewDidLoad
{
    [super viewDidLoad];
    interscapeOrientationLevel = collectionView.frame;
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(150, 150);
    collectionView.allowsSelection = YES;
    [collectionView setCollectionViewLayout:flowLayout animated:YES];
    
    [self getFlickrImages];
}


- (void) getFlickrImages {
    
    NSURL *urlForPlaceInfo = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.people.getPhotos&api_key=%@&user_id=%@&per_page=10&page=1&format=json&nojsoncallback=1", @"f186dbdada57742024786fda63e67e89",stringWithTheUserID]];
    
    
    NSLog(@"urlForPlaceInfo = %@", urlForPlaceInfo);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlForPlaceInfo];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
          NSLog(@"Connection error %@", connectionError);
         dictionaryWithAllThePhotos = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
         photos = dictionaryWithAllThePhotos[@"photos"][@"photo"];
         NSLog(@"photo= %@", photos);
         
         
         [collectionView reloadData];
         
     }
     
     ];

    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cV cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FlickrPhotoCell *photoCell = [cV dequeueReusableCellWithReuseIdentifier:@"SecondFlickrCell" forIndexPath:indexPath];
    
 //   photoCell.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"adium.png"]];
    
    
    valuesForEachPhoto= photos[indexPath.row];
     NSLog(@"photo= %@", photos);
    
     NSLog(@"Single photo= %@", valuesForEachPhoto);
    
    
    NSString *url = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_q.jpg",valuesForEachPhoto[@"farm"], valuesForEachPhoto[@"server"], valuesForEachPhoto[@"id"], valuesForEachPhoto[@"secret"]];
    NSLog(@"url = %@", url);
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
       photoCell.imageView = [[UIImageView alloc]initWithImage:image];
    [photoCell.contentView addSubview: photoCell.imageView];

    
    return photoCell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 0, 5);
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    if(fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake(150, 150);
        
    } else {
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //       flowLayout.itemSize = CGSizeMake(170, 170);
        
        
        
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return photos.count;
}


@end
