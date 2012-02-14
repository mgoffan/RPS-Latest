//
//  MessageNotificationController.m
//  iPhoneXMPP
//
//  Created by Martin Goffan on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RPSNotificationController.h"
#import "RPSMainController.h"

@implementation RPSNotificationController

@synthesize lMessage;
@synthesize winnerLooserImageView;
@synthesize myMessage;
@synthesize shareButton;
@synthesize mainController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        lMessage = [[UILabel alloc] init];
        myMessage = [[NSString alloc] init];
        winnerLooserImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
        [winnerLooserImageView setContentMode:UIViewContentModeScaleToFill];
        RPSMainController *aMainViewController = [[RPSMainController alloc] init];
        self.mainController = aMainViewController;
        [aMainViewController release];
    }
    return self;
}

- (NSString *)message{
    return myMessage;
}

- (void)setMyMessage:(NSString *)myMessages {
    lMessage.text = myMessages;
}

- (void)image:(UIImage *)anImage{
    winnerLooserImageView.image = anImage;
}

- (void)share:(id)sender {
    [self.mainController share];
}

- (void)dealloc {
    [winnerLooserImageView release];
    [lMessage release];
    [myMessage release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
