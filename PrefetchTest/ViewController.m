//
//  ViewController.m
//  PrefetchTest
//
//  Created by 熊宇翔 on 2021/1/27.
//

#import "ViewController.h"
#import <SJMediaCacheServer/SJMediaCacheServer.h>
@interface ViewController ()
{
    UIButton *_startPrefetch;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *startPrefetch = [UIButton buttonWithType:UIButtonTypeCustom];
    [startPrefetch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startPrefetch setTitle:@"点击开始下载" forState:UIControlStateNormal];
    [startPrefetch addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startPrefetch];
    startPrefetch.frame = CGRectMake(0, 200, self.view.frame.size.width, 44);
    _startPrefetch = startPrefetch;

}
- (void)download {
    [_startPrefetch setTitle:@"2 秒后自动取消" forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [_startPrefetch setTitle:@"已取消，点击重新下载" forState:UIControlStateNormal];
        [[SJMediaCacheServer shared] cancelAllPrefetchTasks];
    }];
    [[SJMediaCacheServer shared] prefetchWithURL:[NSURL URLWithString:@"https://d2c3ct5w4v6137.cloudfront.net/youtube_sv0CE-Vo00g/18/2020%E4%B8%8D%E8%83%BD%E4%B8%8D%E8%81%BD%E7%9A%84100%E9%A6%96%E6%AD%8C%20(%20%E5%B0%91%E5%B9%B4%20-%20%E5%A4%A2%E7%84%B6%20%2C%20%E8%AA%AA%E5%A5%BD%E4%B8%8D%E5%93%AD%20Won%20t%20Cry%2C%20%E9%98%BF%E5%86%97%20-%20%E4%BD%A0%E7%9A%84%E7%AD%94%E6%A1%88%20%2C%20%E9%9F%B3%E9%97%95%E8%A9%A9%E8%81%BD%20-%20%E8%8A%92%E7%A8%AE%2C%20%2C%20%E9%99%B3%E9%9B%AA%E5%87%9D%20-%20%E7%B6%A0%E8%89%B2%20)%20KKBOX%20%E8%8F%AF%E8%AA%9E%E6%96%B0%E6%AD%8C_360P.mp4"] preloadSize:1024*1024*500 progress:^(float progress) {
        
    } completed:^(NSError * _Nullable error) {
        if (error != nil) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:[error.userInfo objectForKey:@"reason"] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:Nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

@end
