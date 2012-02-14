//
//  FlipsideViewController.h
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalizedStrings.h"

@protocol RPSSettingsControllerDelegate;

@class RPSMainController;

@interface RPSSettingsController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate> {
	id <RPSSettingsControllerDelegate> delegate;
    UINavigationItem *navItem;
    RPSMainController *mainController;
}

@property (nonatomic, assign) id <RPSSettingsControllerDelegate> delegate;
@property (nonatomic, retain) RPSMainController *mainController;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
@property (nonatomic, retain) IBOutlet UISwitch *soundToggle;
@property (nonatomic, retain) IBOutlet UITextField *multiName;

- (IBAction)pointsChanged:(id)sender;
- (IBAction)soundOnOff:(UISwitch *)sender;


@end


@protocol RPSSettingsControllerDelegate
- (void)flipsideViewControllerDidFinish:(RPSSettingsController *)controller;
@end

