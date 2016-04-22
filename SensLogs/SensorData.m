//
//  SensorData.m
//  SensLogs
//
//  Created by Mathieu Razafimahazo on 22/04/2016.
//  Copyright © 2016 INRIA. All rights reserved.
//

#import "SensorData.h"
#import <CoreMotion/CoreMotion.h>
#import "NSFileManagerAdditions.h"

@implementation SensorData

- (id) init{
    
    self = [super init];
    
    if (self) {
        _accelerationValues = [[NSMutableArray alloc] init];
        _gyroValues = [[NSMutableArray alloc] init];
        _magnetoValues = [[NSMutableArray alloc] init];
        _deviceMotionValues = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)clear {
    
    [_accelerationValues removeAllObjects];
    [_gyroValues removeAllObjects];
    [_magnetoValues removeAllObjects];
    [_deviceMotionValues removeAllObjects];
}

- (void)serialize:(void (^)(BOOL finished))handler {
    
    NSLog(@"Serializing....");
    
    // Export to application document path
    
    // 1. Create directory that will receive sensors
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy.HH:mm:ss"];
    NSString *datasetDate       = [dateFormat stringFromDate:[NSDate date]];
    NSFileManager *fm           = [NSFileManager defaultManager];
    NSString *datasetFolderPath = [NSString stringWithFormat:@"%@/%@",[NSFileManager appDocumentPath], datasetDate];
    [fm createDirectoryAtPath:datasetFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    // Init all strings
    NSMutableString *accelerationResult      = [[NSMutableString alloc] init];
    NSMutableString *gyroResult              = [[NSMutableString alloc] init];
    NSMutableString *magnetoResult           = [[NSMutableString alloc] init];
    NSMutableString *attitudeResult          = [[NSMutableString alloc] init];
    NSMutableString *calibratedMagnetoResult = [[NSMutableString alloc] init];
    NSString *startTimeResult                = [NSString stringWithFormat:@"[Time]\nBootTime = %.4f",_startTime];
    
    // Set all strings
    
    for(int i=0;i<[_accelerationValues count];i++)
    {
        CMAccelerometerData* accData = [_accelerationValues objectAtIndex:i];
        [accelerationResult appendString:[NSString stringWithFormat:@"%.4f %.4f %.4f %.4f\n", accData.timestamp, accData.acceleration.x, accData.acceleration.y, accData.acceleration.z]];
    }
    
    for(int i=0;i<[_gyroValues count];i++)
    {
        CMGyroData* gyroData = [_gyroValues objectAtIndex:i];
        [gyroResult appendString:[NSString stringWithFormat:@"%.4f %.4f %.4f %.4f\n",gyroData.timestamp,gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z]];
    }
    
    for(int i=0;i<[_magnetoValues count];i++)
    {
        CMMagnetometerData* magnetoData = [_magnetoValues objectAtIndex:i];
        [magnetoResult appendString:[NSString stringWithFormat:@"%.4f %.4f %.4f %.4f\n", magnetoData.timestamp ,magnetoData.magneticField.x, magnetoData.magneticField.y, magnetoData.magneticField.z]];
    }
    
    for(int i=0;i<[_deviceMotionValues count];i++)
    {
        CMDeviceMotion* deviceMotionData = [_deviceMotionValues objectAtIndex:i];
        
        [attitudeResult appendString:[NSString stringWithFormat:@"%.4f %.4f %.4f %.4f %.4f\n", deviceMotionData.timestamp, deviceMotionData.attitude.quaternion.w, deviceMotionData.attitude.quaternion.x, deviceMotionData.attitude.quaternion.y, deviceMotionData.attitude.quaternion.z]];
        
        if (deviceMotionData.magneticField.accuracy != CMMagneticFieldCalibrationAccuracyUncalibrated) {
            [calibratedMagnetoResult appendString:[NSString stringWithFormat:@"%.4f %.4f %.4f %.4f %d\n", deviceMotionData.timestamp, deviceMotionData.magneticField.field.x,  deviceMotionData.magneticField.field.y,  deviceMotionData.magneticField.field.z, deviceMotionData.magneticField.accuracy]];
        }
        
    }
    
    // Write all strings
    [accelerationResult writeToFile:[NSString stringWithFormat:@"%@/accelerometer.txt",datasetFolderPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [gyroResult writeToFile:[NSString stringWithFormat:@"%@/gyroscope.txt",datasetFolderPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [magnetoResult writeToFile:[NSString stringWithFormat:@"%@/magnetometer.txt",datasetFolderPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [attitudeResult writeToFile:[NSString stringWithFormat:@"%@/attitude.txt",datasetFolderPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [calibratedMagnetoResult writeToFile:[NSString stringWithFormat:@"%@/magnetometer-calibrated.txt",datasetFolderPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [startTimeResult writeToFile:[NSString stringWithFormat:@"%@/description.txt",datasetFolderPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Call serialization ending handler
    handler(true);
    
    NSLog(@"End of serialization....");
}


@end
