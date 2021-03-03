//
//  UILabel+ST.m
//  STPublic
//
//  Created by Showtime on 2021/1/27.
//

#import "UILabel+STkit.h"

@implementation UILabel (STkit)

+ (instancetype)labelWithfont:(UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    if (font) {
        [label setFont:font];
    }
    if (textColor) {
        [label setTextColor:textColor];
    }
    if (alignment) {
        [label setTextAlignment:alignment];
    }
    return label;
}

@end
