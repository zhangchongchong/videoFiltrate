//
//  ViewController.m
//  视频筛选
//
//  Created by 张冲 on 2018/6/25.
//  Copyright © 2018年 张冲. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [button setTitle:@"筛选相册" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view, typically from a nib.
}
- (void)buttonClick:(UIButton *)button{
    NSLog(@"按钮");
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeVideo];
    [self presentViewController:imagePickerController animated:YES completion:^{

    }];
    
}
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*)filePath{

    NSFileManager* manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:filePath]){

        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];

    }else{
        NSLog(@"计算文件大小：文件不存在");
    }

    return 0;
}

- (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);

    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    NSLog(@"视频大小 = %llu",[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize);

    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    NSLog(@"info = %@",info);
    NSLog(@"info(UIImagePickerControllerMediaURL) = %@",info[@"UIImagePickerControllerMediaURL"]);
    NSURL * mediaUrl = info[@"UIImagePickerControllerMediaURL"];
    NSString *mediaUrlString = mediaUrl.absoluteString;
   mediaUrlString =[mediaUrlString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
   NSDictionary *videoInfo = [self getVideoInfoWithSourcePath:mediaUrlString];
    NSLog(@"videoInfo = %@",videoInfo);
//    NSLog(@"%lld",[self fileSizeAtPath:info[@"UIImagePickerControllerMediaURL"]]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
