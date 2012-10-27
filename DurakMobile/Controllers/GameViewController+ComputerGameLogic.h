//
//  GameViewController+ComputerGameLogic.h
//  DurakMobile
//
//  Created by Alexander Chernyshev on 25/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "GameViewController.h"

@class Card;

@interface GameViewController (ComputerGameLogic)

- (void)addCardsToComputer:(NSUInteger)numberOfCards;
- (void)computerTakesAllCenterCard;
- (void)computerTakeTrump;

- (BOOL)findComputerCardForCard:(Card *)card;
- (BOOL)computerMove;
@end
