//
//  UIButton+STButton.m
//  STPublic
//
//  Created by Showtime on 2021/3/3.
//

#import "UIButton+STKit.h"
#import <objc/runtime.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "UIImage+STKit.h"

static char btnBlockKey ;
static char forbiddenTimeKey;


static NSString *const kButtonTextObjectKey = @"buttonTextObject";

@implementation UIButton (STKit)

#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

#pragma mark - Lifecycle: init dealloc

- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont Block:(TouchedBlock)block {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    button.titleLabel.font = titleFont;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    objc_setAssociatedObject(button, &btnBlockKey, block, OBJC_ASSOCIATION_COPY);
    [button addTarget:button action:@selector(actionTouched:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (instancetype)initWithImgage:(NSString *)image Block:(TouchedBlock)block {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    if (image) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    objc_setAssociatedObject(button, &btnBlockKey, block, OBJC_ASSOCIATION_COPY);
    [button addTarget:button action:@selector(actionTouched:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Override

#pragma mark - Public

- (void)st_setImagePosition:(STImagePosition)postion spacing:(CGFloat)spacing {
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    switch (postion) {
        case STImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case STImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case STImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case STImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
    
}

- (void)st_setImageURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage {
    if (!imageURL) {
        return;
    }
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:placeholderImage];
}


- (void)st_setImageURL:(NSString *)imageURL placeholderColor:(UIColor *)placeholderColor {
    if (!imageURL) {
        return;
    }
    UIImage *img = [UIImage imageWithColor:placeholderColor];
    [self st_setImageURL:imageURL placeholderImage:img];

}


- (void)st_setRealImageURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage {
    self.clipsToBounds = YES;
    if (!imageURL) {
        return;
    }
    [self sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:placeholderImage];
}


- (void)st_setRealImageURL:(NSString *)imageURL placeholderColor:(UIColor *)placeholderColor {
    if (!imageURL) {
        return;
    }
    UIImage *img = [UIImage imageWithColor:placeholderColor];
    [self st_setRealImageURL:imageURL placeholderImage:img];
}


- (void)st_setImageURL:(NSString *)imageURL {
    UIColor *placeholder = [UIColor colorWithRed:(241)/255.0f green:(241)/255.0f blue:241/255.0f alpha:1];
    [self st_setImageURL:imageURL placeholderColor:placeholder];
}

- (void)st_setRealImageURL:(NSString *)imageURL {
    UIColor *placeholder = [UIColor colorWithRed:(241)/255.0f green:(241)/255.0f blue:241/255.0f alpha:1];
    [self st_setRealImageURL:imageURL placeholderColor:placeholder];
}

#pragma mark - Privite

- (void)btnEnable:(NSTimer *)timer {
    self.userInteractionEnabled = YES;
    [timer invalidate];
    timer = nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets touchAreaInsets = self.touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

#pragma mark - Network

#pragma mark - Notifaction

#pragma mark - Event Response

// 点击事件
-(void)actionTouched:(UIButton *)btn {
    // 限制连续点击
    if (self.forbiddenTime) {
        self.userInteractionEnabled = NO;
        [NSTimer scheduledTimerWithTimeInterval:self.forbiddenTime target:self selector:@selector(btnEnable:) userInfo:nil repeats:NO];
    }
    
    TouchedBlock block = objc_getAssociatedObject(btn, &btnBlockKey);
    if (block) {
        block(btn.tag);
    }
}
#pragma mark - Delegate

#pragma mark - Getter & Setter

- (NSString *)st_title {
    if (self.titleLabel.text) {
        return self.titleLabel.text;
    }
    return @"";
}

- (void)setSt_title:(NSString *)st_title {
    [self setTitle:st_title forState:UIControlStateNormal];
}

- (UIColor *)st_titleColor {
    return self.titleLabel.textColor;
}

- (void)setSt_titleColor:(UIColor *)st_titleColor {
    [self setTitleColor:st_titleColor forState:UIControlStateNormal];
}

- (UIFont *)st_font {
    return self.titleLabel.font;
}

-(void)setSt_font:(UIFont *)st_font {
    self.titleLabel.font = st_font;
}

- (UIImage *)st_image {
    return self.imageView.image;
}

- (void)setSt_image:(UIImage *)st_image {
    [self setImage:st_image forState:UIControlStateNormal];
}

- (CGFloat)forbiddenTime {
    NSNumber *timeValue = objc_getAssociatedObject(self, &forbiddenTimeKey);
    return [timeValue floatValue];
}

- (void)setForbiddenTime:(CGFloat)forbiddenTime {
    objc_setAssociatedObject(self, &forbiddenTimeKey, @(forbiddenTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)touchAreaInsets {
    return [objc_getAssociatedObject(self, @selector(touchAreaInsets)) UIEdgeInsetsValue];
}

- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
