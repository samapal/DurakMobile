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

/*- (BOOL)haveViewForCard:(Card *)card
{
    BOOL have = NO;
    for(NSUInteger i = 0; i < _playerCardViews.count && !have; i++) {
        CardView *view = [_playerCardViews objectAtIndex:i];
        have = ([view.card isEqual:card]);
    }
    return have;
}*/

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


- (void)addCardsToPlayer:(NSUInteger)numberOfCards
{
    for (NSUInteger i = 0; i < numberOfCards; i++) {
        NSUInteger index = arc4random() % _deck.count;
        CardView *cardView = [_deck objectAtIndex:index];
        cardView.delegate = self;
        cardView.layer.borderColor = [UIColor redColor].CGColor;
        cardView.layer.borderWidth = 1.0;
        [_playerScrollView addSubview:cardView];
        [_playerCardViews addObject:cardView];
        [_deck removeObjectAtIndex:index];
    }
    [self layoutPlayerCards];
}

- (void)playerTakesAllCenterCard
{
    for (CardView *cardView in _centerCardViews) {
        cardView.delegate = self;
        cardView.layer.borderColor = [UIColor redColor].CGColor;
        cardView.layer.borderWidth = 1.0;
        [cardView removeFromSuperview];
        [_playerScrollView addSubview:cardView];
        [_playerCardViews addObject:cardView];
    }
    [_centerCardViews removeAllObjects];
    [self layoutPlayerCards];
}

- (void)playerTakeTrump
{
    [_trumpCardView removeFromSuperview];
    _trumpCardView.delegate = self;
    _trumpCardView.layer.borderColor = [UIColor redColor].CGColor;
    _trumpCardView.layer.borderWidth = 1.0;
    [_playerScrollView addSubview:_trumpCardView];
    [_playerCardViews addObject:_trumpCardView];
    _trumpCardView.transform = CGAffineTransformIdentity;
}

- (BOOL)canAddCard:(Card *)card
{
    if(!_centerCardViews.count) {
        return YES;
    }
    else {
        BOOL can = NO;
        for (NSInteger  i = 0; i < _centerCardViews.count && !can; i++) {
            CardView *view = [_centerCardViews objectAtIndex:i];
            Card *centerCard = view.card;
            can = (centerCard.value == card.value);
        }
        return can;
    }
}

- (void)playerMoveWithCardView:(CardView *)cardview
{
    [_playerCardViews removeObject:cardview];
    cardview.delegate = nil;
    
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
    if(_gameState == GameStatePlayer) {        
        if([self canAddCard:cardview.card]) {
            [self playerMoveWithCardView:cardview];
            if(![self findComputerCardForCard:cardview.card]) {
                [self changeGameState];
            }
        }
    }
    else {
        CardView *view = [_centerCardViews lastObject];
        Card *computerCard = view.card;
        CardMast trumpMast = _trumpCardView.card.mast;
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
