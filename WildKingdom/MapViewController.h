//
//  MapViewController.h
//  WildKingdomActualGame
//
//  Created by Siddharth Sukumar on 1/25/14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController

@property float latitude;;
@property float longitude;
@property (nonatomic, strong) NSString *stringWhichHoldsTheUserID;

@end
