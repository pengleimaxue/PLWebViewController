////
//  PLWebViewController.m
//  PLWKWebViewController
//
//  Created by ___Fitfun___ on 2019/3/6.
//Copyright © 2019年 penglei. All rights reserved.
//

#import "PLWebViewController.h"
#import <WebKit/WebKit.h>
#import "FitFunSystemTool.h"


@interface PLWebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;
@property (nonatomic, strong) NSURLRequest *request;

@property (nonatomic, strong) WKWebView *wkWebView;

//进度条
@property (nonatomic, strong) UIProgressView *wkWebViewProgress;

@property (nonatomic, copy) PLWebViewBlock begainBlock;
@property (nonatomic, copy) PLWebViewBlock successBlock;
@property (nonatomic, copy) PLWebViewfailedBlock failedBlock;
@property (nonatomic, copy) PLWebViewBlock closeBlock;
@property (nonatomic, assign) BOOL isHideNavigationBar;

@end

@implementation PLWebViewController

#pragma mark -init

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)dealloc {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    

    if (self.wkWebView) {
        [self.wkWebView stopLoading];
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    
    if (self.wkWebViewProgress) {
        [self.wkWebViewProgress removeObserver:self forKeyPath:@"progress"];
    }
    
    _wkWebView = nil;
    _backBarButtonItem = nil;
    _forwardBarButtonItem = nil;
    _refreshBarButtonItem = nil;
    _stopBarButtonItem = nil;
    _wkWebViewProgress = nil;
}


- (PLWebViewController  *(^)(PLWebViewBlock begainBlock))begainLoadingWebView {
    return ^id(PLWebViewBlock begainBlock) {
        self.begainBlock  = begainBlock;
        return self;
    };
}

- (PLWebViewController  *(^)(PLWebViewBlock successBlock))loadingWebViewSuccess {
    return ^id(PLWebViewBlock successBlock) {
        self.successBlock = successBlock;
        return self;
    };
}

- (PLWebViewController  *(^)(PLWebViewfailedBlock failedBlock))loadingWebViewfailed {
    return ^id(PLWebViewfailedBlock failedBlock) {
        self.failedBlock  = failedBlock;
        return self;
    };
}

- (PLWebViewController  *(^)(PLWebViewBlock closeBlock))closeWebView {
    return ^id(PLWebViewBlock closeBlock) {
        self.closeBlock   = closeBlock;
        return self;
    };
}

- (PLWebViewController  *(^)(void))hideNavigationBar {
    return ^id(){
        self.isHideNavigationBar = YES;
        return self;
    };
}

#pragma mark - View lifeCycle

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"PLWebViewController needs to be contained in a UINavigationController.");
    [super viewWillAppear:animated];
    if (self.navigationController) {
        [self.navigationController setToolbarHidden:NO animated:animated];
        [self.navigationController setNavigationBarHidden:self.isHideNavigationBar animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)loadView {
    self.view = self.wkWebView;
    [self.wkWebView loadRequest:self.request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateToolbarItems];
    [self addWKWebViewProgress];
    [self updateProgressFrame];
    // Do any additional setup after loading the view.
}

- (void)addWKWebViewProgress {
    [self.view addSubview:self.wkWebViewProgress];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.wkWebViewProgress addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}


#pragma mark - observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.wkWebView) {
        
        BOOL animated = self.wkWebView.estimatedProgress > self.wkWebViewProgress.progress;
        [self.wkWebViewProgress setProgress:self.wkWebView.estimatedProgress animated:animated];
        self.wkWebViewProgress.progress =self.wkWebView.estimatedProgress;

    } else if ([keyPath isEqualToString:@"progress"]) {
        if (self.wkWebViewProgress.progress>=1.0f) {
            [UIView animateWithDuration:0.5f delay:1.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.wkWebViewProgress.alpha = 0.5;
            } completion:^(BOOL finished) {
               self.wkWebViewProgress.alpha = 0;
            }];
        
        }
        
    }
    
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self updateToolbarItems];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (self.begainBlock) {
        self.begainBlock(self.request.URL.absoluteString);
    }
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
    if(self.isHideNavigationBar == NO) {
         self.navigationItem.title = webView.title;
    }
    if (self.successBlock) {
        self.successBlock(self.request.URL.absoluteString);
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self updateToolbarItems];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (self.failedBlock) {
        self.failedBlock(self.request.URL.absoluteString, error);
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self updateToolbarItems];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (self.failedBlock) {
        self.failedBlock(self.request.URL.absoluteString, error);
    }
}

//在请求发送之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
   
    //[self updateToolbarItems];
    decisionHandler(WKNavigationActionPolicyAllow);
}

//在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    //[self updateToolbarItems];
    decisionHandler(WKNavigationResponsePolicyAllow);
}
//#pragma mark - WKUIDelegate
//
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
//    }
//    return self.wkWebView;
//}

#pragma mark -private methond

#pragma mark - toolBarAction

- (void)goBackTapped:(UIBarButtonItem *)sender {
    [self.wkWebView goBack];
}

- (void)goForwardTapped:(UIBarButtonItem *)sender {
    [self.wkWebView goForward];
}

- (void)reloadTapped:(UIBarButtonItem *)sender {
    [self.wkWebView reload];
    [self updateProgressFrame];
}

- (void)stopTapped:(UIBarButtonItem *)sender {
    [self.wkWebView stopLoading];
    [self updateToolbarItems];
}

- (void)closeTapped:(UIBarButtonItem *)sender {
    if (self.navigationController.childViewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.closeBlock) {
        self.closeBlock(self.request.URL.absoluteString);
    }
}

#pragma mark -toolBar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.wkWebView.canGoBack;
    self.forwardBarButtonItem.enabled =self.wkWebView.canGoForward;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.wkWebView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          self.backBarButtonItem,
                          flexibleSpace,
                          self.forwardBarButtonItem,
                          flexibleSpace,
                          refreshStopBarButtonItem,
                          flexibleSpace,
                          self.closeBarButtonItem,
                          nil];
        
        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.toolbarItems = items;
    
}

- (void)updateProgressFrame {
    if (self.wkWebView.isLoading) {
        self.wkWebViewProgress.alpha = 1;
    }
    CGRect frame = self.wkWebViewProgress.frame;
    if(isPortrait) {
        if (self.isHideNavigationBar) {
             frame.origin.y = FFStatusBarHeight;
        } else {
            frame.origin.y = FFSafeAreaTopHeight;
        }
       
    } else {
        if (self.isHideNavigationBar) {
            frame.origin.y = 0;
        } else {
            frame.origin.y = self.navigationController.navigationBar.frame.size.height;
        }
        
    }
    frame.size.width = FFSCREEN_WIDTH;
    self.wkWebViewProgress.frame = frame;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateProgressFrame];
}

#pragma mark - getter && setter

- (WKWebView *)wkWebView {
    if (_wkWebView == nil) {
        _wkWebView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
    }
    return _wkWebView;
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PLWKWebView.bundle/PLWKWebViewControllerBack"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(goBackTapped:)];
        _backBarButtonItem.width = 18.0f;
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PLWKWebView.bundle/PLWKWebViewControllerNext"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(goForwardTapped:)];
        _forwardBarButtonItem.width = 18.0f;
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped:)];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (!_stopBarButtonItem) {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopTapped:)];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)closeBarButtonItem {
    if (!_closeBarButtonItem) {
        _closeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PLWKWebView.bundle/PLWKWebViewControllerGoBack"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                              action:@selector(closeTapped:)];
        _closeBarButtonItem.width = 18.0f;
    }
    return _closeBarButtonItem;
}

- (UIProgressView *)wkWebViewProgress {
    if (!_wkWebViewProgress) {
        _wkWebViewProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, FFStatusBarHeight, self.view.bounds.size.width, 30)];
    }
    return _wkWebViewProgress;
}

@end
