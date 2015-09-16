//
//  ThirdViewControllerYear.m
//  roadTrip Storyboard
//
//  Created by NahNah Kim on 7/21/15.
//  Copyright (c) 2015 NahNah Kim. All rights reserved.
//

#import "YearPickerViewController.h"

@interface YearPickerViewController ()

@end

@implementation YearPickerViewController
@synthesize pickerView;
@synthesize years;
@synthesize delegate;
@synthesize yearSel;
//@synthesize yearSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [yearSelected setBackgroundColor:[UIColor colorWithRed:96.0/255.0 green:169.0/255.0 blue:23.0/255.0 alpha:1.0]];
//    [yearSelected setTextColor:[UIColor whiteColor]];
//    [yearSelected setFont:[UIFont fontWithName:@"Helvetica-bold" size:18]];
//    yearSelected.textAlignment = NSTextAlignmentCenter;
    
    if ([self yearSel] == nil) {
        [self setYearSel:[self.years objectAtIndex:5]]; // set 5th year as default (if first time)
    }
    
    UIPickerView * picker = [UIPickerView new];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    // set to previous(default) location
    [picker selectRow:[years indexOfObject:[self yearSel]] inComponent:0 animated:YES];
    [self.view addSubview:picker];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;//Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [years count];//Or, return as suitable for you...normally we use array for dynamic
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [years objectAtIndex:row];//Or, your suitable title; like Choice-a, etc.
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Here, like the table view you can get the each section of each row if you've multiple sections
    //NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayColors objectAtIndex:row], row);
    
    //Now, if you want to navigate then;
    // Say, OtherViewController is the controller, where you want to navigate:
    [self setYearSel:[[self years] objectAtIndex:row]];
    
//      [yearSelected setText:[NSString stringWithFormat:@" Year Car Manufactured: %@", [years objectAtIndex:row]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [delegate sendDataToSecond:[self yearSel]];
}

@end

