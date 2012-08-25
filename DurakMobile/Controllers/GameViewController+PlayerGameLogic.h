//
//  GameViewController+PlayerGameLogic.h
//  DurakMobile
//
//  Created by Alexander Chernyshev on 25/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "GameViewController.h"

#import "CardView.h"

@interface GameViewController (PlayerGameLogic) <CardViewDelegate>
- (void)createPlayerCards;
@end
