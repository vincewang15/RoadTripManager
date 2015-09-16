//
//  HotelOptionVC.m
//  RTMProject
//
//  Created by NahNah Kim on 7/23/15.
//
//

#import "HotelOptionVC.h"
#import "GasViewController.h"

@interface HotelOptionVC ()

@end

@implementation HotelOptionVC
@synthesize pickerView;
@synthesize delegate;
@synthesize lodging;
@synthesize lodgingSel;
@synthesize lodgingSelectedLabel;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;//Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [lodging count];//Or, return as suitable for you...normally we use array for dynamic
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [lodging objectAtIndex:row];//Or, your suitable title; like Choice-a, etc.
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect labelRect = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 50);
    
    lodgingSelectedLabel = [[UILabel alloc] initWithFrame:labelRect];
    [lodgingSelectedLabel setBackgroundColor:[UIColor colorWithRed:96.0/255.0 green:169.0/255.0 blue:23.0/255.0 alpha:1.0]];
    [lodgingSelectedLabel setTextColor:[UIColor whiteColor]];
    [lodgingSelectedLabel setFont:[UIFont fontWithName:@"Helvetica-bold" size:18]];
    lodgingSelectedLabel.textAlignment = NSTextAlignmentCenter;
    lodgingSelectedLabel.text = @"Selected Lodging";
    [self.view addSubview:lodgingSelectedLabel];
    
    lodging = [[NSArray alloc] initWithObjects:@"Best Western", @"Hyatt", @"Hilton", @"Hampton Inn", nil];
    
    UIPickerView * picker = [UIPickerView new];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [self.view addSubview:picker];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self setLodgingSel:[[self lodging]objectAtIndex:row]];
    [lodgingSelectedLabel setText:[NSString stringWithFormat:@"Selected: %@", self.lodgingSel]];
    //@TODO: add the selected lodging label here
    
}

//- (void)goToNext:(id) sender{
//    [self performSegueWithIdentifier:@"myView" sender:self];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [delegate sendHotelSelToSettingView:[self.lodgingSel isEqualToString:@"All"] ? nil : self.lodgingSel];
}

@end
