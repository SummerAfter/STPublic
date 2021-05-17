//
//  STEmptyView.h
//  STPublic
//
//  Created by Showtime on 2021/5/10.
//

#import <UIKit/UIKit.h>


@interface STEmptyView : UIView

@property(nonatomic, strong) UIImageView *imageView; //基本图片
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UILabel *subLabel;
@property(nonatomic, strong) UIButton *button;


/**
 设置图片，文本和按钮
 */
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
          button:(UIButton *)button;

/**
 设置图片
 */
- (void)setImage:(UIImage *)image;

/**
 设置文本
 */
- (void)setLabelText:(NSString *)labelText;

/**
 设置图片和文本
 */
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText;

/**
 设置图片和文本及副标题
 */
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
    subLabelText:(NSString *)subText;

/**
 设置图片和文本及副标题
 */
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
    subLabelText:(NSString *)subText
          button:(UIButton *)button;

/**
 设置图片，文本和按钮，以及文本，按钮位置
 */
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
   labelYPadding:(CGFloat)labelPadding
          button:(UIButton *)button
     btnYPadding:(CGFloat)yPadding;


- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
    subLabelText:(NSString *)subText
   labelYPadding:(CGFloat)labelPadding
          button:(UIButton *)btn
     btnYPadding:(CGFloat)btnYPadding;

@end

