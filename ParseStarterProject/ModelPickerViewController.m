//
//  FifthViewControllerModel.m
//  roadTrip Storyboard
//
//  Created by NahNah Kim on 7/21/15.
//  Copyright (c) 2015 NahNah Kim. All rights reserved.
//

#import "ModelPickerViewController.h"

@interface ModelPickerViewController ()
@end

@implementation ModelPickerViewController
@synthesize models;
@synthesize modelSel;
@synthesize delegate;
//@synthesize modelSelected;

-(void)viewDidLoad {
    [super viewDidLoad];
    
//    [modelSelected setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:163.0/255.0 blue:10.0/255.0 alpha:1.0]];
//    [modelSelected setTextColor:[UIColor whiteColor]];
//    [modelSelected setFont:[UIFont fontWithName:@"Helvetica-bold" size:18]];
//    modelSelected.textAlignment = NSTextAlignmentCenter;
    
    if ([self models] == nil) {
        self.models = [[NSArray alloc] initWithObjects:@"[Not Selected]", nil];
    }
    
    if ([self modelSel] == nil) {
        [self setModelSel:[self.models objectAtIndex:0]];//set default
    }
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    // set to previous/default make
    [picker selectRow:[[self models] indexOfObject:[self modelSel]] inComponent:0 animated:YES];
    [self.view addSubview:picker];
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self models] count];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self models] objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self setModelSel:[[self models] objectAtIndex:row]];
    
//    [modelSelected setText:[NSString stringWithFormat:@"Model: %@", [models objectAtIndex:row]]];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated {
    [delegate sendModelSelToSecond:[[self modelSel] isEqualToString:@"[Not Selected]"] ? nil : [self modelSel]];
}
@end
