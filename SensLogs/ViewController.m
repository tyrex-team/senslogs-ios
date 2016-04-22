//
//  ViewController.m
//  SensLogs
//
//  Created by Mathieu Razafimahazo on 22/04/2016.
//  Copyright © 2016 INRIA. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "SensorData.h"

@interface ViewController (){}
@property (weak, nonatomic) IBOutlet UIView *waitingView;
@property (weak, nonatomic) IBOutlet UISwitch *toggleButton;
@property (nonatomic, strong) CMMotionManager* motionManager;
@property (nonatomic, strong) SensorData* sensorData;
@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _motionManager = [[CMMotionManager alloc] init];
    _sensorData = [[SensorData alloc] init];
}


#pragma mark - UI Actions

- (IBAction)toggleButton:(id)sender {
    
    UISwitch *switchButton = (UISwitch *)sender;
    
    if (switchButton.isOn) {
        
        [self startMotion];
        
        // Update start time with boot time
        _sensorData.startTime = [[NSProcessInfo processInfo] systemUptime];
        
    } else {
        [self stopMotion];
    }
}

#pragma mark - Initiating motion

- (void)startMotion {
    
    // Define queue for handling data
    NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
    
    // For retrieving uncalibrated gyro
    [_motionManager startGyroUpdatesToQueue:mainQueue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        
        if (gyroData != nil)
            [_sensorData.gyroValues addObject:gyroData];
        
    }];
    
    // For retrieving uncalibrated acceleration
    [_motionManager startAccelerometerUpdatesToQueue:mainQueue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        
        if (accelerometerData != nil)
            [_sensorData.accelerationValues addObject:accelerometerData];
    }];
    
    [_motionManager startMagnetometerUpdatesToQueue:mainQueue withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
        
        if (magnetometerData != nil)
            [_sensorData.magnetoValues addObject:magnetometerData];
    }];
    
    // For retrieving: Attitude
    [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXMagneticNorthZVertical toQueue:mainQueue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        
        if (motion !=nil )
            [_sensorData.deviceMotionValues addObject:motion];
    }];
}

    
- (void)stopMotion {
    
    // Stop all sensors
    [_motionManager stopGyroUpdates];
    [_motionManager stopAccelerometerUpdates];
    [_motionManager stopMagnetometerUpdates];
    [_motionManager stopDeviceMotionUpdates];
    
    // Serialize sensors
    
    self.waitingView.hidden = false;
    self.toggleButton.enabled = false;
    
    [_sensorData serialize:^(BOOL finished) {
        
        self.waitingView.hidden = true;
        self.toggleButton.enabled = true;
    }];
    
    // Clear sensor values
    [_sensorData clear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
