//
//  STMacro.h
//  Pods
//
//  Created by Showtime on 2021/5/8.
//

#ifndef STMacro_h
#define STMacro_h

//信号量 线程锁 简写   参数 ：lock  为 dispatch_semaphore_t lock
#ifndef HB_LOCK
#define HB_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef HB_UNLOCK
#define HB_UNLOCK(lock) dispatch_semaphore_signal(lock);
#endif

#endif /* STMacro_h */
