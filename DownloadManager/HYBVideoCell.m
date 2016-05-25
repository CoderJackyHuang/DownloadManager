//
//  HYBVideoCell.m
//  DownloadManager
//
//  Created by huangyibiao on 16/5/23.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBVideoCell.h"
#import <Masonry.h>
#import "HYBVideoModel.h"
#import <UIImageView+WebCache.h>

@interface HYBVideoCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *progressTextLabel;

@end

@implementation HYBVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.photoImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.photoImageView];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.mas_equalTo(15);
      make.width.height.mas_equalTo(80);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor blueColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.photoImageView.mas_right).offset(15);
      make.right.mas_equalTo(-15);
      make.top.mas_equalTo(self.photoImageView.mas_top);
    }];
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.trackTintColor = [UIColor lightGrayColor];
    self.progressView.progressTintColor = [UIColor greenColor];
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.titleLabel);
      make.right.mas_equalTo(-15);
      make.top.mas_equalTo(self.photoImageView.mas_bottom).offset(-35);
      make.height.mas_equalTo(4);
    }];
    
    self.progressTextLabel = [[UILabel alloc] init];
    self.progressTextLabel.textColor = [UIColor darkGrayColor];
    self.progressTextLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.progressTextLabel];
    [self.progressTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(15);
      make.top.mas_equalTo(self.progressView.mas_bottom).offset(5);
      make.width.mas_equalTo(120);
    }];
 
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = [UIColor darkGrayColor];
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_equalTo(-15);
      make.top.mas_equalTo(self.progressView.mas_bottom).offset(5);
      make.height.mas_equalTo(self.progressTextLabel);
    }];
  }
  
  return self;
}

- (void)setModel:(HYBVideoModel *)model {
  if (_model != model) {
    _model = model;
  }
  
  [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
  self.progressTextLabel.text = model.progressText;
  [self.progressView setProgress:model.progress];
  self.statusLabel.text = model.statusText;
  self.titleLabel.text = model.title;
}

@end
