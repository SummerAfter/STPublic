//
//  STUtils.h
//  STPublic
//
//  Created by Showtime on 2021/5/8.
//

#ifndef STUtils_h
#define STUtils_h

#import "STMacro.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelWarning;
#endif


#endif /* STUtils_h */
