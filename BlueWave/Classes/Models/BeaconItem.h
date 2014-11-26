//
//  BeaconItem.h
//  NotiWave
//
//  Created by Rémi Hillairet on 09/10/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface BeaconItem : NSObject

@property (strong, nonatomic, readonly) NSNumber *beaconID;
@property (strong, nonatomic, readonly) NSUUID *uuid;
@property (strong, nonatomic, readonly) NSNumber *majorValue;
@property (strong, nonatomic, readonly) NSNumber *minorValue;
@property (strong, nonatomic, readonly) NSString *notification;
@property (strong, nonatomic, readonly) NSNumber *range;
@property (assign, nonatomic) NSInteger rssi;

- (instancetype)initWithBeaconID:(NSNumber*)beaconID
                            UUID:(NSUUID *)uuid
                           major:(NSNumber*)major
                           minor:(NSNumber*)minor
                    notification:(NSString*)notification
                           range:(NSNumber*)range;

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;

@end
