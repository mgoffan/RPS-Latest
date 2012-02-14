//
//  LoginViewController.h
//  RPS
//
//  Created by Martin Goffan on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPSLoginController : UIViewController {
    UIImageView *loginUp;
    UIImageView *loginDown;
}

@property (nonatomic, retain) IBOutlet UIImageView *loginUp;
@property (nonatomic, retain) IBOutlet UIImageView *loginDown;

@end