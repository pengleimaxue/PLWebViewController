////
//  PLWebViewController.h
//  PLWKWebViewController
//
//  Created by ___Fitfun___ on 2019/3/6.
//Copyright © 2019年 penglei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PLWebViewBlock)(NSString *);
typedef void(^PLWebViewfailedBlock)(NSString *webURL,NSError* error);

@interface PLWebViewController : UIViewController

- (instancetype)initWithAddress:(NSString *)urlString;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

- (PLWebViewController  *(^)(PLWebViewBlock begainBlock))begainLoadingWebView;
- (PLWebViewController  *(^)(PLWebViewBlock successBlock))loadingWebViewSuccess;
- (PLWebViewController  *(^)(PLWebViewfailedBlock failedBlock))loadingWebViewfailed;
- (PLWebViewController  *(^)(PLWebViewBlock closeBlock))closeWebView;
- (PLWebViewController  *(^)(void))hideNavigationBar;

@end

NS_ASSUME_NONNULL_END
