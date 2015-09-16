////
////  GasOptionVC.m
////  RTMProject
////
////  Created by NahNah Kim on 7/23/15.
////
////
//
//#import "GasOptionViewController.h"
//#import "GasViewController.h"
//
//@interface GasOptionViewController ()
//
//@end
//
//@implementation GasOptionViewController
//@synthesize pickerView;
//@synthesize delegate;
//@synthesize gasStation;
//@synthesize gasSel;
//@synthesize gas;
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
//    
//    return 1;//Or return whatever as you intend
//}
//
//- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
//    
//    return [gasStation count];//Or, return as suitable for you...normally we use array for dynamic
//}
//
//- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return [gasStation objectAtIndex:row];//Or, your suitable title; like Choice-a, etc.
//}
//
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    gasStation = [[NSArray alloc] initWithObjects:@"Shell", @"BP", @"Exxon", @"Mobil", @"Marathon", nil];
//    
//    UIPickerView * picker = [UIPickerView new];
//    picker.delegate = self;
//    picker.dataSource = self;
//    picker.showsSelectionIndicator = YES;
//        [picker selectRow:[gasStation indexOfObject:[self gasSel]] inComponent:0 animated:YES];
//    
//    [self.view addSubview:picker];
//    // Do any additional setup after loading the view, typically from a nib.
//}
//
//- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    
//    //Here, like the table view you can get the each section of each row if you've multiple sections
//    //NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayColors objectAtIndex:row], row);
//    
//    //Now, if you want to navigate then;
//    // Say, OtherViewController is the controller, where you want to navigate:
//    
//    GasViewController *gasVC;
//    [self.navigationController pushViewController:gasVC animated:YES];
//    
//}
//
////- (void)goToNext:(id) sender{
////    [self performSegueWithIdentifier:@"myView" sender:self];
////}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [delegate sendGasDataToGasView:@"Apple"];
//}
//
//@end
