//
//  Constants.h
//  RPS
//
//  Created by Martin Goffan on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef RPS_Constants_h
#define RPS_Constants_h

#define iPad                    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define VIEW_WIDTH              self.view.bounds.size.width
#define VIEW_HEIGHT             self.view.bounds.size.height
#define NOTIFICATION_WIDTH      theNotification.view.frame.size.width
#define NOTIFICATION_HEIGHT     theNotification.view.frame.size.height

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define kOAuthConsumerKey @"nMRjgmX3YSwPePGy8K7qA"
#define kOAuthConsumerSecret @"cg9gO8gU0IRjt74XbOeQX1L0KD8PcrXNNI8tdIxLA"

typedef enum {
    kAnimationDurationShow = 2,
    kAnimationDurationHide = 1
} kAnimationDuration;

typedef enum {
    kElectionRock = 0,
    kElectionPaper = 1,
    kElectionScissors = 2,
    kStatusReady = 3
} kElectionRepresentation;

typedef enum {
    kSinglePlayer = 0,
    kMultiPlayer = 1
} kTypeOption;

typedef enum {
    kAnotherGame,
    kNoGame
} kNewGame;

typedef enum {
    kUIAlertViewShare,
    kUIAlertViewGame,
    kUIAlertViewPlayAgain,
    kUIAlertViewLeaving
} kUIAlertViewType;

typedef enum {
    kSharerFacebook,
    kSharerTwitter,
    kSharerSMS,
    kSharerMail,
    kHighscore
} kSharer;

#endif