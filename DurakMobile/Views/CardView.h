//
//  CardView.h
//  DurakMobile
//
//  Created by Alexander Chernyshev on 24/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Card;
@class CardView;

@protocol CardViewDelegate <NSObject>
- (void)didSelectCardView:(CardView *)cardview;
@end

@interface CardView : UIView
{
    UIImageView * _cardImageView;
    __weak id<CardViewDelegate> _delegate;
}
@property (nonatomic, strong) Card *card;
@property (nonatomic, weak) id<CardViewDelegate>delegate;

- (id)initWithCard:(Card *)card;
@end
