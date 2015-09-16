//
//  GasViewController.m
//  roadTrip Storyboard
//
//  Created by NahNah Kim on 7/22/15.
//  Copyright (c) 2015 NahNah Kim. All rights reserved.
//

#import "GasViewController.h"

@interface GasViewController ()

@end

@implementation GasViewController
@synthesize pickerView;
@synthesize delegate;
@synthesize gasStation;
@synthesize gasSel;
@synthesize gasSelectedLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect labelRect = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 50);
    
    gasSelectedLabel = [[UILabel alloc] initWithFrame:labelRect];
    [gasSelectedLabel setBackgroundColor:[UIColor colorWithRed:96.0/255.0 green:169.0/255.0 blue:23.0/255.0 alpha:1.0]];
    [gasSelectedLabel setTextColor:[UIColor whiteColor]];
    [gasSelectedLabel setFont:[UIFont fontWithName:@"Helvetica-bold" size:18]];
    gasSelectedLabel.textAlignment = NSTextAlignmentCenter;
    gasSelectedLabel.text = @"Selected Gas Station";
    [self.view addSubview:gasSelectedLabel];

    
    gasStation = [[NSArray alloc] initWithObjects:@"All", @"Shell", @"BP", @"Exxon", @"Mobil", @"Marathon", nil];
    
    if ([self gasSel] == nil) {
        [self setGasSel:[self.gasStation objectAtIndex:0]];//set default
        
    }
    
    UIPickerView * picker = [UIPickerView new];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow:[gasStation indexOfObject:[self gasSel]] inComponent:0 animated:YES];
    
    [self.view addSubview:picker];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;//Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [gasStation count];//Or, return as suitable for you...normally we use array for dynamic
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [gasStation objectAtIndex:row];//Or, your suitable title; like Choice-a, etc.
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self setGasSel:[[self gasStation] objectAtIndex:row]];
    [gasSelectedLabel setText:[NSString stringWithFormat:@"Selected: %@", self.gasSel]];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
     [delegate sendGasSelToSettingView:[self.gasSel isEqualToString:@"All"] ? nil : self.gasSel];
}

@end
