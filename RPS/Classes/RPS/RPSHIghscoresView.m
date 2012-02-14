//
//  HIghscoresWebView.m
//  RPS
//
//  Created by Martin Goffan on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RPSHighscoresView.h"
#import "Constants.h"
#import "RPSMenu.h"

@implementation RPSHighscoresView

- (void)backButtonTouch {
    [self removeFromSuperview];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInB transitionWithDuration:1.0 scene:[RPSMenu scene]]];
    [self resignFirstResponder];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        webView = [[UIWebView alloc] initWithFrame:self.frame];
        [self addSubview:webView];
        
        webView.delegate = self;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.rps-app.comze.com"]];
        [webView loadRequest:request];
        
        actIndView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [actIndView startAnimating];
        
        CGSize winSize = self.frame.size;
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(winSize.width / 2 - 30, winSize.height - 60, 60, 60);
        
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        
        [webView addSubview:backButton];
    }
    
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[MGNotification aNotification] hideWithCompletion:^(BOOL f){}];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [[MGNotification aNotification] title:loadin
                                 activity:YES
                               completion:^(BOOL f) {}
                                     hide:kNoHide
                           hideCompletion:^(BOOL f) {}
                             animDuration:0.3];
}

@end
