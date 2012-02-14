//
//  MenuViewController.h
//  RPS
//
//  Created by Martin Goffan on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <GameKit/GameKit.h>

@class RPSLoginController;
@class RPSMainController;
@class RPSSettingsController;
@class RPSHighscoresView;

@interface RPSMenu : CCLayer <GKPeerPickerControllerDelegate, GKSessionDelegate, UIAlertViewDelegate>
{
    GKSession               *currentSession;
    RPSLoginController      *loginViewController;
    RPSMainController       *mainView;
    RPSSettingsController   *settingsView;
    RPSHighscoresView       *highscoresView;
}

@property (nonatomic, retain) GKSession *currentSession;

@property (nonatomic, retain) RPSLoginController    *loginViewController;
@property (nonatomic, retain) RPSMainController     *mainView;
@property (nonatomic, retain) RPSSettingsController *settingsView;
@property (nonatomic, retain) RPSHighscoresView     *highscoresView;

- (void)setupLogin;

+ (CCScene *)scene;

+ (RPSMenu *)defaultController;

@end

@interface BlankLayer : CCLayer

+ (CCScene *)scene;

@end