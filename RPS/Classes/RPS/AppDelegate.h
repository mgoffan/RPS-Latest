//
//  AppDelegate.h
//  RPS
//
//  Created by Martin Goffan on 10/27/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "MediaPlayer/MediaPlayer.h"
#import "Constants.h"
#import "ASIFormDataRequest.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, MFMessageComposeViewControllerDelegate, ASIHTTPRequestDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    MPMoviePlayerController *moviePlayer;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *viewController;

- (void)shareTo:(kSharer)type;

@end
