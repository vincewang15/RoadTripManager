//
//  FourthViewControllerMake.m
//  roadTrip Storyboard
//
//  Created by NahNah Kim on 7/21/15.
//  Copyright (c) 2015 NahNah Kim. All rights reserved.
//

#import "MakePickerViewController.h"

@interface MakePickerViewController ()

@end

@implementation MakePickerViewController
@synthesize makes;
@synthesize makeSel;
@synthesize delegate;
//@synthesize makeSelected;

-(void)viewDidLoad {
    [super viewDidLoad];
    
//    [makeSelected setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
//    [makeSelected setTextColor:[UIColor whiteColor]];
//    [makeSelected setFont:[UIFont fontWithName:@"Helvetica-bold" size:18]];
//    makeSelected.textAlignment = NSTextAlignmentCenter;
    
    //makeSelected.frame = CGRectMake (0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 44.0);
    
    if ([self makes] == nil) {
        self.makes = [[NSArray alloc] initWithObjects:@"[Not Selected]", nil];
    }
    
    if ([self makeSel] == nil) {
        [self setMakeSel:[self.makes objectAtIndex:0]];//set default
        
    }
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    // set to previous/default make
    [picker selectRow:[makes indexOfObject:[self makeSel]] inComponent:0 animated:YES];
    [self.view addSubview:picker];
    
    //[makeSelected setCenter:picker.center];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    
//    UILabel *pickerRowLabel = (UILabel *)view;
//    if (pickerRowLabel==nil){
//        CGRect newframe = pickerView.frame;
//        frame.size.height = 162/180/216;
//        [pickerView setFrame:newframe];
////        pickerRowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -15, [[UIScreen mainScreen]bounds].size.width, 216)];
//        [pickerRowLabel setFont:[UIFont fontWithName:@"Helvetica-Neue" size:20]];
//        pickerRowLabel.backgroundColor = [UIColor clearColor];
//        pickerRowLabel.userInteractionEnabled = YES;
//    }
//    
//    pickerRowLabel.text = [makes objectAtIndex:row];
//    
//    return pickerRowLabel;
//}


-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [makes count];
}



-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [makes objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self setMakeSel:[[self makes] objectAtIndex:row]];
    
//    [makeSelected setText:[NSString stringWithFormat:@" Selected Car Make: %@", [makes objectAtIndex:row]]];
}



-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated {
    [delegate sendMakeSelToSecond:[[self makeSel] isEqualToString:@"[Not Selected]"] ? nil : [self makeSel]];
}
@end
