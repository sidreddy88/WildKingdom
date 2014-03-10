//
//  FlickrPhotoCell.h
//  WildKingdom
//
//  Created by Josef Hilbert on 23.01.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotoCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property float latitude;
@property float longitude;
@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *urlOfImage;
@property (nonatomic, strong) NSString *titleOfTheImage;
@property (nonatomic, strong) NSString *nameOFThePersonWhoTookTheImage;

@property (strong, nonatomic) IBOutlet UILabel *labelShowingName;
@property (strong, nonatomic) IBOutlet UILabel *labelShowingTitle;
@property (nonatomic, strong) NSIndexPath *indexPathOfTheCell;
@property (strong, nonatomic) IBOutlet UIButton *buttonToShowTheMap;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) IBOutlet UIButton *buttonToFlipBackToOriginalImage;


@end
