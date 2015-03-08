//
//  BeaconItem.m
//  NotiWave
//
//  Created by Rémi Hillairet on 09/10/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import "BeaconItem.h"

@implementation BeaconItem

- (instancetype)initWithSerial:(NSString*)serial
                            UUID:(NSUUID *)uuid
                           major:(NSNumber*)major
                           minor:(NSNumber*)minor
                    notification:(NSString*)notification
                           range:(NSNumber*)range
                            name:(NSString*)name
{
    self = [super init];
    if (self) {
        _serial = serial;
        _uuid = uuid;
        _majorValue = major;
        _minorValue = minor;
        _notification = notification;
        _range = range;
        _name = name;
        self.rssi = 0;
    }
    return self;
}

#pragma mark - NSCoding

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon {
    if ([[beacon.proximityUUID UUIDString] isEqualToString:[self.uuid UUIDString]] &&
        [beacon.major isEqual: self.majorValue] &&
        [beacon.minor isEqual: self.minorValue])
    {
        return YES;
    } else {
        return NO;
    }
}

@end
