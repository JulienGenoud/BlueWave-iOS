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

@property (strong, nonatomic, readonly) NSString *serial;
@property (strong, nonatomic, readonly) NSUUID *uuid;
@property (strong, nonatomic, readonly) NSNumber *majorValue;
@property (strong, nonatomic, readonly) NSNumber *minorValue;
@property (strong, nonatomic, readonly) NSString *notification;
@property (strong, nonatomic, readonly) NSNumber *range;
@property (strong, nonatomic, readonly) NSString *name;
@property (assign, nonatomic) CLLocationAccuracy accuracy;
@property (assign, nonatomic) NSInteger rssi;

- (instancetype)initWithSerial:(NSString*)serial
                            UUID:(NSUUID *)uuid
                           major:(NSNumber*)major
                           minor:(NSNumber*)minor
                    notification:(NSString*)notification
                           range:(NSNumber*)range
                            name:(NSString*)name;

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;

@end
