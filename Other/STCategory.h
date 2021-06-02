//
//  STCategory.h
//  Pods
//
//  Created by Showtime on 2021/5/10.
//

#ifndef STCategory_h
#define STCategory_h

#if __has_include(<STPublic/STCategory.h>)

    #import <STPublic/NSData+STKit.h>
    #import <STPublic/NSDictionary+STKit.h>
    #import <STPublic/NSString+STKit.h>
    #import <STPublic/UIButton+STKit>
    #import <STPublic/UIColor+STKit>
    #import <STPublic/UIImage+STKit>
    #import <STPublic/UILabel+STkit>
    #import <STPublic/UIView+Frame>
    #import <STPublic/UIView+GestureCallback>

#else

    #import "NSData+STKit.h"
    #import "NSDictionary+STKit.h"
    #import "NSString+STKit.h"
    #import "UIButton+STKit.h"
    #import "UIColor+STKit.h"
    #import "UIImage+STKit.h"
    #import "UILabel+STkit.h"
    #import "UIView+Frame.h"
    #import "UIView+GestureCallback.h"

#endif

#endif /* STCategory_h */
