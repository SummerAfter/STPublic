//
//  STMacro.h
//  Pods
//
//  Created by Showtime on 2021/5/8.
//

#ifndef STMacro_h
#define STMacro_h

#define RGBCOLOR(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]

//信号量 线程锁 简写   参数 ：lock  为 dispatch_semaphore_t lock
#ifndef LOCK
#define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef UNLOCK
#define UNLOCK(lock) dispatch_semaphore_signal(lock);
#endif

#define ReleaseSafe(__pointer) \
    { __pointer = nil; }
#define ReleaseViewSafe(__pointer)    \
    {                                    \
        [__pointer removeFromSuperview]; \
        __pointer = nil;                 \
    }
#define ReleaseLayerSafe(__pointer)    \
    {                                     \
        [__pointer removeFromSuperlayer]; \
        __pointer = nil;                  \
    }


#endif /* STMacro_h */
