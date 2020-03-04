//
//  ViewController.m
//  KVOTest
//
//  Created by Apple on 2020/3/4.
//  Copyright © 2020 LiveStar. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+KVO.h"
@interface ViewController ()

@property(nonatomic, strong) Person *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   Person *person = [[Person alloc] init];
    [person RH_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    self.person = person;
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.person.name = @"1231321";
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@", change);
}
@end
