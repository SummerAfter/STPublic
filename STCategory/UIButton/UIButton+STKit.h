//
//  UIButton+STButton.h
//  STPublic
//
//  Created by Showtime on 2021/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TouchedBlock)(NSInteger tag);


typedef NS_ENUM(NSInteger, STImagePosition) {
    STImagePositionLeft = 0,              //图片在左，文字在右，默认
    STImagePositionRight = 1,             //图片在右，文字在左
    STImagePositionTop = 2,               //图片在上，文字在下
    STImagePositionBottom = 3,            //图片在下，文字在上
};

@interface UIButton (STKit)

@property (copy,   nonatomic) NSString *st_title;
@property (strong, nonatomic) UIColor *st_titleColor;
@property (strong, nonatomic) UIFont *st_font;
@property (strong, nonatomic) UIImage *st_image;
@property (nonatomic, assign) UIEdgeInsets touchAreaInsets;
@property (nonatomic, assign) CGFloat forbiddenTime;//是否开启限制连续点击
/**
 实例化按钮对象
 @param title   标题
 @return 实例化对象
 */
- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont Block:(TouchedBlock)block;
/**
 实例化按钮对象
 @param image   图片
 @return 实例化对象
 */
- (instancetype)initWithImgage:(NSString *)image Block:(TouchedBlock)block;

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *  @param spacing 图片和文字的间隔
 */
- (void)st_setImagePosition:(STImagePosition)postion spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
