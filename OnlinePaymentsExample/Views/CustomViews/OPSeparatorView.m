//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPSeparatorView.h"

@implementation OPSeparatorView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat textBufferSpace = (self.separatorString != nil) ? 20.0 : 0;
    CGSize drawSize = (self.separatorString != nil) ? [self.separatorString sizeWithAttributes:@{}] : CGSizeMake(0, 0);
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat endX = (self.bounds.size.width/2 - drawSize.width/2) - textBufferSpace;
    CGPoint firstEndPoint = CGPointMake(endX, CGRectGetMidY(self.bounds));
    CGPoint firstStartPoint = CGPointMake(0, CGRectGetMidY(self.bounds));
    CGPoint secondStartPoint = CGPointMake(self.bounds.size.width - endX, CGRectGetMidY(self.bounds));
    CGPoint secondEndPoint = CGPointMake(self.bounds.size.width, CGRectGetMidY(self.bounds));
    [path moveToPoint:firstStartPoint];
    [path addLineToPoint:firstEndPoint];
    [path moveToPoint:secondStartPoint];
    [path addLineToPoint:secondEndPoint];
    [[UIColor darkGrayColor] setStroke];
    [path stroke];
    if (self.separatorString) {
        CGRect drawRect = CGRectMake(firstEndPoint.x + textBufferSpace, CGRectGetMidY(self.bounds) - drawSize.height/2, drawSize.width, drawSize.height);
        [self.separatorString drawInRect:drawRect withAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    }
}


@end
