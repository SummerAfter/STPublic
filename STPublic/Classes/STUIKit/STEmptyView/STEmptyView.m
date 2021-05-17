//
//  STEmptyView.m
//  STPublic
//
//  Created by Showtime on 2021/5/10.
//

#import "STEmptyView.h"
#import "STCategory.h"
#import "STUtils.h"

const static CGFloat defaultLabelPadding = 20.f;
const static CGFloat defaultButtongPadding = 30.f;

@implementation STEmptyView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self constructSubView];
    }
    return self;
}

- (void)constructSubView{
    //imageView
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.userInteractionEnabled = NO;
    [self addSubview:_imageView];
    
    //label
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.font = [UIFont systemFontOfSize:14];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
    
    _subLabel =  [[UILabel alloc] initWithFrame:CGRectZero];
    _subLabel.font = [UIFont systemFontOfSize:24];
    _subLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_subLabel];
}

/**
 设置图片
 */
- (void)setImage:(UIImage *)image{
    [self setImage:image
         labelText:nil
     labelYPadding:0];
}

/**
 设置文本
 */
- (void)setLabelText:(NSString *)labelText{
    [self setImage:nil
         labelText:labelText
     labelYPadding:0];
}

/**
 设置图片和文本
 */
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText{
    [self setImage:image
         labelText:labelText
     labelYPadding:defaultLabelPadding];
}

/**
 设置图片和文本及副标题
 */
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
    subLabelText:(NSString *)subText {
    [self setImage:image labelText:labelText subLabelText:subText labelYPadding:defaultLabelPadding button:nil btnYPadding:0];
}

/**
 设置图片和文本及副标题
 */
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
    subLabelText:(NSString *)subText
          button:(UIButton *)button {
    [self setImage:image labelText:labelText subLabelText:subText labelYPadding:defaultLabelPadding button:button btnYPadding:defaultButtongPadding];
}

/**
 设置图片和文本，以及文本位置
 */
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
   labelYPadding:(CGFloat)labelPadding {
    [self setImage:image
         labelText:labelText
     labelYPadding:labelPadding
            button:nil
       btnYPadding:0];
}

/**
 设置图片，文本和按钮
 */
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
          button:(UIButton *)button {
    [self setImage:image
         labelText:labelText
     labelYPadding:defaultLabelPadding
            button:button
       btnYPadding:defaultButtongPadding];
}

/**
 设置图片，文本和按钮，以及文本，按钮位置
 */
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
   labelYPadding:(CGFloat)labelPadding
          button:(UIButton *)btn
     btnYPadding:(CGFloat)btnYPadding{
    
    [self setImage:image labelText:labelText subLabelText:nil labelYPadding:labelPadding button:btn btnYPadding:btnYPadding];
}

- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
    subLabelText:(NSString *)subText
   labelYPadding:(CGFloat)labelPadding
          button:(UIButton *)btn
     btnYPadding:(CGFloat)btnYPadding{
    
    CGFloat top = self.height * 0.3;
    
    if (!image) {
        _imageView.hidden = YES;
    } else {
        _imageView.hidden = NO;
        _imageView.image = image;
        _imageView.frame = CGRectMake(self.width * 0.5 - image.size.width * 0.5, top, image.size.width, image.size.height);
        
        top = _imageView.bottom;
    }
    
    if ([NSString isEmpty:labelText]) {
        _label.hidden = YES;
    } else {
        _label.hidden = NO;
        _label.text = labelText;
        _label.numberOfLines = 0;
        [_label sizeToFit];
        _label.frame = CGRectMake(16, top + labelPadding, self.width - 16 * 2, _label.height);
        
        top = _label.bottom;
    }
    if ([NSString isEmpty:subText]) {
        _subLabel.hidden = YES;
    } else {
        _subLabel.hidden = NO;
        _subLabel.text = subText;
        _subLabel.numberOfLines = 0;
        [_subLabel sizeToFit];
        _subLabel.frame = CGRectMake(16, top + 5, self.width - 16 * 2, _label.height);
        
        top = _subLabel.bottom;
    }
    
    if (!btn) {
        _button.hidden = YES;
    } else {
        if (_button) {
            ReleaseSafe(_button);
        }
        _button = btn;
        [self addSubview:_button];
        _button.hidden = NO;
        _button.origin = CGPointMake(self.width * 0.5 - _button.width * 0.5, top + btnYPadding);
    }
}

@end
