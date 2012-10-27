//
//  UIView+CenterPoint.m
//  DurakMobile
//
//  Created by Alexander Chernyshev on 24/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "UIView+CenterPoint.h"

@implementation UIView (CenterPoint)
- (CGPoint)absoluteCenter
{
    CGPoint center = CGPointMake(self.frame.origin.x + self.frame.size.width / 2.0,
                                 self.frame.origin.y + self.frame.size.height / 2.0);
    return center;
}
@end
