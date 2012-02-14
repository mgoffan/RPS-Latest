//
//  MenuViewController.m
//  RPS
//
//  Created by Martin Goffan on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RPSMenu.h"
#import "LocalizedStrings.h"
#import "RPSLoginController.h"
#import "RPSMainController.h"
#import "RPSHighscoresView.h"
#import "AppDelegate.h"

@implementation RPSMenu

@synthesize loginViewController, mainView, settingsView, highscoresView;
@synthesize currentSession;

static RPSMenu *controller;

- (void)flush:(id)anObject
{
    [anObject release];
    anObject = nil;
}

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	
	RPSMenu *layer = [RPSMenu node];
	
	[scene addChild: layer];
	
	return scene;
}

+ (RPSMenu *)defaultController {
    if (!controller) {
        controller = [RPSMenu new];
    }
    return controller;
}

- (void)addSP {
    mainView.multiplayer = NO;
    
    [[[CCDirector sharedDirector] openGLView] addSubview:mainView.view];
}

- (void)addMP {
    
    mainView.multiplayer = YES;
    [[[CCDirector sharedDirector] openGLView] addSubview:mainView.view];
}

- (void)addH {
    highscoresView = [[RPSHighscoresView alloc] initWithFrame:mainView.view.frame];
    
    [[[CCDirector sharedDirector] openGLView] addSubview:highscoresView];
}

- (void)addS {
    [[[CCDirector sharedDirector] openGLView] addSubview:settingsView.view];
}

- (void)singleP {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipAngular transitionWithDuration:1.0 scene:[BlankLayer scene]]];
    
    [self performSelector:@selector(addSP) withObject:nil afterDelay:1.0];
}

- (void)multiP {
    
    GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"multiName"] == nil) {
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:gameLocalization
                                                         message:setMN
                                                        delegate:self
                                               cancelButtonTitle:cancl
                                               otherButtonTitles:gotoS, nil];
        [alView show];
        [self flush:picker];
        [alView release];
    }
    else {
        [picker show];
    }
}

- (void)highs {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipAngular transitionWithDuration:1.0 scene:[BlankLayer scene]]];
    
    [self performSelector:@selector(addH) withObject:nil afterDelay:1.0];
}

- (void)settngs {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipAngular transitionWithDuration:1.0 scene:[BlankLayer scene]]];
    
    [self performSelector:@selector(addS) withObject:nil afterDelay:1.0];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self settngs];
    }
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"menuLaunch"]) {
            [self setupLogin];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"menuLaunch"];
        }
        
        mainView = (iPad) ? [[RPSMainController alloc] initWithNibName:@"MainView-iPad" bundle:nil] : [[RPSMainController alloc] initWithNibName:@"MainView" bundle:nil];
        settingsView = (iPad) ? [[RPSSettingsController alloc] initWithNibName:@"FlipsideView-iPad" bundle:nil] : [[RPSSettingsController alloc] initWithNibName:@"FlipsideView" bundle:nil];
        
        
        float size = (iPad) ? 72.0f : 48.0f;
        
        NSString *fontName = @"Thonburi-Bold";
        
        CCMenuItemFont *singlePlayer = [CCMenuItemFont itemWithLabel:[CCLabelTTF labelWithString:singlePl fontName:fontName fontSize:size] target:self selector:@selector(singleP)];
        CCMenuItemFont *multiPlayer = [CCMenuItemFont itemWithLabel:[CCLabelTTF labelWithString:multiPl fontName:fontName fontSize:size] target:self selector:@selector(multiP)];
        CCMenuItemFont *highscores = [CCMenuItemFont itemWithLabel:[CCLabelTTF labelWithString:high fontName:fontName fontSize:size] target:self selector:@selector(highs)];
        CCMenuItemFont *settings = [CCMenuItemFont itemWithLabel:[CCLabelTTF labelWithString:sett fontName:fontName fontSize:size] target:self selector:@selector(settngs)];
        
        ccColor3B color = ccYELLOW;
        
        [singlePlayer setColor:color];
        [multiPlayer setColor:color];
        [highscores setColor:color];
        [settings setColor:color];
        
        CCAction *action = [CCRepeatForever actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:1 scale:1.007], [CCScaleTo actionWithDuration:.5 scale:0.99], nil]];
        
        CCMenu *menu = [CCMenu menuWithItems:singlePlayer, multiPlayer, highscores, settings, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
        
        [menu runAction:action];
    }
    
    return self;
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self flush:loginViewController];
}

- (void)setupLogin
{
    loginViewController = (iPad) ? [[RPSLoginController alloc] initWithNibName:@"LoginViewController-iPad" bundle:[NSBundle mainBundle]] : [[RPSLoginController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    
    [[[CCDirector sharedDirector] openGLView] addSubview:loginViewController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelay:2.5];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    
    loginViewController.loginUp.frame = CGRectMake(0,
                                                   -loginViewController.loginUp.frame.size.width,
                                                   loginViewController.loginUp.frame.size.width,
                                                   loginViewController.loginUp.frame.size.height);
    loginViewController.loginDown.frame = CGRectMake(0,
                                                     [[CCDirector sharedDirector] winSize].height + loginViewController.loginDown.frame.size.height,
                                                     loginViewController.loginDown.frame.size.width,
                                                     loginViewController.loginDown.frame.size.height);
    
    loginViewController.view.alpha = 0.0f;
    
    [UIView commitAnimations];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *) session
{
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipAngular transitionWithDuration:1.0 scene:[BlankLayer scene]]];
    
    [self performSelector:@selector(addMP) withObject:nil afterDelay:1.0];
    
    self.currentSession = session;
    session.delegate = mainView;
    [session setDataReceiveHandler:mainView withContext:nil];
    picker.delegate = nil;
    
    [picker dismiss];
    [picker autorelease];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
    [picker autorelease];
}

@end

@implementation BlankLayer

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
	
	BlankLayer *layer = [BlankLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

- (id)init {
    self = [super init];
    
    if (self) {
        
        CCAction *action = [CCFadeOut actionWithDuration:1.0];
        ccColor4B color = ccc4(255, 255, 255, 100);
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLayerColor *layer = [CCLayerColor layerWithColor:color width:winSize.width height:winSize.height];
        [self addChild:layer];
        [layer runAction:action];
    }
    
    return self;
}

@end

