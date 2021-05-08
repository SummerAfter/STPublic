//
//  STMacro.h
//  Pods
//
//  Created by Showtime on 2021/5/8.
//

#ifndef STMacro_h
#define STMacro_h

//信号量 线程锁 简写   参数 ：lock  为 dispatch_semaphore_t lock
#ifndef ST_LOCK
#define ST_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef ST_UNLOCK
#define ST_UNLOCK(lock) dispatch_semaphore_signal(lock);
#endif




#endif /* STMacro_h */
