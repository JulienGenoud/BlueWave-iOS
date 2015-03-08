//
//  DetailsViewController.h
//  BlueWave
//
//  Created by Rémi Hillairet on 26/11/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconItem.h"

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) BeaconItem *item;

@end
