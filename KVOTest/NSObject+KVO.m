//
//  NSObject+KVO.m
//  KVOTest
//
//  Created by Apple on 2020/3/4.
//  Copyright © 2020 LiveStar. All rights reserved.
//

#import "NSObject+KVO.h"

#import <objc/message.h>
@implementation NSObject (KVO)
-(void)RH_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    // 1.获取当前类的名字
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName  = [@"RHNotifying_" stringByAppendingString: oldClassName];
    //2.使用runtime添加类（参数：父类， 类名）
    Class myClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    //3.注册类
    objc_registerClassPair(myClass);
    //4.动态修改self的类型
    object_setClass(self, myClass);
    
    //5.重写set方法->给子类对象添加set方法
        //获取方法名
    NSString *methodName = [@"set" stringByAppendingString:keyPath.capitalizedString];
    methodName = [methodName stringByAppendingString:@":"]; //因为有参数，所以方法名要加:
    SEL setMethod = NSSelectorFromString(methodName);

    class_addMethod(myClass, setMethod, (IMP)setCustomMethod, "v@:@");
    //6.为当前类绑定一个observer属性，方便在setName中获取
    objc_setAssociatedObject(self, (__bridge const void *)@"oberver", observer, OBJC_ASSOCIATION_ASSIGN);
    //7.为当前类绑定一个keyPath,方便在setName中获取
    objc_setAssociatedObject(self, (__bridge const void *)@"keyPath", keyPath, OBJC_ASSOCIATION_ASSIGN);
}
void setCustomMethod(id self, SEL _cmd, NSString *new){
    //调用父类的set方法给name赋值
    struct objc_super person = {
        self,
        class_getSuperclass([self class])
    };
    // 修改父类的属性
    objc_msgSendSuper(&person, _cmd, new);
    
    //获取observer，发送observeValueForKeyPath方法
    id observer = objc_getAssociatedObject(self, @"oberver");
    id keyPath = objc_getAssociatedObject(self, @"keyPath");
    objc_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:),keyPath,self, @{keyPath: new}, nil);
    
}
@end
