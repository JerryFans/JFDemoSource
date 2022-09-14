//
//  JFPringMethodList.m
//  HookBugly
//
//  Created by 逸风 on 2022/9/14.
//

#import "JFPringMethodList.h"
#import <objc/runtime.h>

@implementation JFPringMethodList

+ (void)load {
    [JFPringMethodList printInstanceMethod];
    [JFPringMethodList printClassMethod];
}

+ (void)printInstanceMethod {
    Class dev = NSClassFromString(@"BLYDevice");
    
    unsigned int methodCount =0;
    
    Method* methodList = class_copyMethodList(dev,&methodCount);
    NSMutableArray *methodsArray = [NSMutableArray arrayWithCapacity:methodCount];
    
    for(int i=0;i<methodCount;i++)
    {
        Method temp = methodList[i];
        const char* name_s =sel_getName(method_getName(temp));
        NSString *name = [NSString stringWithUTF8String:name_s];
        [methodsArray addObject:name];
    }
    free(methodList);
    
    NSLog(@"====> BLYDevice 实例 methodList : %@", methodsArray.description);
}

+ (void)printClassMethod {
    Class dev = NSClassFromString(@"BLYDevice");
    
    unsigned int methodCount =0;
    
    Method* methodList = class_copyMethodList(object_getClass(dev),&methodCount);
    NSMutableArray *methodsArray = [NSMutableArray arrayWithCapacity:methodCount];
    
    for(int i=0;i<methodCount;i++)
    {
        Method temp = methodList[i];
        const char* name_s =sel_getName(method_getName(temp));
        NSString *name = [NSString stringWithUTF8String:name_s];
        [methodsArray addObject:name];
    }
    free(methodList);
    
    NSLog(@"====> BLYDevice 元类 methodList : %@", methodsArray.description);
}

@end
