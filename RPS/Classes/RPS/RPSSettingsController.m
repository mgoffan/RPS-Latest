//
//  FlipsideViewController.m
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RPSSettingsController.h"
#import "RPSMainController.h"
#import "RPSMenu.h"


@implementation RPSSettingsController

@synthesize multiName;
@synthesize delegate, mainController, navItem, segmentedControl, soundToggle;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (void)flipSS {
    [self.view removeFromSuperview];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInB transitionWithDuration:1.0 scene:[RPSMenu scene]]];
}

- (IBAction)pointsChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:((segmentedControl.selectedSegmentIndex * 2) + 1) forKey:@"reachablePoints"];
}
- (IBAction)soundOnOff:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"soundOnOff"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"multiName"];
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)flush:(id)anObject {
    [anObject release];
    anObject = nil;
}

- (void)viewDidUnload {
    [self setMultiName:nil];
    [self flush:delegate];
    [self flush:segmentedControl];
    [self flush:mainController];
    [self flush:navItem];
    [self flush:multiName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(flipSS)];
    self.navItem.leftBarButtonItem = backItem;
    [backItem release];
    
    RPSMainController *aMaincontroller = [[RPSMainController alloc] init];
    mainController = aMaincontroller;
    [aMaincontroller release];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    segmentedControl.selectedSegmentIndex = [defaults integerForKey:@"reachablePoints"] / 2;
    soundToggle.on = [defaults boolForKey:@"soundOnOff"];
    multiName.text = [defaults objectForKey:@"multiName"];
}

- (void)dealloc {
    [super dealloc];
}

@end