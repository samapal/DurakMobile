//
//  Card.m
//  DurakMobile
//
//  Created by Alexander Chernyshev on 24/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "Card.h"

@implementation Card
@synthesize mast =  _mast;
@synthesize value = _value;
@synthesize image = _image;

- (id)initWithMast:(CardMast)mast andValue:(NSUInteger)value
{
    self = [super init];
    if(self) {
        self.mast = mast;
        self.value = value;
        NSString *cardImageName = [NSString stringWithFormat:@"%d_%d.png",mast,value];
        self.image = [UIImage imageNamed:cardImageName];
    }
    return self;
}

@end
