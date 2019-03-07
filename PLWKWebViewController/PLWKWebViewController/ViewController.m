////
//  ViewController.m
//  PLWKWebViewController
//
//  Created by ___Fitfun___ on 2019/3/6.
//Copyright © 2019年 penglei. All rights reserved.
//

#import "ViewController.h"
#import "PLWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)psuhWebView:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"https://www.baidu.com"];
    PLWebViewController *webViewController = [[PLWebViewController alloc] initWithURL:URL];
    webViewController.begainLoadingWebView(^(NSString *url) {
        NSLog(@"开始加载:url=%@",url);
    }).loadingWebViewSuccess(^(NSString *url) {
        NSLog(@"加载成功:url=%@",url);
    }).loadingWebViewfailed(^(NSString *url,NSError *error) {
        NSLog(@"加载失败:url==%@,error=%@",url,error);
    }).closeWebView(^(NSString *url){
        NSLog(@"网页关闭:url=%@",url);
    }).hideNavigationBar();
    
    [self.navigationController pushViewController:webViewController animated:YES];
}
- (IBAction)pushWebView2:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"https://www.baidu.com"];
    PLWebViewController *webViewController = [[PLWebViewController alloc] initWithURL:URL];
    webViewController.begainLoadingWebView(^(NSString *url) {
        NSLog(@"开始加载:url=%@",url);
    }).loadingWebViewSuccess(^(NSString *url) {
        NSLog(@"加载成功:url=%@",url);
    }).loadingWebViewfailed(^(NSString *url,NSError *error) {
        NSLog(@"加载失败:url==%@,error=%@",url,error);
    }).closeWebView(^(NSString *url){
        NSLog(@"网页关闭:url=%@",url);
    });
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)presentWebView:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"https://www.baidu.com"];
    PLWebViewController *webViewController = [[PLWebViewController alloc] initWithURL:URL];
    webViewController.begainLoadingWebView(^(NSString *url) {
        NSLog(@"开始加载:url=%@",url);
    }).loadingWebViewSuccess(^(NSString *url) {
        NSLog(@"加载成功:url=%@",url);
    }).loadingWebViewfailed(^(NSString *url,NSError *error) {
        NSLog(@"加载失败:url==%@,error=%@",url,error);
    }).closeWebView(^(NSString *url){
        NSLog(@"网页关闭:url=%@",url);
    }).hideNavigationBar();
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [self presentViewController:nv animated:YES completion:nil];
}

@end
