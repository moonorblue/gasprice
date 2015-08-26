//
//  ViewController.m
//  GasPrice
//
//  Created by KaeJer Cho on 2015/8/9.
//  Copyright (c) 2015年 KaeJer Cho. All rights reserved.
//

#import "ViewController.h"

#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface ViewController ()

@end
NSArray* cpcArray;
NSArray* fpccArray;
NSString* cpcDate;
NSString* fpccDate;
@implementation ViewController

- (void)viewDidLoad
{
    
    cpcArray = [NSArray array];
    fpccArray = [NSArray array];
    [super viewDidLoad];
    [self applyCooridinate];
    [self QueryData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)QueryData
{
    __block int count = 0;
    PFQuery* query = [PFQuery queryWithClassName:@"CPCObj"];
    [query orderByDescending:@"timestamp"];
    //    [query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject* object in objects) {
                //                NSLog(@"%@", object[@"normal_price"]);
                NSString* cpcstr = object[@"normal_price"];
                NSCharacterSet* c = [NSCharacterSet characterSetWithCharactersInString:@"[] "];
                cpcArray = [[[cpcstr componentsSeparatedByCharactersInSet:c]
                    componentsJoinedByString:@""]
                    componentsSeparatedByString:@","];

                cpcDate = object[@"date"];
                break;
            }
            count += 1;
            if (count == 2) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self applyData];
                self.Refresh.enabled = YES;
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    query = [PFQuery queryWithClassName:@"FPCCObj"];
    [query orderByDescending:@"timestamp"];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject* object in objects) {
                //                NSLog(@"%@", object[@"normal_price"]);
                NSString* fpccstr = object[@"normal_price"];
                NSCharacterSet* c = [NSCharacterSet characterSetWithCharactersInString:@"[] "];
                fpccArray = [[[fpccstr componentsSeparatedByCharactersInSet:c]
                    componentsJoinedByString:@""]
                    componentsSeparatedByString:@","];
                fpccDate = object[@"date"];
                break;
            }
            count += 1;
            if (count == 2) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self applyData];
                self.Refresh.enabled = YES;
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (IBAction)UpdateClick:(id)sender
{
    self.Refresh.enabled = NO;
    [self QueryData];
}
- (void)applyData
{
    self.CPCP1.text = cpcArray[0];
    self.CPCP2.text = cpcArray[1];
    self.CPCP3.text = cpcArray[2];
    self.CPCP4.text = cpcArray[3];

    self.FPCCP1.text = fpccArray[0];
    self.FPCCP2.text = fpccArray[1];
    self.FPCCP3.text = fpccArray[2];
    self.FPCCP4.text = fpccArray[3];

    self.CPCDate.text = cpcDate;
    self.FPCCDate.text = fpccDate;
}

- (void)applyCooridinate
{
    self.CPC.center = CGPointMake(self.view.frame.size.width * 0.45, self.gas1.center.y - 50);
    self.CPCP1.center = CGPointMake(self.view.frame.size.width * 0.45, self.gas1.center.y);
    self.CPCP2.center = CGPointMake(self.view.frame.size.width * 0.45, self.gas2.center.y);
    self.CPCP3.center = CGPointMake(self.view.frame.size.width * 0.45, self.gas3.center.y);
    self.CPCP4.center = CGPointMake(self.view.frame.size.width * 0.45, self.gas4.center.y);
    self.CPCDate.center = CGPointMake(self.view.frame.size.width * 0.45, self.applrDate.center.y);
    self.FPCC.center = CGPointMake(self.view.frame.size.width * 0.75, self.gas1.center.y - 50);
    self.FPCCP1.center = CGPointMake(self.view.frame.size.width * 0.75, self.gas1.center.y);
    self.FPCCP2.center = CGPointMake(self.view.frame.size.width * 0.75, self.gas2.center.y);
    self.FPCCP3.center = CGPointMake(self.view.frame.size.width * 0.75, self.gas3.center.y);
    self.FPCCP4.center = CGPointMake(self.view.frame.size.width * 0.75, self.gas4.center.y);
    self.FPCCDate.center = CGPointMake(self.view.frame.size.width * 0.75, self.applrDate.center.y);
    self.Refresh.center = CGPointMake(self.view.frame.size.width / 2, self.applrDate.center.y * 1.2);
}
@end
