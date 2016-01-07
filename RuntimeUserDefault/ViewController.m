//
//  ViewController.m
//  RuntimeUserDefault
//
//  Created by ND on 16/1/7.
//  Copyright © 2016年 LJH. All rights reserved.
//

#import "ViewController.h"
#import "HYUserDefaults.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet UILabel *output;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)save:(id)sender {
    [HYUserDefaults shareInstance].testString = _input.text;
}
- (IBAction)load:(id)sender {
    _output.text = [NSString stringWithFormat:@"读取:%@",[HYUserDefaults shareInstance].testString];

}
- (IBAction)reset:(id)sender {
    [[HYUserDefaults shareInstance] reset];
}
@end
