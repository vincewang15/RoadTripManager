//
//  FoodOptionVC.m
//  RTMProject
//
//  Created by NahNah Kim on 7/23/15.
//
//

#import "FoodOptionVC.h"
#import "GasViewController.h"

@interface FoodOptionVC ()

@end

@implementation FoodOptionVC
@synthesize pickerView;
@synthesize delegate;
@synthesize food;
@synthesize foodSel;
@synthesize foodSelectedLabel;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;//Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [food count];//Or, return as suitable for you...normally we use array for dynamic
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [food objectAtIndex:row];//Or, your suitable title; like Choice-a, etc.
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect labelRect = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 50);
    
    foodSelectedLabel = [[UILabel alloc] initWithFrame:labelRect];
    [foodSelectedLabel setBackgroundColor:[UIColor colorWithRed:96.0/255.0 green:169.0/255.0 blue:23.0/255.0 alpha:1.0]];
    [foodSelectedLabel setTextColor:[UIColor whiteColor]];
    [foodSelectedLabel setFont:[UIFont fontWithName:@"Helvetica-bold" size:18]];
    foodSelectedLabel.textAlignment = NSTextAlignmentCenter;
    foodSelectedLabel.text = @"Selected Food Style";
    [self.view addSubview:foodSelectedLabel];
    
    food = [[NSArray alloc] initWithObjects:
            @"Barbeque",
            @"Breakfast & Brunch",
            @"Burgers",
            @"Chinese",
            @"Comfort Food",
            @"Diners",
            @"Fast Food",
            @"Gluten-Free",
            @"Halal",
            @"Indian",
            @"Italian",
            @"Japanese",
            @"Korean",
            @"Kosher",
            @"Mediterranean",
            @"Mexican",
            @"Pizza",
            @"Salad",
            @"Sandwiches",
            @"Seafood",
            @"Soup",
            @"Thai",
            @"Vegan",
            @"Vegetarian",
            @"Vietnamese",
            nil];
    
    UIPickerView * picker = [UIPickerView new];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [self.view addSubview:picker];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Here, like the table view you can get the each section of each row if you've multiple sections
    //NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayColors objectAtIndex:row], row);
    
    //Now, if you want to navigate then;
    // Say, OtherViewController is the controller, where you want to navigate:
    
//    GasViewController *gasVC;
//    [self.navigationController pushViewController:gasVC animated:YES];
    [self setFoodSel:[[self food]objectAtIndex:row]];
    [foodSelectedLabel setText:[NSString stringWithFormat:@"Selected: %@", self.foodSel]];
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
    [delegate sendFoodSelToSettingView:[self.foodSel isEqualToString:@"All"] ? nil : self.foodSel];
}


@end