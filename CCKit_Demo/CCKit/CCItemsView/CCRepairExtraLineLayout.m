//
//  CCRepairExtraLineLayout.m
//  ComWell
//
//  Created by chencheng on 2018/7/16.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "CCRepairExtraLineLayout.h"

@implementation CCRepairExtraLineLayout

//修复在size计算不为整数时多出来的1像素线
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        NSInteger maximumSpacing = 0;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
}

@end
