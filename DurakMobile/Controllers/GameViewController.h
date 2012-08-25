//
//  GameViewController.h
//  DurakMobile
//
//  Created by Alexander Chernyshev on 24/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    GameStateComputer = 0,
    GameStatePlayer
}GameState;


@interface GameViewController : BaseViewController
{
    NSMutableArray *_deck;
    NSMutableArray *_playerCardViews;
    NSMutableArray *_computerCardViews;
    NSMutableArray *_centerCardViews;
    GameState       _gameState;
    
    
    IBOutlet UIScrollView *_playerScrollView;
    IBOutlet UIScrollView *_computerScrollView;
    IBOutlet UIButton     *_gameButton;
    
    
    UIView *_messageView;
}
- (void)showMessage:(NSString *)message;
- (void)hideMessage;
- (IBAction)gameButtonAction:(id)sender;

- (void)changeGameState;
@end
