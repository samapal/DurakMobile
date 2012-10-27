//
//  GameViewController+ComputerGameLogic.m
//  DurakMobile
//
//  Created by Alexander Chernyshev on 25/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "GameViewController+ComputerGameLogic.h"

#import <QuartzCore/QuartzCore.h>

#import "Model.h"
#import "Card.h"
#import "CardView.h"

@implementation GameViewController (ComputerGameLogic)

/*- (BOOL)haveViewForCard:(Card *)card
{
    BOOL have = NO;
    for(NSUInteger i = 0; i < _computerCardViews.count && !have; i++) {
        CardView *view = [_computerCardViews objectAtIndex:i];
        have = ([view.card isEqual:card]);
    }
    return have;
}*/

- (void)layoutComputerCards
{
    float width = (_computerCardViews.count - 2) * 10 + (_computerCardViews.count - 1) * 20 + 30 * 2;
    _computerScrollView.contentSize = CGSizeMake(width, _computerScrollView.bounds.size.height);
    float originX = MAX((_computerScrollView.bounds.size.width - width) / 2, 0);
    
    for (NSInteger i = 0; i < _computerCardViews.count; i++) {
        CardView *view = [_computerCardViews objectAtIndex:i];
        [UIView animateWithDuration:0.25 animations:^{
            view.frame = CGRectMake(originX + 30 * i, 0, 50, 70);
        }];
    }
}

- (void)computerTakesAllCenterCard
{
    for (CardView *cardView in _centerCardViews){
        cardView.layer.borderColor = [UIColor greenColor].CGColor;
        cardView.layer.borderWidth = 1.0;
        [cardView removeFromSuperview];
        [_computerScrollView addSubview:cardView];
        [_computerCardViews addObject:cardView];
    }
    [_centerCardViews removeAllObjects];
    [self layoutComputerCards];
}

- (void)addCardsToComputer:(NSUInteger)numberOfCards
{
    for (NSUInteger i = 0; i < numberOfCards; i++) {
        NSUInteger index = arc4random() % _deck.count;
        CardView *cardView = [_deck objectAtIndex:index];
        cardView.layer.borderColor = [UIColor greenColor].CGColor;
        cardView.layer.borderWidth = 1.0;
        [_computerScrollView addSubview:cardView];
        [_computerCardViews addObject:cardView];
        [_deck removeObjectAtIndex:index];
    }
    [self layoutComputerCards];
}

- (void)computerTakeTrump
{
    [_trumpCardView removeFromSuperview];
    _trumpCardView.layer.borderColor = [UIColor greenColor].CGColor;
    _trumpCardView.layer.borderWidth = 1.0;
    [_computerScrollView addSubview:_trumpCardView];
    [_computerCardViews addObject:_trumpCardView];
    _trumpCardView.transform = CGAffineTransformIdentity;
}


- (CardView *)cardViewWithMinCardFromArray:(NSArray *)array
{
    CardView *minCardView = [array objectAtIndex:0];
    for(NSInteger i = 1; i < array.count; i++) {
        CardView *view = [array objectAtIndex:i];
        if(minCardView.card.value > view.card.value) {
            minCardView = view;
        }
    }
    return minCardView;
}

- (BOOL)findComputerCardForCard:(Card *)card;
{
    NSMutableArray *properCardViews = [NSMutableArray array];
    NSMutableArray *trumps = [NSMutableArray array];
    CardMast trumpMast = _trumpCardView.card.mast;
    for(CardView *cardView in _computerCardViews) {
        if((cardView.card.mast == card.mast) && (cardView.card.value > card.value)) {
            [properCardViews addObject:cardView];
        }
        else if(cardView.card.mast == trumpMast && card.mast !=  trumpMast){
            [trumps addObject:cardView];
        }
    }
    CardView *minCardView = nil;
    if(properCardViews.count) {
        minCardView = [self cardViewWithMinCardFromArray:properCardViews];
    }
    else {
        if(trumps.count) {
            minCardView = [self cardViewWithMinCardFromArray:trumps];
        }
    }
    
    if(minCardView)  {      
        [self computerMoveWithCardView:minCardView];
        return YES;
    }
    else {
        [self showMessage:@"Nechem Bit!!!!!!!!!!!!!! FUCK! FUCK! FUCK! FUCK! FUCK! FUCK!"];
        return NO;
    }
}

- (void)computerMoveWithCardView:(CardView *)cardView {
    [_computerCardViews removeObject:cardView];
    
    [_centerCardViews addObject:cardView];
    
    [cardView removeFromSuperview];
    [self.view addSubview:cardView];
    float originX = _computerScrollView.frame.origin.x + cardView.frame.origin.x - _computerScrollView.contentOffset.x;
    cardView.frame = CGRectMake(originX, 10, 50, 70);
    
    NSInteger count = _centerCardViews.count / 2 + _centerCardViews.count % 2;
    CGRect frame = CGRectMake(-20 + 30 * count + 5 * (count - 1), 180, 30, 45);
    [UIView animateWithDuration:0.25 
                     animations:^{
                         cardView.frame = frame;
                     } 
     ];
    
    [self layoutComputerCards];
}

- (BOOL)canMoveWithCard:(Card *)card
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

- (BOOL)computerMove
{
    CardMast trumpMast = _trumpCardView.card.mast;
    NSMutableArray *properCardsView = [NSMutableArray array];
    for(CardView *view in _computerCardViews) {
        if([self canMoveWithCard:view.card] && view.card.mast != trumpMast) {
            [properCardsView addObject:view];
        }
    }
    if(properCardsView.count) {
        CardView *minCardView = [self cardViewWithMinCardFromArray:properCardsView];
        [self computerMoveWithCardView:minCardView];
        return YES;
    }
    else {
        if(!_centerCardViews.count) {
            CardView *minCardView = [self cardViewWithMinCardFromArray:_computerCardViews];
            [self computerMoveWithCardView:minCardView];
            return YES;
        }
        else {
            [self showMessage:@"Nechem hodit!!!!!!"];
            return NO;
        }
    }
}
@end
