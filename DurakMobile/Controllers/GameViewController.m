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
        [self takeCardsFromCenter];
        [self showMessage:@"GameStateChange Player Take all center cards"];
    }
    else if(_gameState == GameStatePlayer) {
        [self addCardsFromTheDeck];
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
- (void)startNewGame
{
    [self resetRemainingCardData];
    [_playerCardViews removeAllObjects];
    [_computerCardViews removeAllObjects];
    [_centerCardViews removeAllObjects];
    [_deck removeAllObjects];
    [self createDeck];
    [self addCardsToPlayer:6];
    [self addCardsToComputer:6];
    
    
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    _remainingMasts = [[NSMutableArray alloc]initWithCapacity:4];
    _remainingMastsValues = [[NSMutableDictionary alloc]initWithCapacity:4];
    _centerCardViews = [[NSMutableArray alloc]init];
    _playerCardViews = [[NSMutableArray alloc]init];
    _computerCardViews = [[NSMutableArray alloc]init];
    _deck = [[NSMutableArray alloc]initWithCapacity: 36];
    
    [self startNewGame];
}

#pragma mark - animations methods
- (void)createDeck
{
    CGPoint center = CGPointMake(200, self.view.center.y - 35);
    _trumpCardView = [[CardView alloc]initWithCard:[self randomCard]];
    _trumpCardView.frame = CGRectMake(center.x, center.y, 50, 70);
    _trumpCardView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view addSubview:_trumpCardView];
    //[_deck addObject:cardView];
    
    for( NSUInteger i = 1; i < 36; i++) {
        CGPoint center = CGPointMake(240, self.view.center.y - 35);
        Card *card = [self randomCard];
        CardView *cardView = [[CardView alloc]initWithCard:card];
        cardView.frame = CGRectMake(center.x, center.y, 50, 70);
        cardView.backgroundColor = [UIColor greenColor];

        [self.view addSubview:cardView];
        [_deck addObject:cardView];
    }
}

#pragma common game methods
- (Card *)randomCard
{
    NSInteger mastIndex = arc4random() % _remainingMasts.count;
    CardMast mast = [[_remainingMasts objectAtIndex:mastIndex] integerValue];
    NSString *key = [NSString stringWithFormat:@"%d",mast];
    NSMutableArray *values = [_remainingMastsValues objectForKey:key];
    NSInteger valueIndex = arc4random() % values.count;
    NSUInteger value = [[values objectAtIndex:valueIndex] integerValue];
    [values removeObjectAtIndex:valueIndex];
    if(!values.count) {
        [_remainingMastsValues removeObjectForKey:key];
        [_remainingMasts removeObjectAtIndex:mastIndex];
    }
    else {
        [_remainingMastsValues setObject:values forKey:key];
    }
    Card *card = [[Card alloc]initWithMast:mast andValue:value];
    return card;
}

- (void)resetRemainingCardData
{
    [_remainingMasts removeAllObjects];
    [_remainingMastsValues removeAllObjects];
    NSNumber *mastNumber = [NSNumber numberWithInteger:CardMastBubi];
    [_remainingMasts addObject:mastNumber];
    NSMutableArray *valuesArray1 = [NSMutableArray arrayWithCapacity:9];
    for (NSUInteger i = 0; i < 9; i++) {
        NSNumber *value = [NSNumber numberWithInteger:6 + i];
        [valuesArray1 addObject:value];
    }
    NSString *key = [NSString stringWithFormat:@"%d",CardMastBubi];
    [_remainingMastsValues setObject:valuesArray1 forKey:key];
    
    mastNumber = [NSNumber numberWithInteger:CardMastPiki];
    [_remainingMasts addObject:mastNumber];
    NSMutableArray *valuesArray2 = [NSMutableArray arrayWithCapacity:9];
    for (NSUInteger i = 0; i < 9; i++) {
        NSNumber *value = [NSNumber numberWithInteger:6 + i];
        [valuesArray2 addObject:value];
    }
    key = [NSString stringWithFormat:@"%d",CardMastPiki];
    [_remainingMastsValues setObject:valuesArray2 forKey:key];
    
    mastNumber = [NSNumber numberWithInteger:CardMastKresti];
    [_remainingMasts addObject:mastNumber];
    NSMutableArray *valuesArray3 = [NSMutableArray arrayWithCapacity:9];
    for (NSUInteger i = 0; i < 9; i++) {
        NSNumber *value = [NSNumber numberWithInteger:6 + i];
        [valuesArray3 addObject:value];
    }
    key = [NSString stringWithFormat:@"%d",CardMastKresti];
    [_remainingMastsValues setObject:valuesArray3 forKey:key];
    
    mastNumber = [NSNumber numberWithInteger:CardMastChervi];
    [_remainingMasts addObject:mastNumber];
    NSMutableArray *valuesArray4 = [NSMutableArray arrayWithCapacity:9];
    for (NSUInteger i = 0; i < 9; i++) {
        NSNumber *value = [NSNumber numberWithInteger:6 + i];
        [valuesArray4 addObject:value];
    }
    key = [NSString stringWithFormat:@"%d",CardMastChervi];
    [_remainingMastsValues setObject:valuesArray4 forKey:key];
}



- (void)changeGameState
{
    if(_gameState == GameStateComputer) {
        [self addCardsFromTheDeck];
        _gameState = GameStatePlayer;
        [_gameButton setTitle:@"Hvatit" forState:UIControlStateNormal];
        [self showMessage:@"GameStateChange Computer don't have cards anymore"];
    }
    else if(_gameState == GameStatePlayer) {
        [self takeCardsFromCenter];
        [self showMessage:@"GameStateChange Computer Take all center cards"];
    }
    else {
        NSAssert(NO,@"Wrong Game State in change method!");
    }
}

- (void)addCardsFromTheDeck
{
    [_centerCardViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_centerCardViews removeAllObjects];
    
    NSUInteger playerCardsNeed = 6 - _playerCardViews.count;
    BOOL isPlayerNeedCards = (playerCardsNeed > 0);
    NSUInteger computerCardsNeed = 6 - _computerCardViews.count;
    BOOL isComputerNeedCards = (computerCardsNeed > 0);
    #warning add My own game logic here
    /*if(_deck.count < (computerCardsNeed + playerCardsNeed)) {
    }*/
    switch (_gameState) {
        case GameStatePlayer: {
            if(isPlayerNeedCards) {
                if(!_deck.count) {
                    //[self playerWin];
                }
                else {
                    if(playerCardsNeed > _deck.count) {
                        [self addCardsToPlayer:_deck.count];
                        [self playerTakeTrump];
                    }
                    else {
                        [self addCardsToPlayer:playerCardsNeed];
                    }
                }
            }
            if(isComputerNeedCards) {
                if(!_deck.count) {
                    //[self computerWin];
                }
                else {
                    if(computerCardsNeed > _deck.count) {
                        [self addCardsToComputer:_deck.count];
                        [self computerTakeTrump];
                    }
                    else {
                        [self addCardsToComputer:computerCardsNeed];
                    }
                }
            }
            [self computerMove];
        }
            break;
        case GameStateComputer: {
            if(isComputerNeedCards) {
                if(!_deck.count) {
                    //[self computerWin];
                }
                else {
                    if(computerCardsNeed > _deck.count) {
                        [self addCardsToComputer:_deck.count];
                        [self computerTakeTrump];
                    }
                    else {
                        [self addCardsToComputer:computerCardsNeed];
                    }
                }
            }
            if(isPlayerNeedCards) {
                if(!_deck.count) {
                    //[self playerWin];
                }
                else {
                    if(playerCardsNeed > _deck.count) {
                        [self addCardsToPlayer:_deck.count];
                        [self playerTakeTrump];
                    }
                    else {
                        [self addCardsToPlayer:playerCardsNeed];
                    }
                }
            }
        }
            break;
            
        default: {
            NSAssert(NO, @"Wrong GameState in addCardsFromTheDeck");
        }
            break;
    }
}

- (void)takeCardsFromCenter
{
    switch (_gameState) {
        case GameStatePlayer: {
            [self computerTakesAllCenterCard];
            NSUInteger playerCardsNeed = 6 - _playerCardViews.count;
            BOOL isPlayerNeedCards = (playerCardsNeed > 0);
            if(isPlayerNeedCards) {
                if(!_deck.count) {
                    //[self playerWin];
                }
                else {
                    if(playerCardsNeed > _deck.count) {
                        [self addCardsToPlayer:_deck.count];
                        [self playerTakeTrump];
                    }
                    else {
                        [self addCardsToPlayer:playerCardsNeed];
                    }
                }
            }
        }
            break;
        case GameStateComputer: {
            [self playerTakesAllCenterCard];
            NSUInteger computerCardsNeed = 6 - _computerCardViews.count;
            BOOL isComputerNeedCards = (computerCardsNeed > 0);
            if(isComputerNeedCards) {
                if(!_deck.count) {
                    //[self computerWin];
                }
                else {
                    if(computerCardsNeed > _deck.count) {
                        [self addCardsToComputer:_deck.count];
                        [self computerTakeTrump];
                    }
                    else {
                        [self addCardsToComputer:computerCardsNeed];
                    }
                }
            }
            [self computerMove];
        }
            break;
            
        default: {
            NSAssert(NO, @"Wrong GameState in addCardsFromTheDeck");
        }
            break;
    }
}

- (void)playerWin
{
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"Player" message:@"WIN!!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [view show];
}

- (void)computerWin
{
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"Computer" message:@"WIN!!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [view show];
}
@end
