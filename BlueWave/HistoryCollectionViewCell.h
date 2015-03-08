//
//  HistoryCollectionViewCell.h
//  BlueWave
//
//  Created by Rémi Hillairet on 02/03/15.
//  Copyright (c) 2015 Rémi Hillairet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconItem.h"

@interface HistoryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) BeaconItem *item;

@end
