//
//  ViewController.m
//  AddressManagement
//
//  Created by TuFa on 16/7/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "AddressPickView.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()

@property(nonatomic,strong)NSDictionary *dictionary;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    
    [self creatSubviews];
}

-(void)creatSubviews{
    
    NSArray *array = @[@"地区:",@"邮编:"];
    
    for (int i=0; i<array.count; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60+i*40, 50, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = array[i];
        [self.view addSubview:label];
        
        if (i == 0) {
            
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(50, 60+i*40, KScreenWidth-70, 30)];
            label2.layer.cornerRadius = 5;
            label2.clipsToBounds = YES;
            label2.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:label2];
            label2.tag = 50;
            label2.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAddressPickView)];
            [label2 addGestureRecognizer:tap];

        }else{
            
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 60+i*40, KScreenWidth-70, 30)];
            textField.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:textField];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.tag = 100;
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)showAddressPickView
{
    [self.view endEditing:YES];
    
    AddressPickView *addressPickView = [AddressPickView shareInstance];
    [self.view addSubview:addressPickView];
    addressPickView.block = ^(NSString *province,NSString *city,NSString *town){

        UILabel *label1 = [self.view viewWithTag:50];
        UITextField *TextField = [self.view viewWithTag:100];//邮编
        
        label1.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,town];
        
        for (NSString *str in self.dictionary) {
            
            if([str rangeOfString:city].location != NSNotFound)
            {
                
                TextField.text = self.dictionary[str];
            }
        }
    };
}

//懒加载
-(NSDictionary *)dictionary{
    
    if(!_dictionary){
        
        //获取邮编 citys.plist
        NSString *path=[[NSBundle mainBundle]pathForResource:@"citys.plist" ofType:nil];
        _dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _dictionary;
}

@end
