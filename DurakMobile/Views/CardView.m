//
//  CardView.m
//  DurakMobile
//
//  Created by Alexander Chernyshev on 24/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "CardView.h"

#import "Card.h"

@implementation CardView
@synthesize card = _card;
@synthesize delegate = _delegate;

#pragma mark - Actions
- (void)tapActionHandler:(UITapGestureRecognizer *)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectCardView:)]) {
        [_delegate didSelectCardView:self];
    }
}

#pragma mark - initialization
- (id)initWithCard:(Card *)card
{
    self = [super init];
    if(self) {
        self.card = card;
        _cardImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _cardImageView.image = card.image;
        [self addSubview:_cardImageView];
        
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionHandler:)];
        [self addGestureRecognizer:rec];
    }
    return self;
}

#pragma mark - layout methods
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _cardImageView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _cardImageView.frame = self.bounds;
}

@end
