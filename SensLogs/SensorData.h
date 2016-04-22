//
//  SensorData.h
//  SensLogs
//
//  Created by Mathieu Razafimahazo on 22/04/2016.
//  Copyright © 2016 INRIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SensorData : NSObject
@property(nonatomic, strong) NSMutableArray* accelerationValues;
@property(nonatomic, strong) NSMutableArray* gyroValues;
@property(nonatomic, strong) NSMutableArray* magnetoValues;
@property(nonatomic, strong) NSMutableArray* deviceMotionValues;
@property(nonatomic, assign) NSTimeInterval startTime;
- (void)clear;
- (void)serialize:(void (^)(BOOL finished))handler;

@end
