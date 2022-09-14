//
//  JFDevicelTool.m
//  HookBugly
//
//  Created by 逸风 on 2022/9/14.
//

#import "JFDevicelTool.h"
#import <objc/runtime.h>

@implementation JFDevicelTool

+ (void)load {
    
    //从类名获取UIDevice
    Class uidevClass = NSClassFromString(@"UIDevice");
    
    SEL identifierSel = NSSelectorFromString(@"identifierForVendor");
    //步骤一
    Method originIdentifierMethod = class_getInstanceMethod(uidevClass, identifierSel);
    
    if (!originIdentifierMethod) {
        return;
    }
    
    Method jf_identifierForVendor = class_getInstanceMethod([self class], @selector(jf_identifierForVendor));
    
    class_addMethod(uidevClass, @selector(jf_identifierForVendor), method_getImplementation(originIdentifierMethod), method_getTypeEncoding(originIdentifierMethod));
    
    class_addMethod(uidevClass, identifierSel, method_getImplementation(jf_identifierForVendor), method_getTypeEncoding(jf_identifierForVendor));
    
    method_exchangeImplementations(originIdentifierMethod, jf_identifierForVendor);
    
    //从类名获取Bugly工具类
    Class dev = NSClassFromString(@"BLYDevice");
    
    //获取元类
    Class spc = class_getSuperclass(dev);

    SEL sel = NSSelectorFromString(@"idfv");
    //步骤一
    Method originIdfv = class_getClassMethod(dev, sel);
    
    if (!originIdfv) {
        return;
    }

    Method jf_bugly_uuid = class_getClassMethod([self class], @selector(jf_bugly_uuid));
    
    class_addMethod(spc, @selector(jf_bugly_uuid), method_getImplementation(originIdfv), method_getTypeEncoding(originIdfv));
    
    class_addMethod(spc, sel, method_getImplementation(jf_bugly_uuid), method_getTypeEncoding(jf_bugly_uuid));

    method_exchangeImplementations(originIdfv, jf_bugly_uuid);

}

- (NSUUID *)jf_identifierForVendor {
    NSUUID *uuid = [self jf_identifierForVendor];
    NSLog(@"jf_identifierForVendor: %@",uuid.UUIDString);
    return uuid;
}

+ (NSString *)jf_bugly_uuid {
    //如果检测到隐私弹窗没同意，不拿值。 这里可以自己拿持久化的值。
    BOOL needShowAlert = NO;
    if (needShowAlert) {
        NSString *unknowID = @"00000000-0000-0000-0000-000000000000";
        return unknowID;
    }
    NSString *buglyUUID = [self jf_bugly_uuid];
    NSLog(@"buglyUUID: %@ ",buglyUUID);
    return buglyUUID;
}

@end
