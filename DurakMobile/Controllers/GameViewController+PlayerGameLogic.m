//
//  GameViewController+PlayerGameLogic.m
//  DurakMobile
//
//  Created by Alexander Chernyshev on 25/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "GameViewController+PlayerGameLogic.h"

#import <QuartzCore/QuartzCore.h>

#import "Model.h"
#import "Card.h"
#import "CardView.h"
#import "GameViewController+ComputerGameLogic.h"

@implementation GameViewController (PlayerGameLogic)

- (BOOL)haveViewForCard:(Card *)card
{
    BOOL have = NO;
    for(NSUInteger i = 0; i < _playerCardViews.count && !have; i++) {
        CardView *view = [_playerCardViews objectAtIndex:i];
        have = ([view.card isEqual:card]);
    }
    return have;
}

- (void)layoutPlayerCards
{
    float width = (_playerCardViews.count - 2) * 10 + (_playerCardViews.count - 1) * 20 + 30 * 2;
    _playerScrollView.contentSize = CGSizeMake(width, _playerScrollView.bounds.size.height);
    float originX = MAX((_playerScrollView.bounds.size.width - width) / 2, 0);
    
    for (NSInteger i = 0; i < _playerCardViews.count; i++) {
        CardView *view = [_playerCardViews objectAtIndex:i];
        [UIView animateWithDuration:0.25 animations:^{
            view.frame = CGRectMake(originX + 30 * i, 0, 50, 70);
        }];
    }
}

- (void)createPlayerCards
{
    Model *m = [Model shared];
    for (Card *card in m.playerCards) {
        if(![self haveViewForCard:card]) {
            CardView *cardView = [[CardView alloc]initWithCard:card];
            cardView.delegate = self;
            cardView.layer.borderColor = [UIColor blackColor].CGColor;
            cardView.layer.borderWidth = 1.0;
            
            [_playerScrollView addSubview:cardView];
            [_playerCardViews addObject:cardView];
        }
    }
    [self layoutPlayerCards];
}

- (BOOL)canAddCard:(Card *)card
{
    Model *m = [Model shared];
    if(!m.centerCards.count) {
        return YES;
    }
    else {
        BOOL can = NO;
        for (NSInteger  i = 0; i < m.centerCards.count && !can; i++) {
            Card *centerCard = [m.centerCards objectAtIndex:i];
            can = (centerCard.value == card.value);
        }
        return can;
    }
}

- (void)playerMoveWithCardView:(CardView *)cardview
{
    Model *m = [Model shared];
    [m.playerCards removeObject:cardview.card];
    [_playerCardViews removeObject:cardview];
    cardview.delegate = nil;
    
    [m.centerCards addObject:cardview.card];
    [_centerCardViews addObject:cardview];     
    
    [cardview removeFromSuperview];
    [self.view addSubview:cardview];
    float originX = _playerScrollView.frame.origin.x + cardview.frame.origin.x - _playerScrollView.contentOffset.x;
    cardview.frame = CGRectMake(originX, 380, 50, 70);
    
    NSInteger count = _centerCardViews.count / 2 + _centerCardViews.count % 2;
    CGRect frame = CGRectMake(-20 + 30 * count + 5 * (count - 1), 235, 30, 45);
    [UIView animateWithDuration:0.25 
                     animations:^{
                         cardview.frame = frame;
                     } 
     ];
    
    [self layoutPlayerCards];
}

#pragma mark - CardViewDelegate
- (void)didSelectCardView:(CardView *)cardview
{
    Model *m = [Model shared];
    if(_gameState == GameStatePlayer) {        
        if([self canAddCard:cardview.card]) {
            [self playerMoveWithCardView:cardview];
            if(![self findComputerCardForCard:cardview.card]) {
                [self changeGameState];
            }
        }
    }
    else {
        Card *computerCard = [m.centerCards lastObject];
        CardMast trumpMast = m.trumpCard.mast;
        if((cardview.card.mast == computerCard.mast && cardview.card.value > computerCard.value)
           || (cardview.card.mast == trumpMast && computerCard.mast !=  trumpMast)) {
            [self playerMoveWithCardView:cardview];
            if(![self computerMove]) {
                [self changeGameState];
            }
        }
    }
}

@end
