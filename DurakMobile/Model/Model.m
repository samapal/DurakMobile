//
//  Model.m
//  DurakMobile
//
//  Created by Alexander Chernyshev on 24/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "Model.h"

//static Model *m;


@implementation Model
/*@synthesize numberOfCardsInDeck = _numberOfCardsInDeck;
@synthesize trumpCard = _trumpCard;
@synthesize centerCards = _centerCardsValues;
@synthesize playerCards = _playerCards;
@synthesize computerCards = _computerCards;

#pragma mark singleton method
+ (Model *)shared
{
    if(!m) {
        m = [[Model alloc]init];
    }
    return m;
}

#pragma mark - initialization
- (id)init
{
    self = [super init];
    if(self) {
        self.numberOfCardsInDeck = 36;
        _numberOfCardsInMast = 9;
        
        _remainingMasts = [[NSMutableArray alloc]initWithCapacity:4];
        _remainingMastsValues = [[NSMutableDictionary alloc]initWithCapacity:4];
        [self resetRemainingCardData];
        
        self.centerCards = [NSMutableArray array];     
        self.playerCards = [NSMutableArray array];
        self.computerCards = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 


- (void)startNewGame
{
    [self resetRemainingCardData];
    self.trumpCard = [self randomCard];
    [_playerCards removeAllObjects];
    [_computerCards removeAllObjects];
    [self addCardsToPlayer:6];
    [self addCardsToComputer:6];
}

#pragma mark - Player Logic
- (void)addCardsToPlayer:(NSInteger)numberOfCards
{
    for (NSUInteger i = 0; i < numberOfCards; i++) {
        Card *card = [self randomCard];
        [_playerCards addObject:card];
    }
}

#pragma mark - Computer Logic
- (void)addCardsToComputer:(NSInteger)numberOfCards
{
    for (NSUInteger i = 0; i < numberOfCards; i++) {
        Card *card = [self randomCard];
        [_computerCards addObject:card];
    }
}*/
@end
