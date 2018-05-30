//
//  UIView+SCLayoutGuide.m
//  LayoutGuide
//
//  Created by git on 2017/9/29.
//  Copyright © 2017年 git. All rights reserved.
//

#import "UIView+SCLayoutGuide.h"
#import <objc/runtime.h>

@implementation UIView (SCLayoutGuide)

- (UILayoutGuide*)tp_safeAreaLayoutGuide{
    if (@available(iOS 11, *))
    {
        return self.safeAreaLayoutGuide;
    }
    else
    {
        id nextResponse = self;
        UIViewController *vc;
        UIWindow *window;
        while (nextResponse) {
            nextResponse = ((UIResponder *)nextResponse).nextResponder;
            if ([nextResponse isKindOfClass:[UIViewController class]])
            {
                vc = (UIViewController*)nextResponse;
                break;
            }
            else if ([nextResponse isKindOfClass:[UIWindow class]])
            {
                window = (UIWindow*)nextResponse;
                break;
            }
        }
            
        UILayoutGuide *tp_safeAreaLayoutGuide = objc_getAssociatedObject(self, "tp_safeAreaLayoutGuide");
        if (!tp_safeAreaLayoutGuide)
        {
            UILayoutGuide *safeAreaLayoutGuide = [[UILayoutGuide alloc] init];
            [self addLayoutGuide:safeAreaLayoutGuide];
            NSLayoutConstraint *safeTop;
            NSLayoutConstraint *safeBottom;
            NSLayoutConstraint *safeLeft;
            NSLayoutConstraint *safeRight;
            if (vc)
            {
                safeTop = [safeAreaLayoutGuide.topAnchor constraintGreaterThanOrEqualToAnchor:vc.topLayoutGuide.bottomAnchor];
                safeBottom = [safeAreaLayoutGuide.bottomAnchor constraintLessThanOrEqualToAnchor:vc.bottomLayoutGuide.topAnchor];
//                safeLeft = [safeAreaLayoutGuide.leftAnchor constraintGreaterThanOrEqualToAnchor:vc.view.leftAnchor];
//                safeRight = [safeAreaLayoutGuide.rightAnchor constraintLessThanOrEqualToAnchor:vc.view.rightAnchor];
            }
            else if (window)
            {
                safeTop = [safeAreaLayoutGuide.topAnchor constraintGreaterThanOrEqualToAnchor:window.topAnchor];
                safeBottom = [safeAreaLayoutGuide.bottomAnchor constraintLessThanOrEqualToAnchor:window.bottomAnchor];
//                safeLeft = [safeAreaLayoutGuide.leftAnchor constraintGreaterThanOrEqualToAnchor:window.leftAnchor];
//                safeRight = [safeAreaLayoutGuide.rightAnchor constraintLessThanOrEqualToAnchor:window.rightAnchor];
            }
            safeTop.priority = safeBottom.priority = safeLeft.priority = safeRight.priority = UILayoutPriorityRequired;
            safeTop.active = safeBottom.active = YES; //= safeLeft.active = safeRight.active = YES;
            
            NSLayoutConstraint *top = [safeAreaLayoutGuide.topAnchor constraintEqualToAnchor:self.topAnchor];
            NSLayoutConstraint *bottom = [safeAreaLayoutGuide.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
            NSLayoutConstraint *left = [safeAreaLayoutGuide.leftAnchor constraintEqualToAnchor:self.leftAnchor];
            NSLayoutConstraint *right = [safeAreaLayoutGuide.rightAnchor constraintEqualToAnchor:self.rightAnchor];
            top.priority = bottom.priority = left.priority = right.priority = UILayoutPriorityDefaultLow;
            top.active = bottom.active = left.active = right.active = YES;
            
            tp_safeAreaLayoutGuide = safeAreaLayoutGuide;
            objc_setAssociatedObject(self, "tp_safeAreaLayoutGuide", safeAreaLayoutGuide, OBJC_ASSOCIATION_RETAIN);
        }
        return tp_safeAreaLayoutGuide;
    }
}

- (MASViewAttribute*(^)(UILayoutGuide *layoutGuide))masonry{
    return ^MASViewAttribute* (UILayoutGuide *layoutGuide){
        return [[MASViewAttribute alloc] initWithView:self item:layoutGuide layoutAttribute:NSLayoutAttributeNotAnAttribute];
    };
}

@end
