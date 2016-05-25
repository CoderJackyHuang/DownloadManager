//
//  HYBVideoOperation.m
//  DownloadManager
//
//  Created by huangyibiao on 16/5/23.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBVideoOperation.h"
#import "HYBVideoModel.h"
#import <objc/runtime.h>

#define kKVOBlock(KEYPATH, BLOCK) \
[self willChangeValueForKey:KEYPATH]; \
BLOCK(); \
[self didChangeValueForKey:KEYPATH];

static NSTimeInterval kTimeoutInterval = 60.0;

@interface HYBVideoOperation () {
  BOOL _finished;
  BOOL _executing;
}

@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, weak) NSURLSession *session;

@end

@implementation HYBVideoOperation

- (instancetype)initWithModel:(HYBVideoModel *)model session:(NSURLSession *)session {
  if (self = [super init]) {
    self.model = model;
    self.session = session;
    [self statRequest];
  }
  
  return self;
}

- (void)dealloc {
  self.task = nil;
}

- (void)setTask:(NSURLSessionDownloadTask *)task {
  [_task removeObserver:self forKeyPath:@"state"];
  
  if (_task != task) {
    _task = task;
  }
  
  if (task != nil) {
    [task addObserver:self
           forKeyPath:@"state"
              options:NSKeyValueObservingOptionNew context:nil];
  }
}

- (void)configTask {
  self.task.hyb_videoModel = self.model;
}

- (void)statRequest {
  NSURL *url = [NSURL URLWithString:self.model.videoUrl];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:kTimeoutInterval];
  self.task = [self.session downloadTaskWithRequest:request];
  [self configTask];
}

- (void)start {
  if (self.isCancelled) {
    kKVOBlock(@"isFinished", ^{
      _finished = YES;
    });
    return;
  }
  
  [self willChangeValueForKey:@"isExecuting"];
  if (self.model.resumeData) {
    [self resume];
  } else {
    [self.task resume];
    self.model.status = kHYBVideoStatusRunning;
  }
  
  _executing = YES;
  [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isExecuting {
  return _executing;
}

- (BOOL)isFinished {
  return _finished;
}

- (BOOL)isConcurrent {
  return YES;
}

- (void)suspend {
  if (self.task) {
    __weak __typeof(self) weakSelf = self;
    __block NSURLSessionDownloadTask *weakTask = self.task;
     [self willChangeValueForKey:@"isExecuting"];
    __block BOOL isExecuting = _executing;

    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
      weakSelf.model.resumeData = resumeData;
      weakTask = nil;
      isExecuting = NO;
      [weakSelf didChangeValueForKey:@"isExecuting"];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.model.status = kHYBVideoStatusSuspended;
      });
    }];
    
    [self.task suspend];
  }
}

- (void)resume {
  if (self.model.status == kHYBVideoStatusCompleted) {
    return;
  }
  self.model.status = kHYBVideoStatusRunning;
  
  if (self.model.resumeData) {
    self.task = [self.session downloadTaskWithResumeData:self.model.resumeData];
    [self configTask];
  } else if (self.task == nil
             || (self.task.state == NSURLSessionTaskStateCompleted && self.model.progress < 1.0)) {
    [self statRequest];
  }
  
  [self willChangeValueForKey:@"isExecuting"];
  [self.task resume];
  _executing = YES;
  [self didChangeValueForKey:@"isExecuting"];
}

- (NSURLSessionDownloadTask *)downloadTask {
  return self.task;
}

- (void)cancel {
  [self willChangeValueForKey:@"isCancelled"];
  [super cancel];
  [self.task cancel];
  self.task = nil;
  [self didChangeValueForKey:@"isCancelled"];
  
  [self completeOperation];
}

- (void)completeOperation {
  [self willChangeValueForKey:@"isFinished"];
  [self willChangeValueForKey:@"isExecuting"];
  
  _executing = NO;
  _finished = YES;
  
  [self didChangeValueForKey:@"isExecuting"];
  [self didChangeValueForKey:@"isFinished"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
  if ([keyPath isEqualToString:@"state"]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      switch (self.task.state) {
        case NSURLSessionTaskStateSuspended: {
          self.model.status = kHYBVideoStatusSuspended;
          break;
        }
          case NSURLSessionTaskStateCompleted:
          if (self.model.progress >= 1.0) {
            self.model.status = kHYBVideoStatusCompleted;
          } else {
            self.model.status = kHYBVideoStatusSuspended;
          }
        default:
          break;
      }
    });
  }
}

- (void)downloadFinished {
  [self completeOperation];
}

@end

static const void *s_hyb_videoModelKey = "s_hyb_videoModelKey";

@implementation NSURLSessionTask (VideoModel)

- (void)setHyb_videoModel:(HYBVideoModel *)hyb_videoModel {
  objc_setAssociatedObject(self, s_hyb_videoModelKey, hyb_videoModel, OBJC_ASSOCIATION_ASSIGN);
}

- (HYBVideoModel *)hyb_videoModel {
  return objc_getAssociatedObject(self, s_hyb_videoModelKey);
}

@end
