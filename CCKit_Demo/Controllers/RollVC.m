//
//  RollVC.m
//  CCKit_Demo
//
//  Created by chencheng on 2018/8/1.
//  Copyright © 2018年 double chen. All rights reserved.
//

#import "RollVC.h"
#import "CCRollView.h"

#import <CommonCrypto/CommonDigest.h>

@interface RollVC ()

@property(nonatomic,strong) CCRollView *rollView;

@end

@implementation RollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [SVProgressHUD showWithStatus:@"加载图片..."];
    
    [self loadUrlImgs:^(NSArray *imgs) {
        
        [SVProgressHUD showSuccessWithStatus:@"加载完成!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        _rollView = [[CCRollView alloc] initWithFrame:CGRectZero imgs:imgs];
        [self.view addSubview:_rollView];
        _rollView.rollIntervalTime = 2.f;
        [_rollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.height.equalTo(self.view.mas_width);
        }];
    }];
}

//rollView里面有计时器，记得在合适的时候处理掉
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.rollView.autoRoll = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.rollView.autoRoll = NO;
}

- (void)loadUrlImgs:(void(^)(NSArray *imgs))block {

    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSArray *urls = @[@"https://cdn.pixabay.com/photo/2018/01/12/10/19/fantasy-3077928_1280.jpg",
                          @"https://cdn.pixabay.com/photo/2018/02/24/18/00/row-pension-3178766_1280.jpg",
                          @"https://cdn.pixabay.com/photo/2016/07/17/08/37/coins-1523383_1280.jpg"];
        
        NSMutableArray *arr = @[].mutableCopy;
        
        NSFileManager *manager = [NSFileManager defaultManager];
        for (int i = 0; i < urls.count; i++) {
            NSString *urlString = urls[i];
            urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            NSString *imgName = [self md5:urlString];
            NSString *path = [NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),imgName];
            UIImage *img = nil;
            if ([manager fileExistsAtPath:path]) {
                NSLog(@"从本地缓存中获取");
                img = [UIImage imageWithContentsOfFile:path];
            }else {
                NSLog(@"从网络上加载");
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                img = [UIImage imageWithData:data];
                if (!img) {
                    NSLog(@"该链接已失效:%@",urlString);
                    continue;
                }
                [data writeToFile:path atomically:YES];
            }
            [arr addObject:img];
        }
        
        NSLog(@"图片加载完成");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) block(arr);
        });
    });
}

- (NSString *)md5:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
