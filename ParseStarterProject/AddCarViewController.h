//
//  SecondViewController.h
//  roadTrip Storyboard
//
//  Created by NahNah Kim on 7/21/15.
//  Copyright (c) 2015 NahNah Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface AddCarViewController: UITableViewController


@property (nonatomic, strong) NSArray *cars;
@property (nonatomic, strong) NSMutableArray *selected;
@property(nonatomic, strong) NSArray *headers;
@property (nonatomic, strong) NSArray *info;
@property(nonatomic, strong) NSArray *infoDetails;

@property(nonatomic, strong) NSArray *years;
//@property(nonatomic, strong) NSString *yearSel;
@property(nonatomic, strong) NSArray *makes;
//@property(nonatomic, strong) NSString *makeSel;
@property(nonatomic, strong) NSArray *models;
//@property(nonatomic, strong) NSString *modelSel;
@property(nonatomic, strong) NSDictionary *options;
//@property(nonatomic, strong) NSString *optionSel;
//@property(nonatomic, strong) NSString *idSel;
@property (strong, nonatomic) IBOutlet UIButton *addVehicleButton;
//@property(nonatomic, strong) NSMutableDictionary *infoDict;
@property(nonatomic, strong) NSArray *infoKeys;

//-(IBAction)push:(id)sender;
@end
