//
//  AppDelegate.m
//  RPS
//
//  Created by Martin Goffan on 10/27/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "RootViewController.h"
#import "RPSMenu.h"

#import "MGNotification.h"

#import "SHK.h"
#import "SHKItem.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "SHKMail.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) startMovie
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Manos-ipad" ofType:@"m4v"]];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    moviePlayer.shouldAutoplay = YES;
    moviePlayer.repeatMode = MPMovieRepeatModeOne;
    
    moviePlayer.view.frame = (iPad) ? CGRectMake(-130, 90, 1024, 768) : CGRectMake(-80, 90, 480, 320);
    moviePlayer.view.transform = CGAffineTransformMakeScale(0.5, 1.8);
    [viewController.view  addSubview:moviePlayer.view];
    [viewController.view  sendSubviewToBack:moviePlayer.view];
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGBA8	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	
	// make the OpenGLView a child of the view controller
//	[viewController setView:glView];
    [viewController.view addSubview:glView];
    
    glView.opaque = NO;
    
    
    [self startMovie];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
    
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [RPSMenu scene]];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"sS"];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:3 forKey:@"reachablePoints"];
        [defaults setBool:YES forKey:@"soundOnOff"];
        [defaults setBool:YES forKey:@"firstLaunch"];
        
        [defaults synchronize];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"menuLaunch"];
    
    CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

- (void)shareTo:(kSharer)type
{
    switch (type) {
        case kSharerTwitter:
            [SHKTwitter shareText:[@"#RPS-App @mgoffan " stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"sS"]]];
            break;
        case kSharerFacebook:
            [SHKFacebook shareText:[[NSUserDefaults standardUserDefaults] objectForKey:@"sS"]];
            break;
        case kSharerSMS:
            ;
            MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = [[NSUserDefaults standardUserDefaults] objectForKey:@"sS"];
                controller.messageComposeDelegate = self;
                [viewController presentModalViewController:controller animated:YES];
            }    
            break;
        case kSharerMail:
            [SHKMail shareText:[[NSUserDefaults standardUserDefaults] objectForKey:@"sS"]];
        case kHighscore:
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"multiName"] isEqualToString:@""]) {
                
                NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"multiName"];
                NSString *score = [NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"score"]];
                
                NSURL *url = [NSURL URLWithString:@"http://www.rps-app.comze.com/scripts.php"];
                
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                [request addPostValue:name forKey:@"name"];
                [request addPostValue:score forKey:@"score"];
                
                CGSize vCF = [viewController view].frame.size;
                
                CGRect frame = (!iPad) ? CGRectMake(vCF.width / 2 - 80, vCF.height / 2 - 120, 160, 160) : CGRectMake(vCF.width / 2 - 80, vCF.height / 2 - 220, 160, 160);
                
                MGNotification *notif = [[MGNotification alloc] initWithFrame:frame];
                
                [viewController.view addSubview:notif];
                [request setCompletionBlock:^{
                    
                    [notif setNotif:@"Submitted"];
                    
                    [UIView animateWithDuration:0.75 animations:^(void) {
                        notif.alpha = 1.0f;
                        notif.transform = CGAffineTransformMakeScale((iPad) ? 1.5 : 1.2, 1.2);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 delay:1.3 options:UIViewAnimationCurveEaseInOut animations:^(void) {
                            notif.transform = CGAffineTransformMakeScale(0.1, 0.1);
                            notif.alpha = 0.0f;
                        } completion:^(BOOL finished) {
                            [notif release];
                        }];
                    }];
                    
                }];
                [request setFailedBlock:^{
                    [notif setNotif:@"Failed"];
                    
                    [UIView animateWithDuration:0.75 animations:^(void) {
                        notif.alpha = 1.0f;
                        notif.transform = CGAffineTransformMakeScale((iPad) ? 1.5 : 1.2, 1.2);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 delay:1.3 options:UIViewAnimationCurveEaseInOut animations:^(void) {
                            notif.transform = CGAffineTransformMakeScale(0.1, 0.1);
                            notif.alpha = 0.0f;
                        } completion:^(BOOL finished) {
                            [notif release];
                        }];
                    }];
                }];
                
                [request startAsynchronous];
            }
            else {
                
            }
        default:
            break;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [viewController dismissModalViewControllerAnimated:YES];
    
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"Sent...");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Failed");
        default:
            break;
    }
}

@end
