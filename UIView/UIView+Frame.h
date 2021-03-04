//
//  UIView+STKit.h
//  Pods-STPublic_Example
//
//  Created by Showtime on 2021/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (STKit)

@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

@property (nonatomic, readonly) CGFloat screenX;

@property (nonatomic, readonly) CGFloat screenY;

@property (nonatomic, readonly) CGFloat screenViewX;

@property (nonatomic, readonly) CGFloat screenViewY;

@property (nonatomic, readonly) CGRect screenFrame;

@property (nonatomic) CGPoint origin;

@property (nonatomic) CGSize size;

/*
 * UIView上下居中
 */
+ (void)setSubviewCenterOnVertical:(UIView *)subView AtX:(CGFloat)xStart superView:(UIView *)superView;

/*
 * UIView左右居中
 */
+ (void)setSubviewCenterOnHorizontal:(UIView *)subView AtY:(CGFloat)yStart superView:(UIView *)superView;

/*
 * UIView上下左右居中
 */
+ (void)setSubviewOnCenter:(UIView *)subView superView:(UIView *)superView;



@end




NS_ASSUME_NONNULL_END
