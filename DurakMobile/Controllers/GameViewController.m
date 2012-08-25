//
//  GameViewController.m
//  DurakMobile
//
//  Created by Alexander Chernyshev on 24/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "GameViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "Model.h"
#import "Card.h"
#import "CardView.h"
#import "GameViewController+ComputerGameLogic.h"
#import "GameViewController+PlayerGameLogic.h"

@implementation GameViewController

#pragma mark - Actions
- (IBAction)gameButtonAction:(id)sender
{
    if(_gameState == GameStateComputer) {
        [self showMessage:@"GameStateChange Player Take all center cards"];
    }
    else if(_gameState == GameStatePlayer) {
        _gameState = GameStateComputer;
        [_gameButton setTitle:@"Beru" forState:UIControlStateNormal];
        [self showMessage:@"GameStateChange Player don't have cards anymore"];
    }
    else {
        NSAssert(NO,@"Wrong Game State in change method!");
    }
}

#pragma mark - Custom Alerts
- (void)showMessage:(NSString *)message
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideMessage) object:nil];
    if(_messageView) {
        //[_messageView removeFromSuperview];
        //_messageView = nil;
        UILabel *lable = (UILabel *)[_messageView.subviews objectAtIndex:0];
        NSString *extendedMessage = [lable.text stringByAppendingFormat:@"\n%@",message];
        CGSize size = [extendedMessage sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:CGSizeMake(280, 1000)];
        lable.text = extendedMessage;
        [UIView animateWithDuration:0.25 animations:^{
            _messageView.frame = CGRectMake(20, 90, 280, size.height);
            lable.frame = _messageView.bounds;
        }];
    }
    else {
        CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:CGSizeMake(280, 1000)];
        _messageView = [[UIView alloc]initWithFrame:CGRectMake(20, -size.height, 280, size.height)];
        _messageView.backgroundColor = [UIColor blueColor];
        _messageView.alpha = 0.7;
        _messageView.layer.cornerRadius = 5.0;
        _messageView.layer.masksToBounds = YES;

        UILabel *label = [[UILabel alloc]initWithFrame:_messageView.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:12.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = message;
        [_messageView addSubview:label];

        [self.view addSubview:_messageView];

        [UIView animateWithDuration:0.5 animations:^{
            _messageView.frame = CGRectMake(20, 90, 280, size.height);
        }];
    }
    [self performSelector:@selector(hideMessage) withObject:nil afterDelay:3.0];
}

- (void)hideMessage
{
    [UIView animateWithDuration:0.5 
                     animations:^{
                         _messageView.alpha = 0;
                     } 
                     completion:^(BOOL flag){
                         [_messageView removeFromSuperview];
                         _messageView = nil;
                     }
     ];
}


#pragma mark - lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[Model shared]startNewGame];
    _centerCardViews = [[NSMutableArray alloc]init];
    _playerCardViews = [[NSMutableArray alloc]init];
    _computerCardViews = [[NSMutableArray alloc]init];
    [self createDeck];
    [self createPlayerCards];
    [self createComputerCards];
    _gameState = arc4random() % 2;
    if(_gameState == GameStatePlayer) {
        [self showMessage:@"GameStatePlayer"];
        [_gameButton setTitle:@"Hvatit" forState:UIControlStateNormal];
    }
    else if(_gameState == GameStateComputer) {
        [self showMessage:@"GameStateComputer"];
        [_gameButton setTitle:@"Beru" forState:UIControlStateNormal];
        [self computerMove];
    }
    else {
        NSAssert(NO,@"Wrong GameState in view didLoad");
    }
}

#pragma mark - animations methods
- (void)createDeck
{
    Model *m = [Model shared];
    _deck = [[NSMutableArray alloc]initWithCapacity:m.numberOfCardsInDeck];
    CGPoint center = CGPointMake(200, self.view.center.y - 35);
    CardView *cardView = [[CardView alloc]initWithCard:m.trumpCard];
    cardView.frame = CGRectMake(center.x, center.y, 50, 70);
    cardView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view addSubview:cardView];
    [_deck addObject:cardView];
    
    for( NSUInteger i = 1; i < m.numberOfCardsInDeck; i++) {
        CGPoint center = CGPointMake(240, self.view.center.y - 35);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(center.x, center.y, 50, 70)];
        imageView.backgroundColor = [UIColor greenColor];

        [self.view addSubview:imageView];
        [_deck addObject:imageView];
    }
}

#pragma common game methods
- (void)changeGameState
{
    if(_gameState == GameStateComputer) {
        _gameState = GameStatePlayer;
        [_gameButton setTitle:@"Hvatit" forState:UIControlStateNormal];
        [self showMessage:@"GameStateChange Computer don't have cards anymore"];
    }
    else if(_gameState == GameStatePlayer) {
        [self showMessage:@"GameStateChange Computer Take all center cards"];
    }
    else {
        NSAssert(NO,@"Wrong Game State in change method!");
    }
}
@end
