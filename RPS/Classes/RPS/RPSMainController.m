//
//  MainViewController.m
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RPSMainController.h"
#import "RPSNotificationController.h"
#import "RPSLoginController.h"
#import "RPSMenu.h"
#import "AppDelegate.h"
#import "MGNotification.h"

@interface RPSMainController ()
- (void)leave;
@end


@implementation RPSMainController

@synthesize firstPlayerImageView;
@synthesize COMImageView;
@synthesize segmentControl;
@synthesize optionsController;
@synthesize scoreboard;
@synthesize currentResult;
@synthesize theNotification;
@synthesize shareButton;
@synthesize oponentLabel;
@synthesize multiplayer;
@synthesize pID;
@synthesize playButton;

#pragma mark - Some Mehods
///=======================================================================================
///                                  Some Methods
///=======================================================================================

- (void)flush:(id)anObject
{
    [anObject release];
    anObject = nil;
}

- (void)imgVReset
{
    
    [[MGNotification aNotification] title:[NSString stringWithFormat:@"%@\n%@",currentResult.text, scoreboard.text]
                                 activity:NO
                               completion:^(BOOL f) {}
                                     hide:1.2
                           hideCompletion:^(BOOL f){
                               if (self.multiplayer) {
                                   firstPlayerImageView.image = nil;
                                   COMImageView.image         = nil;
                               }
                               playButton.enabled = YES;
                           }
                             animDuration:0.3];
    
    pIsReady  = NO;
    opIsReady = NO;
    
}

//Game methods
#pragma mark -
#pragma mark Processing

///=======================================================================================
///                                  Processing
///=======================================================================================

- (void)reset
{
    playerPoints                = 0;
    iDevicePoints               = 0;
    COMImageView.image          = nil;
    firstPlayerImageView.image  = nil;
    scoreboard.text             = @"0 - 0";
    currentResult.text          = nil;
    userDidWin                  = NO;
    shareButton.enabled         = YES;
    theNotification.myMessage   = nil;
    theNotification.winnerLooserImageView.image = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"gameIsReset"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///=======================================================================================
///                                  Share
///=======================================================================================

- (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

- (void)share
{
    UIAlertView *aView;
    
    if ([self connectedToNetwork]) {
        
        aView = [[UIAlertView alloc] initWithTitle:gameLocalization message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Twitter", @"Facebook", @"SMS", @"Mail", high, nil];
        aView.tag = kUIAlertViewShare;
    }
    else {
        aView = [[UIAlertView alloc] initWithTitle:gameLocalization message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    [aView show];
    [aView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger cancelIndex = [alertView cancelButtonIndex];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    switch (alertView.tag) {
        case kUIAlertViewGame:
            if (buttonIndex == cancelIndex) {
                NSLog(@"game");
                [self showInfo:nil];
            }
            else {
                [currentSession sendData:[@"new" dataUsingEncoding:NSASCIIStringEncoding]
                                 toPeers:self.pID
                            withDataMode:GKSendDataReliable
                                   error:nil];
            }
            break;
        case kUIAlertViewShare:
            if (buttonIndex == cancelIndex) {
                [alertView dismissWithClickedButtonIndex:cancelIndex animated:YES];
            }
            else if (buttonIndex == [alertView firstOtherButtonIndex]) {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")) {
                    
                    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
                    
                    [twitter addImage:[UIImage imageNamed:@"icon_114x114.png"]];
                    [twitter setInitialText:[@"#RPS-App @mgoffan " stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"sS"]]];
                    
                    [[appDelegate viewController] presentModalViewController:twitter animated:YES];
                    
                    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
                    {
                        [[appDelegate viewController] dismissModalViewControllerAnimated:YES];
                        [twitter release];
                    };
                }
                else {
                    [[[CCDirector sharedDirector] openGLView] sendSubviewToBack:self.view];
                    [appDelegate shareTo:kSharerTwitter];
                }
            }
            else if (buttonIndex == [alertView firstOtherButtonIndex] + 1) {
                [[[CCDirector sharedDirector] openGLView] sendSubviewToBack:self.view];
                [appDelegate shareTo:kSharerFacebook];
            }
            else if (buttonIndex == [alertView firstOtherButtonIndex] + 2) {
                [appDelegate shareTo:kSharerSMS];
            }
            else if (buttonIndex == [alertView firstOtherButtonIndex] + 3) {
                [appDelegate shareTo:kSharerMail];
            }
            else if (buttonIndex == [alertView firstOtherButtonIndex] + 4) {
                [appDelegate shareTo:kHighscore];
            }
            break;
        case kUIAlertViewPlayAgain:
            if (buttonIndex == cancelIndex) {
                [currentSession sendData:[@"end" dataUsingEncoding:NSASCIIStringEncoding]
                                 toPeers:self.pID
                            withDataMode:GKSendDataReliable
                                   error:nil];
            }
            else {
                [currentSession sendData:[@"oth" dataUsingEncoding:NSASCIIStringEncoding]
                                 toPeers:self.pID
                            withDataMode:GKSendDataReliable
                                   error:nil];
            }
            break;
        case kUIAlertViewLeaving:
            if (buttonIndex != cancelIndex) {
                [alertView dismissWithClickedButtonIndex:cancelIndex + 1 animated:YES];
            }
            else {
                [self leave];
            }
        default:
            break;
    }
}

- (void)hideNotification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDurationHide];
    
    theNotification.view.frame = CGRectMake(0, -20, NOTIFICATION_WIDTH, NOTIFICATION_WIDTH);
    theNotification.view.alpha = 0.0;
    
    [UIView commitAnimations];
    [self performSelector:@selector(reset)];
}

- (void)presentNotification
{
    
    NSInteger scores = (self.multiplayer) ? playerPoints2Share - opPoints2Share : playerPoints2Share - iDevicePoints2Share;
    
    [[NSUserDefaults standardUserDefaults] setInteger:scores * 100 forKey:@"score"];
    
    if (userDidWin) {
        if (!self.multiplayer) {
            shareString = [NSString stringWithFormat:shareWon, playerPoints2Share, iDevicePoints2Share];
            
            theNotification.myMessage = [NSString stringWithFormat:resultWon, playerPoints2Share, iDevicePoints2Share];
            
            [theNotification image:[UIImage imageNamed:@"trophy.png"]];
        }
        else {
            shareString = [NSString stringWithFormat:shareWon, playerPoints2Share, opPoints2Share];
            
            theNotification.myMessage = [NSString stringWithFormat:resultWon, playerPoints2Share, opPoints2Share];
            
            [theNotification image:[UIImage imageNamed:@"trophy.png"]];
        }
        
    }
    else {
        if (!self.multiplayer) {
            shareString = [NSString stringWithFormat:shareLost, playerPoints2Share, iDevicePoints2Share];
            
            theNotification.myMessage = [NSString stringWithFormat:resultLost, playerPoints2Share, iDevicePoints2Share];
            
            [theNotification image:[UIImage imageNamed:@"lost.png"]];
        }
        else {
            shareString = [NSString stringWithFormat:shareLost, playerPoints2Share, opPoints2Share];
            
            theNotification.myMessage = [NSString stringWithFormat:resultLost, playerPoints2Share, opPoints2Share];
            
            [theNotification image:[UIImage imageNamed:@"lost.png"]];
        }
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:shareString forKey:@"sS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDurationShow];
    
    theNotification.view.alpha = 1.0;
    theNotification.view.center = CGPointMake((VIEW_WIDTH / 2), (VIEW_HEIGHT / 2));
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideNotification) withObject:nil afterDelay:5.0];
}

- (void)userWon
{
    playerPoints++;
    scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
    currentResult.text  = statusWon;
}

- (void)userLost
{
    iDevicePoints++;
    scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
    currentResult.text  = statusLost;
}

- (void)analyzeResults:(NSInteger)user COM:(NSInteger)iDevice
{
    if (user == iDevice) {
        currentResult.text = statusTie;
    }
    else {
        switch (user) {
                
            case kElectionRock:
                
                switch (iDevice) {
                        
                    case kElectionPaper:
                        [self userLost];
                        break;
                        
                    case kElectionScissors:
                        [self userWon];
                        break;
                        
                    default:
                        break;
                }
                break;
                
            case kElectionPaper:
                
                switch (iDevice) {
                        
                    case kElectionRock:
                        [self userWon];
                        break;
                        
                    case kElectionScissors:
                        [self userLost];
                        break;
                    default:
                        
                        break;
                }
                
                break;
                
            case kElectionScissors:
                
                switch (iDevice) {
                        
                    case kElectionRock:
                        [self userLost];
                        break;
                        
                    case kElectionPaper:
                        [self userWon];
                        break;
                        
                    default:
                        break;
                }
                
            default:
                break;
        }
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self play:nil];
}


//View Methods
#pragma mark -
#pragma mark View Methods

///=======================================================================================
///                                  View Methods
///=======================================================================================
- (void)viewDidLoad
{
	[super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLoad"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLoad"];
        
        [self setupGameLogic];
        [self setupNotifications];
        [self setupUserInterface];
        
        gameImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"rock"], [UIImage imageNamed:@"paper"], [UIImage imageNamed:@"scissor"], [UIImage imageNamed:@"ready"],nil];
        
        NSString *booPath = [[NSBundle mainBundle] pathForResource:@"boo" ofType:@"wav"];
        NSString *clappingPath = [[NSBundle mainBundle] pathForResource:@"clapping" ofType:@"wav"];
        CFURLRef booURL = (CFURLRef)[NSURL fileURLWithPath:booPath];
        CFURLRef clappingURL = (CFURLRef)[NSURL fileURLWithPath:clappingPath];
        AudioServicesCreateSystemSoundID(booURL, &sounds[0]);
        AudioServicesCreateSystemSoundID(clappingURL, &sounds[1]);
        
        reachablePoints = [[NSUserDefaults standardUserDefaults] integerForKey:@"reachablePoints"];
        
        COMImageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setOponentLabel:nil];
    [self flush:firstPlayerImageView];
    [self flush:COMImageView];
    [self flush:scoreboard];
    [self flush:currentResult];
    [self flush:optionsController];
    [self flush:theNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
	[self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}

- (void)dealloc
{
    [oponentLabel release];
    [super dealloc];
}

#pragma mark -
#pragma mark Interface

///=======================================================================================
///                                  Interface
///=======================================================================================

- (void)flipsideViewControllerDidFinish:(RPSSettingsController *)controller
{
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)resignFirstResponder {
    return [super resignFirstResponder];
}

- (void)performDisconnection
{
    [currentSession disconnectFromAllPeers];
    [currentSession release];
}

- (void)leave
{
    if (self.multiplayer) {
        [currentSession sendData:[@"end" dataUsingEncoding:NSASCIIStringEncoding]
                         toPeers:self.pID
                    withDataMode:GKSendDataReliable
                           error:nil];
        
        [self performDisconnection];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundOnOff"]) {
            AudioServicesPlaySystemSound(sounds[0]);
        }
    }
    
    [self reset];
    
    [self.view removeFromSuperview];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInB transitionWithDuration:1.0 scene:[RPSMenu scene]]];
    [self resignFirstResponder];
}

- (IBAction)showInfo:(id)sender
{
    UIAlertView *alView = [[UIAlertView alloc] initWithTitle:gameLocalization
                                                     message:@"Are you sure you want to leave the game?"
                                                    delegate:self
                                           cancelButtonTitle:yes
                                           otherButtonTitles:no, nil];
    [alView setTag:kUIAlertViewLeaving];
    [alView show];
}

- (void)firstPlayerImage:(kElectionRepresentation)rep
{
    firstPlayerImageView.image = [gameImages objectAtIndex:rep];
}

- (void)COMImage:(kElectionRepresentation)rep withOptions:(kTypeOption)opt
{
    if (opt == kMultiPlayer) {
        if (!pIsReady) {
            
            COMImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
            COMImageView.image = [gameImages objectAtIndex:kStatusReady];
        }
        else {
            if (playerPoints < 3 || opPoints < 3) {
                
                [self analyzeResults:pChoice COM:opChoice];
                
                shareButton.enabled = YES;
                
                COMImageView.image = [gameImages objectAtIndex:rep];
                COMImageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
                
                if (playerPoints == 3 || opPoints == 3) {
                    shareButton.enabled = NO;
                    
                    playerPoints2Share  = playerPoints;
                    opPoints2Share      = opPoints;
                    
                    userDidWin = (playerPoints > opPoints) ? YES : NO;
                    [self presentNotification];
                    
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundOnOff"]) {
                        AudioServicesPlaySystemSound((userDidWin) ? sounds[1] : sounds[0]);
                    }
                    
                    [currentSession sendData:[@"endGame" dataUsingEncoding:NSASCIIStringEncoding]
                                     toPeers:self.pID
                                withDataMode:GKSendDataReliable
                                       error:nil];
                }
                else {
                    [currentSession sendData:[@"nextTurn" dataUsingEncoding:NSASCIIStringEncoding]
                                     toPeers:self.pID
                                withDataMode:GKSendDataReliable
                                       error:nil];
                }
                
                pIsReady  = NO;
                opIsReady = NO;
            }
        }
    }
    else {
        
        COMImageView.image = [gameImages objectAtIndex:rep];
    }
}

- (IBAction)play:(UIButton *)sender
{
    if (!self.multiplayer) {
        playButton.enabled = NO;
        
        pChoice                 = segmentControl.selectedSegmentIndex;
        NSInteger rnd           = arc4random() % 3;
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"gameIsReset"];
        
        [self firstPlayerImage:pChoice];
        [self COMImage:rnd withOptions:kSinglePlayer];
        
        
        if (playerPoints < reachablePoints || iDevicePoints < reachablePoints) {
            
            [self analyzeResults:pChoice COM:rnd];
            
            if (playerPoints == reachablePoints || iDevicePoints == reachablePoints) {
                shareButton.enabled = NO;
                
                playerPoints2Share = playerPoints;
                iDevicePoints2Share = iDevicePoints;
                
                userDidWin = (playerPoints > iDevicePoints) ? YES : NO;
                [self presentNotification];
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundOnOff"]) {
                    AudioServicesPlaySystemSound((userDidWin) ? sounds[1] : sounds[0]);
                }
            }
            else {
                [self imgVReset];
            }
        }
    }
    else {
        
        playButton.enabled = NO;
        pChoice        = segmentControl.selectedSegmentIndex;
        
        [self firstPlayerImage:pChoice];
        
        [currentSession sendData:[[NSString stringWithFormat:@"T*%d",pChoice] dataUsingEncoding:NSASCIIStringEncoding]
                         toPeers:self.pID
                    withDataMode:GKSendDataReliable
                           error:nil];
        
        pIsReady = YES;
        
        if (opIsReady)
        {
            playButton.enabled = YES;
            
            if (playerPoints < 3 || opPoints < 3) {
                
                [self analyzeResults:pChoice COM:opChoice];
                
                COMImageView.image = [gameImages objectAtIndex:opChoice];
                
                if (playerPoints == 3 || opPoints == 3) {
                    
                    NSLog(@"termino");
                    
                    playButton.enabled = NO;
                    
                    playerPoints2Share  = playerPoints;
                    opPoints2Share      = opPoints;
                    
                    userDidWin = (playerPoints > iDevicePoints) ? YES : NO;
                    [self presentNotification];
                    
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundOnOff"]) {
                        AudioServicesPlaySystemSound((userDidWin) ? sounds[1] : sounds[0]);
                    }
                    
                    [currentSession sendData:[@"endGame" dataUsingEncoding:NSASCIIStringEncoding]
                                     toPeers:self.pID
                                withDataMode:GKSendDataReliable
                                       error:nil];
                }
                else {
                    [currentSession sendData:[@"nextTurn" dataUsingEncoding:NSASCIIStringEncoding]
                                     toPeers:self.pID
                                withDataMode:GKSendDataReliable
                                       error:nil];
                    
                    pIsReady  = NO;
                    opIsReady = NO;
                }
            }
        }
    }
}

- (IBAction)reShare:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sS"] isEqualToString:@""]) {
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:gameLocalization message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alView show];
    }
    else {
        [self share];
    }
}

#pragma mark -
#pragma mark config

///=======================================================================================
///                                  Config
///=======================================================================================

- (void)setupGameLogic
{
    playerPoints    = 0;
    iDevicePoints   = 0;
    
    opPoints        = 0;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"gameIsReset"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setupNotifications
{
    theNotification = (iPad) ? [[RPSNotificationController alloc] initWithNibName:@"Notification-iPad" bundle:[NSBundle mainBundle]] : [[RPSNotificationController alloc] initWithNibName:@"Notification" bundle:[NSBundle mainBundle]];
    
    theNotification.view.frame = CGRectMake(0, -20, NOTIFICATION_WIDTH, NOTIFICATION_WIDTH);
    theNotification.view.alpha = 0.0;
    
    [self.view addSubview:theNotification.view];
}

- (void)setupUserInterface
{
    //Background
    UIImageView *backgroundImage = [[UIImageView alloc] init];
    
    backgroundImage.frame = (iPad) ? CGRectMake(0, 0, 768, 1024) : CGRectMake(0, 0, 320, 480);
    backgroundImage.image = (iPad) ? [UIImage imageNamed:@"Background_iPad"] : [UIImage imageNamed:@"Background"];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [backgroundImage release];
}

- (void)session:(GKSession *)session peer:(NSString *)peer didChangeState:(GKPeerConnectionState)state
{
    
    NSData *data = [[NSString stringWithFormat:@"Name*%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"multiName"]] dataUsingEncoding:NSASCIIStringEncoding];
    
    [session sendData:data
              toPeers:[NSArray arrayWithObject:peer]
         withDataMode:GKSendDataReliable
                error:nil];
    
    currentSession = session;
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peer
{
    NSLog(@"main session request");
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peer withError:(NSError *)error
{
    NSLog(@"main connection failed");
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    NSLog(@"main session failed");
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    NSString *allData = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSArray *allParts = [allData componentsSeparatedByString:@"*"];
    
    NSLog(@"%@",[allParts objectAtIndex:0]);
    
    if ([[allParts objectAtIndex:0] isEqualToString:@"Name"]) {
        peerName = [allParts objectAtIndex:1];
        [self.view setNeedsDisplay];
        [oponentLabel setText:peerName];
        
    }
    else if ([[allParts objectAtIndex:0] isEqualToString:@"T"]) {
        opChoice = [[allParts objectAtIndex:1] integerValue];
        [self COMImage:opChoice withOptions:kMultiPlayer];
        opIsReady = YES;
    }
    else if ([[allParts objectAtIndex:0] isEqualToString:@"nextTurn"]) {
        [self imgVReset];
    }
    else if ([[allParts objectAtIndex:0] isEqualToString:@"endGame"]) {
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:gameLocalization
                                                         message:playAgain
                                                        delegate:self
                                               cancelButtonTitle:no
                                               otherButtonTitles:yes, nil];
        alView.tag = kUIAlertViewGame;
        [alView show];
        [alView release];
    }
    else if ([[allParts objectAtIndex:0] isEqualToString:@"end"]) {
        NSLog(@"end");
        [self showInfo:nil];
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:gameLocalization
                                                         message:quit
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundOnOff"]) {
            AudioServicesPlaySystemSound(sounds[1]);
        }
        
        [alView show];
        [alView release];
    }
    else if ([[allParts objectAtIndex:0] isEqualToString:@"new"]) {
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:gameLocalization
                                                         message:plAg
                                                        delegate:self
                                               cancelButtonTitle:no
                                               otherButtonTitles:yes,nil];
        
        alView.tag = kUIAlertViewPlayAgain;
        [alView show];
        [alView release];
    }
    else if ([[allParts objectAtIndex:0] isEqualToString:@"oth"]) {
        [self reset];
    }
    
    if ([pID count] != 1) {
        [self setPID:[NSArray arrayWithObject:peer]];
    }
    
    [allData release];
}

@end