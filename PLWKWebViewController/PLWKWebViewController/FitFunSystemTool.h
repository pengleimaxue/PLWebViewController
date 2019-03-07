////
//  FitFunSystemTool.h
//  fitfunTool
// 系统工具类
//  Created by ___Fitfun___ on 2018/10/15.
//Copyright © 2018年 penglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/utsname.h>

//判断是否是iPhone异形屏
#define  isIPhoneXSeries()\
^(){\
    BOOL iPhoneXSerie = NO;\
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {\
        return iPhoneXSerie;\
    }\
    if (@available(iOS 11.0, *)) {\
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];\
        if (mainWindow.safeAreaInsets.bottom > 0.0) {\
            iPhoneXSerie = YES;\
        }\
    }\
    return iPhoneXSerie;\
}()

//判断横竖屏
#define isPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

#define LandscapeLeft [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft

#define LandscapeRight [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight

//获取当前屏幕宽高
#define FFDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define FFDeviceHeight ([UIScreen mainScreen].bounds.size.height)

//兼容横竖屏判断获取宽高
#define FFSCREEN_WIDTH        (!isPortrait  && FFDeviceHeight>FFDeviceWidth?FFDeviceHeight:FFDeviceWidth)

#define FFSCREEN_HEIGHT        (!isPortrait  && FFDeviceHeight>FFDeviceWidth?FFDeviceWidth:FFDeviceHeight)

//获取statusbar高度
#define FFStatusBarHeight  (isIPhoneXSeries()? 44.f : 20.f)

//顶部导航栏高度
#define FFSafeAreaTopHeight (isIPhoneXSeries()? 88 : 64)

#define FFNaverBarHeight 44.f

#define  FFSafeAreaBottomHeight         (isIPhoneXSeries()? 34.f : 0.f)

//判断设备类型
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

//获取系统版本
#define IOS_SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]

//判断系统是否大于8.0
#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))

//当前APP版本号
#define  CURRENT_APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

/**
 获取iOS设备具体型号
 可参考：https://www.theiphonewiki.com/wiki/Models
  inline 定义的类的内联函数，函数的代码被放入符号表中，在使用时直接进行替换，（像宏一样展开），没有了调用的开销，效率也很高。
 */
static inline  NSString *iOSDeviceName () {
    struct utsname systemInfo; uname(&systemInfo);
    // 获取系统设备信息
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    NSDictionary *dict = @{
                           // iPhone
                           @"iPhone5,3" : @"iPhone 5c",
                           @"iPhone5,4" : @"iPhone 5c",
                           @"iPhone6,1" : @"iPhone 5s",
                           @"iPhone6,2" : @"iPhone 5s",
                           @"iPhone7,1" : @"iPhone 6 Plus",
                           @"iPhone7,2" : @"iPhone 6",
                           @"iPhone8,1" : @"iPhone 6s",
                           @"iPhone8,2" : @"iPhone 6s Plus",
                           @"iPhone8,4" : @"iPhone SE",
                           @"iPhone9,1" : @"iPhone 7",
                           @"iPhone9,2" : @"iPhone 7 Plus",
                           @"iPhone10,1" : @"iPhone 8",
                           @"iPhone10,4" : @"iPhone 8",
                           @"iPhone10,2" : @"iPhone 8 Plus",
                           @"iPhone10,5" : @"iPhone 8 Plus",
                           @"iPhone10,3" : @"iPhone X",
                           @"iPhone10,6" : @"iPhone X",
                           @"iPhone11,2" : @"iPhone XS",
                           @"iPhone11,4" : @"iPhone XS Max",
                           @"iPhone11,6" : @"iPhone XS Max",
                           @"iPhone11,8" : @"iPhone XR",
                           @"i386" : @"iPhone Simulator",
                           @"x86_64" : @"iPhone Simulator",
                           // iPad
                           @"iPad4,1" : @"iPad Air",
                           @"iPad4,2" : @"iPad Air",
                           @"iPad4,3" : @"iPad Air",
                           @"iPad5,3" : @"iPad Air 2",
                           @"iPad5,4" : @"iPad Air 2",
                           @"iPad6,7" : @"iPad Pro 12.9",
                           @"iPad6,8" : @"iPad Pro 12.9",
                           @"iPad6,3" : @"iPad Pro 9.7",
                           @"iPad6,4" : @"iPad Pro 9.7",
                           @"iPad6,11" : @"iPad 5",
                           @"iPad6,12" : @"iPad 5",
                           @"iPad7,1" : @"iPad Pro 12.9 inch 2nd gen",
                           @"iPad7,2" : @"iPad Pro 12.9 inch 2nd gen",
                           @"iPad7,3" : @"iPad Pro 10.5",
                           @"iPad7,4" : @"iPad Pro 10.5",
                           @"iPad7,5" : @"iPad 6",
                           @"iPad7,6" : @"iPad 6",
                           // iPad mini
                           @"iPad2,5" : @"iPad mini",
                           @"iPad2,6" : @"iPad mini",
                           @"iPad2,7" : @"iPad mini",
                           @"iPad4,4" : @"iPad mini 2",
                           @"iPad4,5" : @"iPad mini 2",
                           @"iPad4,6" : @"iPad mini 2",
                           @"iPad4,7" : @"iPad mini 3",
                           @"iPad4,8" : @"iPad mini 3",
                           @"iPad4,9" : @"iPad mini 3",
                           @"iPad5,1" : @"iPad mini 4",
                           @"iPad5,2" : @"iPad mini 4",
                           // Apple Watch
                           @"Watch1,1" : @"Apple Watch",
                           @"Watch1,2" : @"Apple Watch",
                           @"Watch2,6" : @"Apple Watch Series 1",
                           @"Watch2,7" : @"Apple Watch Series 1",
                           @"Watch2,3" : @"Apple Watch Series 2",
                           @"Watch2,4" : @"Apple Watch Series 2",
                           @"Watch3,1" : @"Apple Watch Series 3",
                           @"Watch3,2" : @"Apple Watch Series 3",
                           @"Watch3,3" : @"Apple Watch Series 3",
                           @"Watch3,4" : @"Apple Watch Series 3",
                           @"Watch4,1" : @"Apple Watch Series 4",
                           @"Watch4,2" : @"Apple Watch Series 4",
                           @"Watch4,3" : @"Apple Watch Series 4",
                           @"Watch4,4" : @"Apple Watch Series 4"
                           };
    NSString *name = dict[platform];
    return name ? name : platform;
}


    
    
