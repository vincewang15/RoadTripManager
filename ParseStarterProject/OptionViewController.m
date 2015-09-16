//
//  OptionViewController.m
//  RTMProject
//
//  Created by Yu Xiao on 7/23/15.
//
//

#import "OptionViewController.h"

@interface OptionViewController ()

@end

@implementation OptionViewController
@synthesize options;
@synthesize optionSel;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self options] == nil || !self.options.count) {
        self.options = [[NSArray alloc] initWithObjects:@"[Not Selected]", nil];
    }
    
    if ([self optionSel] == nil) {
        [self setOptionSel:[self.options objectAtIndex:0]];//set default
    }
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    // set to previous/default make
    [picker selectRow:[[self options] indexOfObject:[self optionSel]] inComponent:0 animated:YES];
    [self.view addSubview:picker];
    
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self options] count];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self options] objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self setOptionSel:[[self options] objectAtIndex:row]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [delegate sendOptionSelToSecond:[[self optionSel] isEqualToString:@"[Not Selected]"] ? nil : [self optionSel]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
