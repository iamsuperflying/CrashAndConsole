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

NSString * const LPFCrashFileDirectory = @"LPFCrashFiles";

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

+ (NSString *)screenShot {
    __block NSString *screenShot;
    dispatch_async_on_main_queue(^{
        UIWindow *screenWindow = [UIApplication sharedApplication].delegate.window;
        UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, 1);
        [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSLog(@"image %@", image);
        NSData *data = UIImagePNGRepresentation(image);
        screenShot = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    });
    
    return screenShot;
    
    /** x写入沙盒
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *path = [lpf_docPath() stringByAppendingPathComponent:LPFCrashFileDirectory];
    NSLog(@"path %@", path);
    [data writeToFile:[path stringByAppendingPathComponent:@"pic.jpg"] atomically:YES];
    */
    
    /** runloop 保活一次
    BOOL shouldRun = YES;
    CFRunLoopRef  runloop = CFRunLoopGetCurrent();

    CFArrayRef allModesAO = CFRunLoopCopyAllModes(runloop);
    while (shouldRun) {
        for (NSString *mode in (__bridge NSArray *)allModesAO) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModesAO);
     */
    
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
    info.crashImage = [LPFCrashCaught screenShot];
    
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
