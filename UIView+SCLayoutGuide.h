//
//  UIView+SCLayoutGuide.h
//  LayoutGuide
//
//  Created by git on 2017/9/29.
//  Copyright © 2017年 git. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface UIView (SCLayoutGuide)

//- (UILayoutGuide*)tp_safeAreaLayoutGuide;
@property(nonatomic,readonly,strong)UILayoutGuide *tp_safeAreaLayoutGuide;
- (MASViewAttribute*(^)(UILayoutGuide *layoutGuide))masonry;

@end
