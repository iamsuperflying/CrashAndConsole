//
//  LPFCrashInfo.m
//  Log
//
//  Created by 李鹏飞 on 2019/6/29.
//  Copyright © 2019 李鹏飞. All rights reserved.
//

#import "LPFCrashInfo.h"
#import "LPFGeneric.h"

@implementation LPFCrashInfo
//
//{
//    BuildMachineOSBuild = 19A487l;
//    CFBundleDevelopmentRegion = en;
//    CFBundleExecutable = Log;
//    CFBundleIdentifier = "com.flying.test";
//    CFBundleInfoDictionaryVersion = "6.0";
//    CFBundleName = Log;
//    CFBundleNumericVersion = 16809984;
//    CFBundlePackageType = APPL;
//    CFBundleShortVersionString = "1.0";
//    CFBundleSupportedPlatforms =     (
//                                      iPhoneSimulator
//                                      );
//    CFBundleVersion = 1;
//    DTCompiler = "com.apple.compilers.llvm.clang.1_0";
//    DTPlatformBuild = 11M337n;
//    DTPlatformName = iphonesimulator;
//    DTPlatformVersion = "13.0";
//    DTSDKBuild = 17A5508l;
//    DTSDKName = "iphonesimulator13.0";
//    DTXcode = 1100;
//    DTXcodeBuild = 11M337n;
//    LSRequiresIPhoneOS = 1;
//    MinimumOSVersion = "9.0";
//    UIDeviceFamily =     (
//                          1,
//                          2
//                          );
//    UILaunchStoryboardName = LaunchScreen;
//    UIMainStoryboardFile = Main;
//    UIRequiredDeviceCapabilities =     (
//                                        armv7
//                                        );
//    UISupportedInterfaceOrientations =     (
//                                            UIInterfaceOrientationPortrait,
//                                            UIInterfaceOrientationLandscapeLeft,
//                                            UIInterfaceOrientationLandscapeRight
//                                            );
//}

- (NSAttributedString *)crash {
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    //设备信息
    /*
    NSString *appname = infoDict[@"CFBundleName"];
    NSString *platformVersion = infoDict[@"DTPlatformVersion"];
    NSString *version = infoDict[@"CFBundleShortVersionString"];
    NSArray *deviceCapabilities = infoDict[@"UIRequiredDeviceCapabilities"];
     */
    
    NSString *appName = rs_format(@"应用程序: %@\n", infoDict[@"CFBundleName"]);
    NSString *platformVersion = rs_format(@"设备名称: %@(%@)\n", infoDict[@"DTPlatformVersion"], infoDict[@"DTPlatformVersion"]);
    NSString *version = rs_format(@"软件版本: %@(%@)\n", infoDict[@"DTPlatformVersion"]);
    NSArray *deviceCapabilitiesArr = infoDict[@"UIRequiredDeviceCapabilities"];
    NSString *deviceCapabilities = [deviceCapabilitiesArr componentsJoinedByString:@","];
    NSString *crash = rs_format(@"%@\n%@\n%@\n%@\n", appName, platformVersion, version, deviceCapabilities);
    
    NSDictionary<NSAttributedStringKey, id> *attrs = @{
                                                       NSForegroundColorAttributeName: [UIColor blackColor],
                                                       NSFontAttributeName: [UIFont systemFontOfSize:14]
                                                       };
    NSMutableAttributedString *crashAttrM = [[NSMutableAttributedString alloc] initWithString:crash
                                                                                   attributes:attrs];
    if (self.crashImage) {
    // 文字中加图片
    NSTextAttachment *attachment=[[NSTextAttachment alloc] init];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self.crashImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *crashImage = [UIImage imageWithData:data];
    attachment.image = crashImage;
    attachment.bounds = CGRectMake(0, 0, crashImage.size.width, crashImage.size.height);
    NSAttributedString *attr = [NSAttributedString attributedStringWithAttachment:attachment];
    [crashAttrM appendAttributedString:attr];
    }
    return crashAttrM.copy;
    
}

- (LPFException *)exception {
    if (!_exception) {
        _exception = [[LPFException alloc] init];
    }
    return _exception;
}

- (LPFDeviceInfo *)deviceInfo {
    if (!_deviceInfo) {
        _deviceInfo = [[LPFDeviceInfo alloc] init];
    }
    return _deviceInfo;
}

@end

@implementation LPFDeviceInfo
@end

@implementation LPFException
@end


