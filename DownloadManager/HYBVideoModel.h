//
//  HYBVideoModel.h
//  DownloadManager
//
//  Created by huangyibiao on 16/5/23.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HYBVideoOperation;
@class HYBVideoModel;

typedef NS_ENUM(NSInteger, HYBVideoStatus) {
  kHYBVideoStatusNone = 0,       // 初始状态
  kHYBVideoStatusRunning = 1,    // 下载中
  kHYBVideoStatusSuspended = 2,  // 下载暂停
  kHYBVideoStatusCompleted = 3,  // 下载完成
  kHYBVideoStatusFailed  = 4,    // 下载失败
  kHYBVideoStatusWaiting = 5    // 等待下载
//  kHYBVideoStatusCancel = 6      // 取消下载
 };

typedef void(^HYBVideoStatusChanged)(HYBVideoModel *model);
typedef void(^HYBVideoProgressChanged)(HYBVideoModel *model);

@interface HYBVideoModel : NSObject

@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *title;


@property (nonatomic, strong) NSData *resumeData;
// 下载后存储到此处
@property (nonatomic, copy) NSString *localPath;
@property (nonatomic, copy) NSString *progressText;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) HYBVideoStatus status;
@property (nonatomic, strong) HYBVideoOperation *operation;

@property (nonatomic, copy) HYBVideoStatusChanged onStatusChanged;
@property (nonatomic, copy) HYBVideoProgressChanged onProgressChanged;

@property (nonatomic, readonly, copy) NSString *statusText;

@end
