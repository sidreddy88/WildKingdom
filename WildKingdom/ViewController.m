//
//  ViewController.m
//  WildKingdom
//
//  Created by Josef Hilbert on 23.01.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "ViewController.h"
#import "FlickrPhotoCell.h"
#import "MapViewController.h"
#define kFlickrAPIKey @"f186dbdada57742024786fda63e67e89"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate, UITabBarDelegate>
{
    __weak IBOutlet UICollectionView *collectionView;
    NSDictionary *dictionaryFromJson;
    NSDictionary *dictionaryForPlaceInfo;
    NSArray *flickrPhotos;
    NSDictionary *flickrPhoto;
    NSString *stringHoldingThePlacenfo;

    IBOutlet UITabBar *tabBar;
    CGRect interscapeOrientationLevel;
    UICollectionViewFlowLayout *flowLayout;
    
    NSIndexPath *selectedIndexPath;
    
    
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchString = @"lion";
    [self getFlickrImages];
    tabBar.selectedItem = tabBar.items[0];
    interscapeOrientationLevel = collectionView.frame;
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(150, 150);
    collectionView.allowsSelection = YES;
    [collectionView setCollectionViewLayout:flowLayout animated:YES];
//    NSArray *stringOFKeys = [NSArray arrayWithObjects:@1,  @2, @3,@4, @5, @6, @7, @8, @9, @10, nil];
//    NSArray *stringOFValues = [NSArray arrayWithObjects: @0,  @0, @0,@0, @0, @0, @0, @0, @0, @0, nil];
 //   dictionaryToSeeIfTheSameImageWasClickedOnTwice = [NSDictionary dictionaryWithObjects:stringOFValues forKeys:stringOFKeys];
    

}

- (void)getFlickrImages


{
    NSLog(@"search string identified as ... %@", _searchString);
    
    //license=Attribution-NonCommercialLicense = right before format
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&has_geo=yes&sort=relevance&per_page=10&page=1&format=json&nojsoncallback=1", @"f186dbdada57742024786fda63e67e89", _searchString]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
         NSLog(@"BLOCK - instance of self %@", self);
         NSLog(@"Connection error %@", connectionError);
         dictionaryFromJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
         flickrPhotos = dictionaryFromJson[@"photos"][@"photo"];
         NSLog(@"photos = %@", flickrPhotos);
         [collectionView reloadData];
     }
     ];
    
   
}

- (void) getPlaceInfoForThePhoto: (NSString *) info forCell:(FlickrPhotoCell *) cell{
    
    
    
    
    NSURL *urlForPlaceInfo = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.getinfo&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", @"f186dbdada57742024786fda63e67e89", info]];
    NSLog(@"url = %@", urlForPlaceInfo);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlForPlaceInfo];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
         NSLog(@"BLOCK - instance of self %@", self);
         NSLog(@"Connection error %@", connectionError);
         dictionaryForPlaceInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
 
         id valueLatitude = dictionaryForPlaceInfo[@"photo"][@"location"][@"latitude"];
         cell.latitude = [valueLatitude floatValue];
         id valueLongitude = dictionaryForPlaceInfo[@"photo"][@"location"][@"longitude"];
         cell.longitude = [valueLongitude floatValue];
         cell.titleOfTheImage = dictionaryForPlaceInfo[@"photo"][@"title"][@"_content"];
         cell.nameOFThePersonWhoTookTheImage = dictionaryForPlaceInfo[@"photo"][@"owner"][@"realname"];
       
          NSLog(@"url = %f", cell.latitude);
         NSLog(@"url = %f", cell.longitude);
         NSLog(@"url = %@", cell.description);
         
         
         
     }
     
     ];
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(5, 5, 0, 5);
}
 
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    _searchString = @"";
    _searchString = item.title;
    
    [self getFlickrImages];
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

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
 
    FlickrPhotoCell *photoCell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    flickrPhoto = flickrPhotos[indexPath.row];
    
    photoCell.userID = flickrPhoto[@"owner"];
     NSLog(@"photos = %@", flickrPhoto);
    [self getPlaceInfoForThePhoto:flickrPhoto[@"id"] forCell: photoCell];
    

    
//    NSLog(@"IndexPath.row %ld", (long)indexPath.row);
    
    NSString *url = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_q.jpg",flickrPhoto[@"farm"], flickrPhoto[@"server"], flickrPhoto[@"id"], flickrPhoto[@"secret"]];
    NSLog(@"%@", url);
    
    photoCell.urlOfImage = url;
    photoCell.labelShowingName.alpha = 0;
    photoCell.labelShowingTitle.alpha = 0;
    photoCell.buttonToShowTheMap.alpha = 0;
    photoCell.buttonToFlipBackToOriginalImage.alpha = 0;
    photoCell.indexPathOfTheCell = indexPath;
    
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    CGSize size=CGSizeMake(photoCell.imageView.bounds.size.width, photoCell.imageView.bounds.size.height);
    
    //set the width and height
    
    UIImage *resizedImage = [self resizeImage:image imageSize:size];
    
    photoCell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    photoCell.imageView.clipsToBounds = NO;
    photoCell.imageView.image = resizedImage;
    return photoCell;
    
}
- (BOOL)collectionView:(UICollectionView *)cV shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
- (IBAction)flipBackToOriginalImage:(id)sender {
    
    [collectionView deselectItemAtIndexPath:selectedIndexPath animated:YES];
    FlickrPhotoCell *cell = (FlickrPhotoCell *)[collectionView cellForItemAtIndexPath:selectedIndexPath];
    cell.contentView.backgroundColor = [UIColor orangeColor];
    NSLog(@"%@", cell.imageView.image);
    //    [labelDisplayedAtTheBackOfTheCard removeFromSuperview];
    NSLog(@"%@", cell.imageView.image);
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cell.urlOfImage]]];
    UIImageView *imageToBeDisplayed = [[UIImageView alloc]initWithImage:image];
    [cell.contentView addSubview:imageToBeDisplayed];

}
- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndexPath = indexPath;
    
 //   NSLog(@"row = %ld and scetion = %i", (long)indexPath.row, indexPath.section);
    
    FlickrPhotoCell *photoCell = (FlickrPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    photoCell.contentView.backgroundColor = [UIColor redColor];
   
    NSLog(@"%@", photoCell.imageView.image);
    [photoCell.imageView removeFromSuperview];
    photoCell.imageView = nil;

    
    NSLog(@"%@", photoCell.imageView.image);

//    UIImageView *imageViews = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"adium.png"]];
    
    
    
    photoCell.labelShowingName.alpha = 1;
    photoCell.labelShowingTitle.alpha = 1;
    photoCell.buttonToShowTheMap.alpha = 1;
    photoCell.buttonToFlipBackToOriginalImage.alpha = 1;
    photoCell.labelShowingName.text = [@"By: " stringByAppendingString:photoCell.nameOFThePersonWhoTookTheImage];
    photoCell.labelShowingTitle.text = photoCell.titleOfTheImage;
//    [photoCell.contentView addSubview:labelDisplayedAtTheBackOfTheCard];
    
     NSLog(@"%@", photoCell.imageView.image);
    
/*    [cv reloadData];

    NSLog(@"%@", cell.imageView.image);
     NSLog(@"%@", cell.imageView.image);
    
    
   
 
    FlickrPhotoCell *cell = (FlickrPhotoCell *)[collectionView cellForItemAtIndexPath:selectedIndexPath];
    [cv selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];

     */
    


//  [self performSegueWithIdentifier:@"Map View" sender:self];
    
}

- (void)collectionView:(UICollectionView *)cV didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
//     NSLog(@"deselcted row = %ld and scetion = %i", (long)indexPath.row, indexPath.section);
    FlickrPhotoCell *cell = (FlickrPhotoCell *)[cV cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor orangeColor];
    NSLog(@"%@", cell.imageView.image);
//    [labelDisplayedAtTheBackOfTheCard removeFromSuperview];
    NSLog(@"%@", cell.imageView.image);
     UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cell.urlOfImage]]];
    UIImageView *imageToBeDisplayed = [[UIImageView alloc]initWithImage:image];
    [cell.contentView addSubview:imageToBeDisplayed];
//    cell.imageView = imageToBeDisplayed;
    NSLog(@"%@", cell.imageView.image);

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    NSIndexPath *selectedIndexPath = [[collectionView indexPathsForSelectedItems] firstObject];
    
    FlickrPhotoCell *cell = (FlickrPhotoCell *)[collectionView cellForItemAtIndexPath:selectedIndexPath];
                         
  MapViewController *vc = segue.destinationViewController;
   
        vc.latitude = cell.latitude;
        vc.longitude = cell.longitude;
    vc.stringWhichHoldsTheUserID = cell.userID;
    
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
