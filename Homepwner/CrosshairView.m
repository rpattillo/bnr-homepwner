//
//  CrosshairView.m
//  Homepwner
//
//  Created by Ricky Pattillo on 12/28/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import "CrosshairView.h"

@implementation CrosshairView

- (instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
      self.backgroundColor = [UIColor clearColor];
   }
   
   return self;
}


- (void)drawRect:(CGRect)rect
{
   CGRect bounds = self.bounds;
   
   CGPoint horizontalLeft = CGPointMake(bounds.origin.x, bounds.size.height / 2.0);
   CGPoint horizontalRight = CGPointMake(bounds.size.width, bounds.size.height / 2.0);
   CGPoint verticalTop = CGPointMake(bounds.size.width / 2.0, bounds.origin.y);
   CGPoint verticalBottom = CGPointMake(bounds.size.width / 2.0, bounds.size.height);
   
   UIBezierPath *path = [[UIBezierPath alloc] init];
   path.lineWidth = 2.0;
   
   [path moveToPoint:horizontalLeft];
   [path addLineToPoint:horizontalRight];
   
   [path moveToPoint:verticalTop];
   [path addLineToPoint:verticalBottom];
   
   [[UIColor whiteColor] setStroke];
   [path stroke];
}


@end
