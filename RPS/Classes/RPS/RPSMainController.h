//
//  MainViewController.h
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RPSSettingsController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import <GameKit/GameKit.h>
#import <Twitter/Twitter.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>

#import "LocalizedStrings.h"
#import "Constants.h"

@class RPSNotificationController;
@class RPSSettingsController;

@interface RPSMainController : UIViewController <RPSSettingsControllerDelegate, GKSessionDelegate, UIAlertViewDelegate> {
    
    GKSession                       *currentSession;
    
	IBOutlet UIImageView            *firstPlayerImageView;
	IBOutlet UIImageView            *COMImageView;
	IBOutlet UISegmentedControl     *segmentControl;
    IBOutlet UILabel                *scoreboard;
    IBOutlet UILabel                *currentResult;
    IBOutlet UILabel                *oponentLabel;
    
	RPSSettingsController           *optionsController;
    RPSNotificationController       *theNotification;
    
    NSArray                         *gameImages;
    
    NSInteger                       playerPoints;
    NSInteger                       iDevicePoints;
    NSInteger                       playerPoints2Share;
    NSInteger                       iDevicePoints2Share;
    
    NSInteger                       reachablePoints;
    
    NSInteger                       opChoice;
    NSInteger                       pChoice;
    NSInteger                       opPoints;
    NSInteger                       opPoints2Share;
    
    BOOL                            opIsReady;
    BOOL                            pIsReady;
    
    BOOL                            gameIsReset;
    BOOL                            userDidWin;
    
    BOOL                            launchFlag;
    
    NSString                        *shareString;
    NSString                        *peerName;
    NSArray                         *pID;
    
    SystemSoundID                   sounds[2];
}

@property (nonatomic, retain) IBOutlet UIImageView          *firstPlayerImageView;
@property (nonatomic, retain) IBOutlet UIImageView          *COMImageView;
@property (nonatomic, retain) IBOutlet UISegmentedControl   *segmentControl;
@property (nonatomic, retain) IBOutlet UILabel              *scoreboard;
@property (nonatomic, retain) IBOutlet UILabel              *currentResult;
@property (nonatomic, retain) IBOutlet UIButton             *shareButton;
@property (nonatomic, retain) IBOutlet UILabel              *oponentLabel;
@property (nonatomic, retain) IBOutlet UIButton             *playButton;

@property (nonatomic, retain) NSArray                       *pID;

@property (nonatomic, retain) RPSSettingsController         *optionsController;
@property (nonatomic, retain) RPSNotificationController     *theNotification;

@property BOOL multiplayer;

- (IBAction)showInfo:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)reShare:(id)sender;
- (void)share;

- (void)setupUserInterface;
- (void)setupNotifications;
- (void)setupGameLogic;

@end