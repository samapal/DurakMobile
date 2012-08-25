//
//  Card.h
//  DurakMobile
//
//  Created by Alexander Chernyshev on 24/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CardMastBubi = 0,
    CardMastChervi,
    CardMastKresti,
    CardMastPiki
}CardMast;

@interface Card : NSObject
@property (nonatomic, assign) CardMast      mast;
@property (nonatomic, assign) NSUInteger    value;
@property (nonatomic, strong) UIImage *     image;

- (id)initWithMast:(CardMast)mast andValue:(NSUInteger)value;
@end
