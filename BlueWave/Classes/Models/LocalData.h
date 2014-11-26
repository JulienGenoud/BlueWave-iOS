//
//  LocalData.h
//  BlueWave
//
//  Created by Rémi Hillairet on 29/10/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "BeaconItem.h"

extern NSString * const kBaseURLString;

@interface LocalData : AFHTTPSessionManager

+ (LocalData*)sharedClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)getNewBeaconsWithLocationManager:(CLLocationManager*)locationManager completion:(void (^)(BOOL finished))completion;
- (NSArray*)getAllBeacons;
- (void)displayDataBase;
- (BeaconItem*)findBeaconWithUUID:(NSUUID*)uuid major:(NSNumber*)major minor:(NSNumber*)minor;


@end
