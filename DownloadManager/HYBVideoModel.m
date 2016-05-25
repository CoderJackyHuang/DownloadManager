//
//  HYBVideoModel.m
//  DownloadManager
//
//  Created by huangyibiao on 16/5/23.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBVideoModel.h"
#import "HYBVideoOperation.h"

@implementation HYBVideoModel

- (NSString *)localPath {
  NSString *pathName = [NSString stringWithFormat:@"/Documents/HYBVideos/%@.mp4",self.videoId];
  NSString *filePath = [NSHomeDirectory() stringByAppendingString:pathName];
  
  return filePath;
}

- (void)setProgress:(CGFloat)progress {
  if (_progress != progress) {
    _progress = progress;
    
    if (self.onProgressChanged) {
      self.onProgressChanged(self);
    } else {
      NSLog(@"progress changed block is empty");
    }
  }
}

- (void)setStatus:(HYBVideoStatus)status {
  if (_status != status) {
    _status = status;
    
    if (self.onStatusChanged) {
      self.onStatusChanged(self);
    }
  }
}

- (NSString *)statusText {
  switch (self.status) {
    case kHYBVideoStatusNone: {
     return @"";
      break;
    }
    case kHYBVideoStatusRunning: {
      return @"下载中";
      break;
    }
    case kHYBVideoStatusSuspended: {
      return @"暂停下载";
      break;
    }
    case kHYBVideoStatusCompleted: {
      return @"下载完成";
      break;
    }
    case kHYBVideoStatusFailed: {
      return @"下载失败";
      break;
    }
    case kHYBVideoStatusWaiting: {
      return @"等待下载";
      break;
    }
  }
}

@end
