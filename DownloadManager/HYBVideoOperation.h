//
//  HYBVideoOperation.h
//  DownloadManager
//
//  Created by huangyibiao on 16/5/23.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYBVideoModel;

@interface NSURLSessionTask (VideoModel)

// 为了更方便去获取，而不需要遍历，采用扩展的方式，可直接提取，提高效率
@property (nonatomic, weak) HYBVideoModel *hyb_videoModel;

@end

@interface HYBVideoOperation : NSOperation

- (instancetype)initWithModel:(HYBVideoModel *)model session:(NSURLSession *)session;

@property (nonatomic, weak) HYBVideoModel *model;
@property (nonatomic, strong, readonly) NSURLSessionDownloadTask *downloadTask;

- (void)suspend;
- (void)resume;
- (void)downloadFinished;

@end
