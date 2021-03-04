//
//  UILabel+STAttributedString.m
//  STPublic
//
//  Created by Showtime on 2021/1/27.
//

#import "UILabel+AttributedString.h"
#import <CoreText/CoreText.h>

@implementation UILabel (AttributedString)

#pragma mark -- 改变字段字体

- (void)changeFontWithTextFont:(UIFont *)textFont {
    [self changeFontWithTextFont:textFont changeText:self.text];
}

- (void)changeFontWithTextFont:(UIFont *)textFont changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSCaseInsensitiveSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSFontAttributeName value:textFont range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字段间距

- (void)changeSpaceWithTextSpace:(CGFloat)textSpace {
    [self changeSpaceWithTextSpace:textSpace changeText:self.text];
}

- (void)changeSpaceWithTextSpace:(CGFloat)textSpace changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSCaseInsensitiveSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:(id)kCTKernAttributeName value:@(textSpace) range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字段颜色
- (void)changeColorWithTextColor:(UIColor *)textColor {
    [self changeColorWithTextColor:textColor changeText:self.text];
}
- (void)changeColorWithTextColor:(UIColor *)textColor changeText:(NSString *)text {
    [self changeColorWithTextColor:textColor changeTexts:@[text]];
}

- (void)changeColorWithTextColor:(UIColor *)textColor changeTexts:(NSArray <NSString *>*)texts {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    for (NSString *text in texts) {
        NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
        if (textRange.location != NSNotFound) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:textRange];
        }
    }
    self.attributedText = attributedString;
}
#pragma mark - 改变字段背景颜色

- (void)changeBgColorWithBgTextColor:(UIColor *)bgTextColor {
    [self changeBgColorWithBgTextColor:bgTextColor changeText:self.text];
}

- (void)changeBgColorWithBgTextColor:(UIColor *)bgTextColor changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSBackgroundColorAttributeName value:bgTextColor range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字段连笔字 value值为1或者0

- (void)changeLigatureWithTextLigature:(NSNumber *)textLigature {
    [self changeLigatureWithTextLigature:textLigature changeText:self.text];
}

- (void)changeLigatureWithTextLigature:(NSNumber *)textLigature changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSLigatureAttributeName value:textLigature range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字间距

- (void)changeKernWithTextKern:(NSNumber *)textKern {
    [self changeKernWithTextKern:textKern changeText:self.text];
}

- (void)changeKernWithTextKern:(NSNumber *)textKern changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSKernAttributeName value:textKern range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的删除线 textStrikethroughStyle 为NSUnderlineStyle

- (void)changeStrikethroughStyleWithTextStrikethroughStyle:(NSNumber *)textStrikethroughStyle {
    [self changeStrikethroughStyleWithTextStrikethroughStyle:textStrikethroughStyle changeText:self.text];
}

- (void)changeStrikethroughStyleWithTextStrikethroughStyle:(NSNumber *)textStrikethroughStyle changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:textStrikethroughStyle range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的删除线颜色

- (void)changeStrikethroughColorWithTextStrikethroughColor:(UIColor *)textStrikethroughColor {
    [self changeStrikethroughColorWithTextStrikethroughColor:textStrikethroughColor changeText:self.text];
}

- (void)changeStrikethroughColorWithTextStrikethroughColor:(UIColor *)textStrikethroughColor changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSStrikethroughColorAttributeName value:textStrikethroughColor range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的下划线 textUnderlineStyle 为NSUnderlineStyle

- (void)changeUnderlineStyleWithTextStrikethroughStyle:(NSNumber *)textUnderlineStyle {
    [self changeUnderlineStyleWithTextStrikethroughStyle:textUnderlineStyle changeText:self.text];
}

- (void)changeUnderlineStyleWithTextStrikethroughStyle:(NSNumber *)textUnderlineStyle changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:textUnderlineStyle range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的下划线颜色

- (void)changeUnderlineColorWithTextStrikethroughColor:(UIColor *)textUnderlineColor {
    [self changeUnderlineColorWithTextStrikethroughColor:textUnderlineColor changeText:self.text];
}

- (void)changeUnderlineColorWithTextStrikethroughColor:(UIColor *)textUnderlineColor changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSUnderlineColorAttributeName value:textUnderlineColor range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的颜色

- (void)changeStrokeColorWithTextStrikethroughColor:(UIColor *)textStrokeColor {
    [self changeStrokeColorWithTextStrikethroughColor:textStrokeColor changeText:self.text];
}

- (void)changeStrokeColorWithTextStrikethroughColor:(UIColor *)textStrokeColor changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSStrokeColorAttributeName value:textStrokeColor range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的描边

- (void)changeStrokeWidthWithTextStrikethroughWidth:(NSNumber *)textStrokeWidth {
    [self changeStrokeWidthWithTextStrikethroughWidth:textStrokeWidth changeText:self.text];
}

- (void)changeStrokeWidthWithTextStrikethroughWidth:(NSNumber *)textStrokeWidth changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSStrokeWidthAttributeName value:textStrokeWidth range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的阴影

- (void)changeShadowWithTextShadow:(NSShadow *)textShadow {
    [self changeShadowWithTextShadow:textShadow changeText:self.text];
}

- (void)changeShadowWithTextShadow:(NSShadow *)textShadow changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSShadowAttributeName value:textShadow range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的特殊效果

- (void)changeTextEffectWithTextEffect:(NSString *)textEffect {
    [self changeTextEffectWithTextEffect:textEffect changeText:self.text];
}

- (void)changeTextEffectWithTextEffect:(NSString *)textEffect changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSTextEffectAttributeName value:textEffect range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的文本附件

- (void)changeAttachmentWithTextAttachment:(NSTextAttachment *)textAttachment {
    [self changeAttachmentWithTextAttachment:textAttachment changeText:self.text];
}

- (void)changeAttachmentWithTextAttachment:(NSTextAttachment *)textAttachment changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSAttachmentAttributeName value:textAttachment range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的链接

- (void)changeLinkWithTextLink:(NSString *)textLink {
    [self changeLinkWithTextLink:textLink changeText:self.text];
}

- (void)changeLinkWithTextLink:(NSString *)textLink changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSLinkAttributeName value:textLink range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的基准线偏移 value>0坐标往上偏移 value<0坐标往下偏移

- (void)changeBaselineOffsetWithTextBaselineOffset:(NSNumber *)textBaselineOffset {
    [self changeBaselineOffsetWithTextBaselineOffset:textBaselineOffset changeText:self.text];
}

- (void)changeBaselineOffsetWithTextBaselineOffset:(NSNumber *)textBaselineOffset changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSBaselineOffsetAttributeName value:textBaselineOffset range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的倾斜 value>0向右倾斜 value<0向左倾斜

- (void)changeObliquenessWithTextObliqueness:(NSNumber *)textObliqueness {
    [self changeObliquenessWithTextObliqueness:textObliqueness changeText:self.text];
}

- (void)changeObliquenessWithTextObliqueness:(NSNumber *)textObliqueness changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSObliquenessAttributeName value:textObliqueness range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字粗细 0就是不变 >0加粗 <0加细

- (void)changeExpansionsWithTextExpansion:(NSNumber *)textExpansion {
    [self changeExpansionsWithTextExpansion:textExpansion changeText:self.text];
}

- (void)changeExpansionsWithTextExpansion:(NSNumber *)textExpansion changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSExpansionAttributeName value:textExpansion range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字方向 NSWritingDirection

- (void)changeWritingDirectionWithTextExpansion:(NSArray *)textWritingDirection changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSWritingDirectionAttributeName value:textWritingDirection range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的水平或者竖直 1竖直 0水平

- (void)changeVerticalGlyphFormWithTextVerticalGlyphForm:(NSNumber *)textVerticalGlyphForm changeText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange textRange = [self.text rangeOfString:text options:NSBackwardsSearch];
    if (textRange.location != NSNotFound) {
        [attributedString addAttribute:NSVerticalGlyphFormAttributeName value:textVerticalGlyphForm range:textRange];
    }
    self.attributedText = attributedString;
}

#pragma mark - 改变字的两端对齐

- (void)changeCTKernWithTextCTKern:(NSNumber *)textCTKern {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    [attributedString addAttribute:(id)kCTKernAttributeName value:textCTKern range:NSMakeRange(0, self.text.length-1)];
    self.attributedText = attributedString;
}
@end
