//
//  HIghscoresWebView.h
//  RPS
//
//  Created by Martin Goffan on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGNotification.h"
#import "LocalizedStrings.h"

@interface RPSHighscoresView : UIView <UIWebViewDelegate> {
    UIWebView *webView;
    
    UIButton *backButton;
    UIActivityIndicatorView *actIndView;
}

@end