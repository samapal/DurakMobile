//
//  Model.m
//  DurakMobile
//
//  Created by Alexander Chernyshev on 24/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "Model.h"

static Model *m;


@implementation Model
@synthesize numberOfCardsInDeck = _numberOfCardsInDeck;
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
    NSMutableArray *valuesArray1 = [NSMutableArray arrayWithCapacity:_numberOfCardsInMast];
    for (NSUInteger i = 0; i < _numberOfCardsInMast; i++) {
        NSNumber *value = [NSNumber numberWithInteger:6 + i];
        [valuesArray1 addObject:value];
    }
    NSString *key = [NSString stringWithFormat:@"%d",CardMastBubi];
    [_remainingMastsValues setObject:valuesArray1 forKey:key];
    
    mastNumber = [NSNumber numberWithInteger:CardMastPiki];
    [_remainingMasts addObject:mastNumber];
    NSMutableArray *valuesArray2 = [NSMutableArray arrayWithCapacity:_numberOfCardsInMast];
    for (NSUInteger i = 0; i < _numberOfCardsInMast; i++) {
        NSNumber *value = [NSNumber numberWithInteger:6 + i];
        [valuesArray2 addObject:value];
    }
    key = [NSString stringWithFormat:@"%d",CardMastPiki];
    [_remainingMastsValues setObject:valuesArray2 forKey:key];
    
    mastNumber = [NSNumber numberWithInteger:CardMastKresti];
    [_remainingMasts addObject:mastNumber];
    NSMutableArray *valuesArray3 = [NSMutableArray arrayWithCapacity:_numberOfCardsInMast];
    for (NSUInteger i = 0; i < _numberOfCardsInMast; i++) {
        NSNumber *value = [NSNumber numberWithInteger:6 + i];
        [valuesArray3 addObject:value];
    }
    key = [NSString stringWithFormat:@"%d",CardMastKresti];
    [_remainingMastsValues setObject:valuesArray3 forKey:key];
    
    mastNumber = [NSNumber numberWithInteger:CardMastChervi];
    [_remainingMasts addObject:mastNumber];
    NSMutableArray *valuesArray4 = [NSMutableArray arrayWithCapacity:_numberOfCardsInMast];
    for (NSUInteger i = 0; i < _numberOfCardsInMast; i++) {
        NSNumber *value = [NSNumber numberWithInteger:6 + i];
        [valuesArray4 addObject:value];
    }
    key = [NSString stringWithFormat:@"%d",CardMastChervi];
    [_remainingMastsValues setObject:valuesArray4 forKey:key];
}

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
}
@end
