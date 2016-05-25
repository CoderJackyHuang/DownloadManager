//
//  HYBVideoManager.h
//  DownloadManager
//
//  Created by huangyibiao on 16/5/23.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYBVideoModel;

@interface HYBVideoManager : NSObject

@property (nonatomic, readonly, strong) NSArray *videoModels;

+ (instancetype)shared;

- (void)addVideoModels:(NSArray<HYBVideoModel *> *)videoModels;

- (void)startWithVideoModel:(HYBVideoModel *)videoModel;
- (void)suspendWithVideoModel:(HYBVideoModel *)videoModel;
- (void)resumeWithVideoModel:(HYBVideoModel *)videoModel;

- (void)stopWiethVideoModel:(HYBVideoModel *)videoModel;

@end
