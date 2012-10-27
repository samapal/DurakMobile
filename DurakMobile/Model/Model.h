//
//  Model.h
//  DurakMobile
//
//  Created by Alexander Chernyshev on 24/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Card.h"

@interface Model : NSObject
{
    NSMutableArray *        _remainingMasts;
    NSMutableDictionary   * _remainingMastsValues;
    NSInteger               _numberOfCardsInMast;
    NSInteger               _numberOfCardsInDeck;
}
//@property (nonatomic, assign) NSInteger         numberOfCardsInDeck;
/*@property (nonatomic, assign) Card *            trumpCard;
@property (nonatomic, strong) NSMutableArray *  centerCards;
@property (nonatomic, strong) NSMutableArray *  playerCards;
@property (nonatomic, strong) NSMutableArray *  computerCards;


+ (Model *)shared NS_RETURNS_NOT_RETAINED;
- (void)startNewGame;*/
@end
