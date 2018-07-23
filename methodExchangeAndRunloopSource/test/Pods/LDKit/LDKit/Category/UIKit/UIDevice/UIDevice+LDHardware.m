//
//  UIDevice+LDHardware.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  Copyright © 2016年 david. All rights reserved.
//

#import "UIDevice+LDHardware.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation UIDevice (LDHardware)

//- (NSString *)platform
//{
//    static NSString *platform;
//    if (!platform) {
//        size_t size;
//        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//        char *machine = malloc(size);
//        sysctlbyname("hw.machine", machine, &size, NULL, 0);
//        platform = [NSString stringWithUTF8String:machine];
//        free(machine);
//    }
//    return platform;
//}

+ (NSString *)ld_humanReadablePlatform
{
    static NSString *platform;
    if (!platform) {
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        platform = [NSString stringWithUTF8String:machine];
        free(machine);
    }
    
    return [UIDevice ld_convertMachineModelToPlatform:platform];
}

+ (NSString *)ld_convertMachineModelToPlatform:(NSString *)machine {
    if ([machine isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([machine isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([machine isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([machine isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([machine isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([machine isEqualToString:@"iPhone3,3"]) return @"Verizon iPhone 4";
    if ([machine isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([machine isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (GSM)";
    if ([machine isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (GSM+CDMA)";
    if ([machine isEqualToString:@"iPhone5,3"]) return @"iPhone 5C (GSM)";
    if ([machine isEqualToString:@"iPhone5,4"]) return @"iPhone 5C (GSM+CDMA)";
    if ([machine isEqualToString:@"iPhone6,1"]) return @"iPhone 5S (GSM)";
    if ([machine isEqualToString:@"iPhone6,2"]) return @"iPhone 5S (GSM+CDMA)";
    if ([machine isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([machine isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([machine isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    if ([machine isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    if ([machine isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([machine isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([machine isEqualToString:@"iPhone9,3"]) return @"iPhone 7 (A1778)";
    if ([machine isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([machine isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus (A1784)";
    if ([machine isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([machine isEqualToString:@"iPhone10,4"]) return @"iPhone 8 (A1905)";
    if ([machine isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([machine isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus (A1897)";
    if ([machine isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([machine isEqualToString:@"iPhone10,6"]) return @"iPhone X (A1901)";
    if ([machine isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([machine isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([machine isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([machine isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([machine isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([machine isEqualToString:@"iPod7,1"]) return @"iPod Touch 6G";
    if ([machine isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([machine isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([machine isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([machine isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([machine isEqualToString:@"iPad2,4"]) return @"iPad 2 (WiFi)";
    if ([machine isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";
    if ([machine isEqualToString:@"iPad2,6"]) return @"iPad Mini (GSM)";
    if ([machine isEqualToString:@"iPad2,7"]) return @"iPad Mini (GSM+CDMA)";
    if ([machine isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";
    if ([machine isEqualToString:@"iPad3,2"]) return @"iPad 3 (GSM+CDMA)";
    if ([machine isEqualToString:@"iPad3,3"]) return @"iPad 3 (GSM)";
    if ([machine isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
    if ([machine isEqualToString:@"iPad3,5"]) return @"iPad 4 (GSM)";
    if ([machine isEqualToString:@"iPad3,6"]) return @"iPad 4 (GSM+CDMA)";
    if ([machine isEqualToString:@"iPad4,1"]) return @"iPad Air (A1474)";
    if ([machine isEqualToString:@"iPad4,2"]) return @"iPad Air (A1475)";
    if ([machine isEqualToString:@"iPad4,3"]) return @"iPad Air (A1476)";
    if ([machine isEqualToString:@"iPad4,4"]) return @"iPad Mini 2 (A1489)";
    if ([machine isEqualToString:@"iPad4,5"]) return @"iPad Mini 2 (A1490)";
    if ([machine isEqualToString:@"iPad4,6"]) return @"iPad Mini 2 (A1491)";
    if ([machine isEqualToString:@"iPad4,7"]) return @"iPad Mini 3 (A1599)";
    if ([machine isEqualToString:@"iPad4,8"]) return @"iPad Mini 3 (A1600)";
    if ([machine isEqualToString:@"iPad4,9"]) return @"iPad Mini 3 (A1601)";
    if ([machine isEqualToString:@"iPad5,1"]) return @"iPad Mini 4 (A1538)";
    if ([machine isEqualToString:@"iPad5,2"]) return @"iPad Mini 4 (A1550)";
    if ([machine isEqualToString:@"iPad5,3"]) return @"iPad Air 2 (A1566)";
    if ([machine isEqualToString:@"iPad5,4"]) return @"iPad Air 2 (A1567)";
    if ([machine isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7' (A1673)";
    if ([machine isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7' (A1674)";
    if ([machine isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9' (A1584)";
    if ([machine isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9' (A1652)";
    if ([machine isEqualToString:@"iPad6,11"]) return @"iPad 5 (A1822)";
    if ([machine isEqualToString:@"iPad6,12"]) return @"iPad 5 (A1823)";
    if ([machine isEqualToString:@"iPad7,1"]) return @"iPad Pro2 12.9' (A1670)";
    if ([machine isEqualToString:@"iPad7,2"]) return @"iPad Pro2 12.9' (A1821)";
    if ([machine isEqualToString:@"iPad7,3"]) return @"iPad Pro 10.5' (A1701)";
    if ([machine isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5' (A1709)";
    //    if ([machine isEqualToString:@"i386"]) return @"Simulator";
    //    if ([machine isEqualToString:@"x86_64"]) return @"Simulator";
    
    if ([machine isEqualToString:@"i386"] || [machine isEqualToString:@"x86_64"]) {
        return [[[NSProcessInfo alloc] init] environment][@"SIMULATOR_DEVICE_NAME"];
    }
    
    return machine;
}

#pragma mark sysctlbyname utils

+ (NSString *) ld_getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

+ (NSString *) ld_platform
{
    return [UIDevice ld_getSysInfoByName:"hw.machine"];
}

#pragma mark sysctl utils
+ (NSUInteger) ld_getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

+ (NSUInteger) ld_cpuFrequency
{
    return [UIDevice ld_getSysInfo:HW_CPU_FREQ];
}

+ (NSUInteger) ld_busFrequency
{
    return [UIDevice ld_getSysInfo:HW_BUS_FREQ];
}

+ (NSUInteger) ld_cpuCount
{
    return [UIDevice ld_getSysInfo:HW_NCPU];
}

+ (NSUInteger) ld_totalMemory
{
    return [UIDevice ld_getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger) ld_userMemory
{
    return [UIDevice ld_getSysInfo:HW_USERMEM];
}

+ (NSUInteger) maxSocketBufferSize
{
    return [UIDevice ld_getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!

+ (NSNumber *) ld_totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

+ (NSNumber *) ld_freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark platform type and name utils
+ (NSUInteger) ld_platformType
{
    NSString *platform = [UIDevice ld_platform];
    
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDevice3GiPhone;
    if ([platform isEqualToString:@"iPhone2,1"])    return UIDevice3GSiPhone;
    //3.1 3.2 3.3 都是iPhone4
    if ([platform hasPrefix:@"iPhone3"])    return UIDevice4iPhone;
    //4.1
    if ([platform hasPrefix:@"iPhone4"])    return UIDevice4SiPhone;
    //5.1 5.2
    if ([platform isEqualToString:@"iPhone5,1"])            return UIDevice5iPhone;
    if ([platform isEqualToString:@"iPhone5,2"])            return UIDevice5iPhone;
    //5.3 5.4
    if ([platform isEqualToString:@"iPhone5,3"])            return UIDevice5CiPhone;
    if ([platform isEqualToString:@"iPhone5,4"])            return UIDevice5CiPhone;
    //6.1 6.2
    if ([platform isEqualToString:@"iPhone6,1"])            return UIDevice5SiPhone;
    if ([platform isEqualToString:@"iPhone6,2"])            return UIDevice5SiPhone;
    
    if ([platform isEqualToString:@"iPhone7,1"]) return UIDevice6PlusiPhone;
    if ([platform isEqualToString:@"iPhone7,2"]) return UIDevice6iPhone;
    if ([platform isEqualToString:@"iPhone8,1"]) return UIDevice6SiPhone;
    if ([platform isEqualToString:@"iPhone8,2"]) return UIDevice6SPlusiPhone;
    if ([platform isEqualToString:@"iPhone8,4"]) return UIDevice5SEiPhone;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])              return UIDevice1GiPod;
    if ([platform hasPrefix:@"iPod2"])              return UIDevice2GiPod;
    if ([platform hasPrefix:@"iPod3"])              return UIDevice3GiPod;
    if ([platform hasPrefix:@"iPod4"])              return UIDevice4GiPod;
    if ([platform hasPrefix:@"iPod5"])              return UIDevice5GiPod;
    if ([platform hasPrefix:@"iPod7"])              return UIDevice6GiPod;
    
    // iPad
    
    if ([platform isEqualToString:@"iPad1,1"])   return UIDevice1GiPad;
    
    if ([platform isEqualToString:@"iPad2,1"])   return UIDevice2GiPad;
    if ([platform isEqualToString:@"iPad2,2"])   return UIDevice2GiPad;
    if ([platform isEqualToString:@"iPad2,3"])   return UIDevice2GiPad;
    if ([platform isEqualToString:@"iPad2,4"])   return UIDevice2GiPad;
    if ([platform isEqualToString:@"iPad2,5"])   return UIDevice1MiniGiPad;
    if ([platform isEqualToString:@"iPad2,6"])   return UIDevice1MiniGiPad;
    if ([platform isEqualToString:@"iPad2,7"])   return UIDevice1MiniGiPad;
    
    if ([platform isEqualToString:@"iPad3,1"])   return UIDevice3GiPad;
    if ([platform isEqualToString:@"iPad3,2"])   return UIDevice3GiPad;
    if ([platform isEqualToString:@"iPad3,3"])   return UIDevice3GiPad;
    if ([platform isEqualToString:@"iPad3,4"])   return UIDevice3GiPad;
    if ([platform isEqualToString:@"iPad3,5"])   return UIDevice3GiPad;
    if ([platform isEqualToString:@"iPad3,6"])   return UIDevice3GiPad;
    
    if ([platform isEqualToString:@"iPad4,1"])   return UIDeviceiPadAir;
    if ([platform isEqualToString:@"iPad4,2"])   return UIDeviceiPadAir;
    if ([platform isEqualToString:@"iPad4,3"])   return UIDeviceiPadAir;
    
    if ([platform isEqualToString:@"iPad4,4"])   return UIDevice2MiniGiPad;
    if ([platform isEqualToString:@"iPad4,5"])   return UIDevice2MiniGiPad;
    if ([platform isEqualToString:@"iPad4,6"])   return UIDevice2MiniGiPad;
    if ([platform isEqualToString:@"iPad4,7"])   return UIDevice3MiniGiPad;
    if ([platform isEqualToString:@"iPad4,8"])   return UIDevice3MiniGiPad;
    if ([platform isEqualToString:@"iPad4,9"])   return UIDevice3MiniGiPad;
    if ([platform isEqualToString:@"iPad5,1"])   return UIDevice4MiniGiPad;
    if ([platform isEqualToString:@"iPad5,2"])   return UIDevice4MiniGiPad;
    if ([platform isEqualToString:@"iPad5,3"])   return UIDeviceiPadAir2;
    if ([platform isEqualToString:@"iPad5,4"])   return UIDeviceiPadAir2;
    if ([platform isEqualToString:@"iPad6,3"])   return UIDeviceiPadPro9_7;
    if ([platform isEqualToString:@"iPad6,4"])   return UIDeviceiPadPro9_7;
    if ([platform isEqualToString:@"iPad6,7"])   return UIDeviceiPadPro12_9;
    if ([platform isEqualToString:@"iPad6,8"])   return UIDeviceiPadPro12_9;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])           return UIDeviceAppleTV3;
    //未知设备
    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])            return UIDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
    }
    
    return UIDeviceUnknown;
}

+ (BOOL) ld_hasRetinaDisplay
{
    return ([UIScreen mainScreen].scale == 2.0f);
}

+ (UIDeviceFamily) ld_deviceFamily
{
    NSString *platform = [UIDevice ld_platform];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"]) return UIDeviceFamilyAppleTV;
    
    return UIDeviceFamilyUnknown;
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
+ (NSString *) ld_macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    return outstring;
}

@end
