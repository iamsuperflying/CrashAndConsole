//
//  LPFCrashCaught.m
//
//  Description:
//
//  Created by LPF. on 2019/6/26.
//

#import "LPFCrashCaught.h"
#import "LPFGeneric.h"
#import "LPFCrashInfo.h"

NSString * const LPFCrashFileDirectory = @"LPFCrashFiles"; //你的项目中自定义文件夹名

static inline NSString * lpf_docPath() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@implementation LPFCrashCaught

+ (instancetype)catchCrashLogs {
    LPFCrashCaught *cc = [[self alloc] init];
    [cc catchCrashLogs];
    return cc;
}

- (void)catchCrashLogs{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}
void UncaughtExceptionHandler(NSException *exception){
   [LPFCrashCaught screenShot];
    if ([LPFCrashCaught writeCrashFileToDocumentsException:exception]) {
    }
    
//    if (!exception)return;
//    NSArray  *array = [exception callStackSymbols];
//    NSString *reason = [exception reason];
//    NSString *name  = [exception name];
//    NSDictionary *dict = @{@"appException":@{@"exceptioncallStachSymbols":array,@"exceptionreason":reason,@"exceptionname":name}};
//
//    LPFCrashInfo *info = [[LPFCrashInfo alloc] init];
//    info.exception.exceptioncallStachSymbols = [exception callStackSymbols];
//    info.exception.exceptionReason = [exception reason];
//    info.exception.exceptionName = [exception name];
//
//
//    if([LPFCrashCaught writeCrashFileOnDocumentsException:dict]){
//        NSLog(@"Crash logs write ok!");
//    }
}

+ (void)screenShot {

    /**
     var shouldRun = true
     
     let runLoop = CFRunLoopGetCurrent()
     
     let alertCtrl = UIAlertController(title: "Oops", message: "Your app crashed! OAO", preferredStyle: .Alert)
     alertCtrl.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (_) in
     shouldRun = false
     }))
     
     guard let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController else {
     return
     }
     
     rootViewController.presentViewController(alertCtrl, animated: true, completion: nil)
     
     let allModesAO = CFRunLoopCopyAllModes(runLoop) as [AnyObject]
     guard let allModes = allModesAO as? [CFStringRef] else {
     return
     }
     
     while (shouldRun) {
     for mode in allModes {
     CFRunLoopRunInMode(mode, 0.001, false)
     }
     }
     */
    
    UIView *screenWindow = [[UIApplication sharedApplication].delegate.window.rootViewController view];
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, [UIScreen mainScreen].scale);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    return image;
//
//    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
//    [[UIApplication sharedApplication].delegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    NSLog(@"image %@", image);
    UIImage *i = image;
    
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *path = [lpf_docPath() stringByAppendingPathComponent:LPFCrashFileDirectory];
    NSLog(@"path %@", path);
    [data writeToFile:[path stringByAppendingPathComponent:@"pic.jpg"] atomically:YES];
    
    
    BOOL shouldRun = YES;
    CFRunLoopRef  runloop = CFRunLoopGetCurrent();
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"崩就崩" message:@"起死回生" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:rs_format(@"%@", image) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [action setValue:image forKey:@"image"];
    
    [alert addAction:action];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];

    
 
    
    CFArrayRef allModesAO = CFRunLoopCopyAllModes(runloop);
    while (shouldRun) {
        for (NSString *mode in (__bridge NSArray *)allModesAO) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModesAO);
    
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void*) contextInfo{
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功";
    }
}

+ (BOOL)writeCrashFileToDocumentsException:(NSException *)exception {
    
    if (!exception) return NO;
    
    LPFCrashInfo *info = [[LPFCrashInfo alloc] init];
    info.exception.exceptioncallStachSymbols = [exception callStackSymbols];
    info.exception.exceptionReason = [exception reason];
    info.exception.exceptionName = [exception name];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
    formatter.locale = [NSLocale currentLocale];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *crashName = rs_format(@"%@_Crashlog", time);
    info.crashName = crashName;
    
    NSString *crashnameWithFileType = rs_format(@"%@.plist",crashName);
    NSString *crashPath = [lpf_docPath() stringByAppendingPathComponent:LPFCrashFileDirectory];
    
    //设备信息
    info.deviceInfo.platformVersion = infoDict[@"DTPlatformVersion"];
    info.deviceInfo.version = infoDict[@"CFBundleShortVersionString"];
    info.deviceInfo.deviceCapabilities = infoDict[@"UIRequiredDeviceCapabilities"];
    

    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSuccess = [manager createDirectoryAtPath:crashPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (isSuccess) {
        NSLog(@"文件夹创建成功");
        NSString *filepath = [crashPath stringByAppendingPathComponent:crashnameWithFileType];
//        NSMutableDictionary *logs = [NSMutableDictionary dictionaryWithContentsOfFile:filepath];
        NSMutableArray *logs = [NSMutableArray arrayWithContentsOfFile:filepath];
        if (!logs) {
            logs = [NSMutableArray array];
        }
        
        //日志信息
        NSDictionary *infos = [info lpf_dict];

        [logs insertObject:infos atIndex:0];
        BOOL writeOK = [logs writeToFile:filepath atomically:YES];
        NSLog(@"write result = %d,filePath = %@",writeOK, filepath);
        return writeOK;
    }else{
        return NO;
    }
}

+ (BOOL)writeCrashFileOnDocumentsException:(NSDictionary *)exception{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
    formatter.locale = [NSLocale currentLocale];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *crashname = rs_format(@"%@_Crashlog", time);
    NSString *crashnameWithFileType = rs_format(@"%@.plist",crashname);
    NSString *crashPath = [lpf_docPath() stringByAppendingPathComponent:LPFCrashFileDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    //设备信息
    NSMutableDictionary *deviceInfos = [NSMutableDictionary dictionary];
    [deviceInfos setObject:[infoDictionary objectForKey:@"DTPlatformVersion"] forKey:@"DTPlatformVersion"];
    [deviceInfos setObject:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"CFBundleShortVersionString"];
    [deviceInfos setObject:[infoDictionary objectForKey:@"UIRequiredDeviceCapabilities"] forKey:@"UIRequiredDeviceCapabilities"];
    
    BOOL isSuccess = [manager createDirectoryAtPath:crashPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (isSuccess) {
        NSLog(@"文件夹创建成功");
        NSString *filepath = [crashPath stringByAppendingPathComponent:crashnameWithFileType];
        NSMutableDictionary *logs = [NSMutableDictionary dictionaryWithContentsOfFile:filepath];
        if (!logs) {
            logs = [[NSMutableDictionary alloc] init];
        }
        //日志信息
        NSDictionary *infos = @{@"Exception":exception,@"DeviceInfo":deviceInfos};
        logs[crashname] = infos;
        BOOL writeOK = [logs writeToFile:filepath atomically:YES];
        NSLog(@"write result = %d,filePath = %@",writeOK, filepath);
        return writeOK;
    }else{
        return NO;
    }
}


+ (nullable NSArray *)lpf_getCrashLogs{
    NSString *crashPath = [lpf_docPath() stringByAppendingPathComponent:LPFCrashFileDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:crashPath error:nil];
    NSMutableArray *result = [NSMutableArray array];
    if (array.count == 0) return nil;
    [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {

    }];
    
    for (NSString *name in array) {
        NSArray *crashes = [NSArray arrayWithContentsOfFile:[crashPath stringByAppendingPathComponent:name]];
       
        if (!crashes.count) {
            continue;
        }
        LPFCrashInfo *info = [LPFCrashInfo lpf_modelWithDictionary:crashes.firstObject];
        [result addObject:info];
        
        NSLog(@"%@", crashes);
    }
    return result;
}

+ (BOOL)lpf_clearCrashLogs {
    NSString *crashPath = [lpf_docPath() stringByAppendingPathComponent:LPFCrashFileDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:crashPath]) return YES; //如果不存在,则默认为删除成功
    NSArray *contents = [manager contentsOfDirectoryAtPath:crashPath error:NULL];
    if (contents.count == 0) return YES;
    NSEnumerator *enums = [contents objectEnumerator];
    NSString *filename;
    BOOL success = YES;
    while (filename = [enums nextObject]) {
        if(![manager removeItemAtPath:[crashPath stringByAppendingPathComponent:filename] error:NULL]){
            success = NO;
            break;
        }
    }
    return success;
}

+ (NSString *)lpf_getCrashPath {
    NSString *crashPath = [lpf_docPath() stringByAppendingPathComponent:LPFCrashFileDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSArray *contents = [manager contentsOfDirectoryAtPath:crashPath error:NULL];
    
    NSString *txtpath;
    for (NSString *path in contents) {
        if ([path.pathExtension isEqualToString:@"plist"]) {
            txtpath = path;
        }
    }
    return [crashPath stringByAppendingPathComponent:txtpath];
}

@end
