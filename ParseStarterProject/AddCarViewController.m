//
//  SecondViewController.m
//  roadTrip Storyboard
//
//  Created by NahNah Kim on 7/21/15.
//  Copyright (c) 2015 NahNah Kim. All rights reserved.
//

#import "AddCarViewController.h"
#import "YearPickerViewController.h"
#import "MakePickerViewController.h"
#import "ModelPickerViewController.h"
#import "OptionViewController.h"
#import "CarInfo.h"

@interface AddCarViewController ()
#define YEAR_ROW        0
#define MAKE_ROW        1
#define MODEL_ROW       2
#define OPTION_ROW      3
#define MENU_SECTION    0
#define INFO_SECTION    1
@property(retain) CarInfo *CarSelInfo;
@end


@implementation AddCarViewController
@synthesize cars;
@synthesize headers;
@synthesize info;
@synthesize selected;
@synthesize years;
@synthesize makes;
@synthesize models;
@synthesize options;
@synthesize infoKeys;
@synthesize addVehicleButton;
@synthesize CarSelInfo;

- (IBAction)addVehicleOnClick:(id)sender {
    // validation all fields and store to loacal/remote database
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.CarSelInfo saveCarInfoToCloud:^(BOOL successed, NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!successed){
            NSLog(@"Error: %@", error);
            [[[UIAlertView alloc] initWithTitle:@"Add Vehicle Failed" message:@"Make Sure you fill out all of the information and Do Not add a duplicated vehicle" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            // perform segue to car-list view
            [self performSegueWithIdentifier:@"confirm-add segue" sender:self];
        }
    }];
}

- (void)viewDidLoad {
    self.CarSelInfo = [[CarInfo alloc] init];
    [super viewDidLoad];
    cars = [[NSArray alloc] initWithObjects:@"Year: ", @"Vehicle Make: ", @"Vehicle Model: ", @"Vehicle Option: ", nil];
    selected = [[NSMutableArray alloc] initWithObjects:@"[Not Selected]", @"[Not Selected]", @"[Not Selected]", @"[Not Selected]", nil];
    headers = [[NSArray alloc] initWithObjects:@"Your Car", @"Your Car Info", nil];
    info = [[NSArray alloc] initWithObjects:@"LKM(City): ", @"LKM(Highway): ", @"Fuel Capacity: ", @"Fuel Type: ", nil];
    self.infoKeys = [[NSArray alloc] initWithObjects:@"lkmCity", @"lkmHighway", @"fuelCap", @"engineFuel", nil];
    self.CarSelInfo.details = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     [NSNull null], @"lkmCity",
                     [NSNull null], @"lkmHighway",
                     [NSNull null], @"fuelCap",
                     [NSNull null], @"engineFuel", nil];
    
    addVehicleButton.center = CGPointMake(320/2, 60);
    [addVehicleButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    [addVehicleButton setBackgroundColor:[UIColor colorWithRed:105.0/255.0 green:121.0/255.0 blue:62.0/255.0 alpha:1.0]];
    [addVehicleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addVehicleButton setTitleColor:[UIColor colorWithRed:160.0/255.0 green:216.0/255.0 blue:241.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    
    //self.infoDetails = [[NSArray alloc] initWithObjects:@"Not Available", @"Not Available", @"Not Available", @"Not Available", nil];
    
    // initialize parameter data
    //self.infoDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"lkmCity", [NSNull null], @"lkmHighway", [NSNull null], @"fuelCap", [NSNull null], @"engineFuel", nil];
    // get all available years from cloud
    [self getYearsFromCloud];
    // Do any additional setup after loading the view, typically from a nib.
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [headers objectAtIndex:section];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [cars count];
    } else {
        return [info count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
        if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
    }

    if (indexPath.section==0){
        cell.textLabel.text = [cars objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [selected objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
    }
    
    else if (indexPath.section==1){
        cell.textLabel.text = [info objectAtIndex:indexPath.row];
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
        NSString *key = [self.infoKeys objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = self.CarSelInfo.details[key]!=[NSNull null]?self.CarSelInfo.details[key] : @"Not Available";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *segueString = [NSString stringWithFormat:@"%@Segue", [cars objectAtIndex:indexPath.row]];
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:segueString sender:[cars objectAtIndex:indexPath.row]];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    //Put your common code here
    // lets say you need all background color to be white. do this here
    [headerView setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:119.0/255.0 blue:34.0/255.0 alpha:1.0]];
    //Check the section and do section specific contents
    
    if (section == 0){
        [headerView setText:@"  Your Car"];
        [headerView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.5]];
        headerView.textColor = [UIColor colorWithRed:255.0/255.0 green:249.0/255.0 blue:173.0/255.0 alpha:1.0];//colorWithRed:218.0/255.0 green:165.0/255.0 blue:32.0/255.0 alpha:1.0];
    }
    else if (section == 1){
        [headerView setText:@"  Your Car Info"];
        [headerView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.5]];
        headerView.textColor = [UIColor colorWithRed:255.0/255.0 green:249.0/255.0 blue:173.0/255.0 alpha:1.0];
        //headerView.textColor = [UIColor colorWithRed:75.0/255.0 green:0.0/255.0 blue:230.0/255.0 alpha:1.0];
    }

    
    return headerView;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Year: Segue"]) {
        YearPickerViewController *yearVC = (YearPickerViewController *)[segue destinationViewController];
        [yearVC setYears:[self years]];
        //[yearVC setYearSel:[self yearSel]];
        [yearVC setYearSel:[[self CarSelInfo] year]];
        yearVC.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"Vehicle Make: Segue"]) {
        MakePickerViewController *makeVC = (MakePickerViewController *)[segue destinationViewController];
        [makeVC setMakes:[self makes]];
        [makeVC setMakeSel:[self.CarSelInfo make]];
        //[makeVC setMakeSel:[self makeSel]];
        [makeVC setDelegate:self];
    } else if ([[segue identifier] isEqualToString:@"Vehicle Model: Segue"]){
        ModelPickerViewController *modelVC = (ModelPickerViewController *)[segue destinationViewController];
        [modelVC setModels:[self models]];
        [modelVC setModelSel:[self.CarSelInfo model]];
        [modelVC setDelegate:self];
    } else if ([[segue identifier] isEqualToString:@"Vehicle Option: Segue"]) {
        OptionViewController *optionVC = (OptionViewController *)[segue destinationViewController];
        [optionVC setOptions:self.options.allKeys];
        [optionVC setOptionSel:self.CarSelInfo.option];
        [optionVC setDelegate:self];
    }
}

#pragma mark - Protocal Delegate Coming from Picker View

-(void)sendDataToSecond:(NSString *)selectedData //send year selected
{
    [self updateCellInMenu:selectedData atRow:YEAR_ROW];
    // cache selected year
    [[self CarSelInfo] setYear:selectedData];
    //[self setYearSel:selectedData];
    // clear make
    [self setMakes:nil];
    //[self setMakeSel:nil];
    [self.CarSelInfo setMake:nil];
    [self updateCellInMenu:[self.CarSelInfo make] atRow:MAKE_ROW];
    // clear model
    [self setModels:nil];
    [self.CarSelInfo setModel:nil];
    [self updateCellInMenu:[self.CarSelInfo model] atRow:MODEL_ROW];
    // clear option
    [self setOptions:nil];
    [self.CarSelInfo setOption:nil];
    [self.CarSelInfo setId:nil];
    [self updateCellInMenu:[self.CarSelInfo option] atRow:OPTION_ROW];
    // clear info section
    [self clearCellsInInfo];
    
    // query from server to get make data
    if ([[self CarSelInfo] year] != nil) {
        [self getMakesFromCloud:[[self CarSelInfo] year]];
    }
    
}

-(void)sendMakeSelToSecond:(NSString *)selectedData {
    [self updateCellInMenu:selectedData atRow:MAKE_ROW];
    // cache selected make
    [self.CarSelInfo setMake:selectedData];
    // clear model
    [self setModels:nil];
    [self.CarSelInfo setModel:nil];
    [self updateCellInMenu:self.CarSelInfo.model atRow:MODEL_ROW];
    // clear option
    [self setOptions:nil];
    [self.CarSelInfo setOption:nil];
    [self.CarSelInfo setId:nil];
    [self updateCellInMenu:self.CarSelInfo.option atRow:OPTION_ROW];
    // clear info section
    [self clearCellsInInfo];
    
    // query from server to get model data
    if ([[self CarSelInfo] year] != nil && [self.CarSelInfo make] != nil) {
        [self getModelsFromCloud:[[self CarSelInfo] year] AndMake:[self.CarSelInfo make]];
    }
}

-(void)sendModelSelToSecond:(NSString *)selectedString {
    [self updateCellInMenu:selectedString atRow:MODEL_ROW];
    // clear option
    [self setOptions:nil];
    [self.CarSelInfo setOption:nil];
    [self.CarSelInfo setId:nil];
    [self updateCellInMenu:self.CarSelInfo.option atRow:OPTION_ROW];
    // cache selected model
    [self.CarSelInfo setModel:selectedString];
    // clear info section
    [self clearCellsInInfo];
    
    // query from server to get option
    if ([self.CarSelInfo year] != nil && [self.CarSelInfo make] != nil && [self.CarSelInfo model] != nil) {
        [self getOptionsFromCloud:self.CarSelInfo.year AndMake:self.CarSelInfo.make AndModel:self.CarSelInfo.model];
    }
}

-(void)sendOptionSelToSecond:(NSString *)selectedString {
    [self.CarSelInfo setOption:selectedString];
    [self updateCellInMenu:[self.CarSelInfo option] atRow:OPTION_ROW];
    [self.CarSelInfo setId:[[self options] objectForKey:selectedString]];
    NSLog(@"Seleted ID: %@", [self.CarSelInfo Id]);
    // clear info section
    [self clearCellsInInfo];
    
    // query from server to get details
    if (self.CarSelInfo.Id != nil) {
        [self getVehicleInfoFromCloud:[self.CarSelInfo Id]];
    }
}

#pragma mark - Get Data Function from Cloud

-(void)getYearsFromCloud {
    // prompt progress HUD
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFCloud callFunctionInBackground:@"GetYears" withParameters:@{} block:^ (NSNumber *response, NSError *error) {
        if (!error) {
            [self setYears:(NSArray *)response];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)getMakesFromCloud:(NSString *)year {
    // prompt progress HUD
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFCloud callFunctionInBackground:@"GetMakes" withParameters:@{@"Year": year} block:^(NSNumber *response, NSError *error) {
        if (!error) {
            [self setMakes:(NSArray *)response];
            NSLog(@"%@", response);
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)getModelsFromCloud:(NSString *)year AndMake:(NSString *)make {
    // prompt progress HUD
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFCloud callFunctionInBackground:@"GetModels" withParameters:@{@"Year": year, @"Make": make} block:^(NSNumber *response, NSError *error) {
        if (!error) {
            [self setModels:(NSArray *)response];
            NSLog(@"%@", response);
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)getOptionsFromCloud:(NSString *)year AndMake:(NSString *)make AndModel:(NSString *)model {
    // prompt progress HUD
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFCloud callFunctionInBackground:@"GetOptions" withParameters:@{@"Year": year, @"Make": make, @"Model":model} block:^(NSNumber *response, NSError *error) {
        if (!error) {
            [self setOptions:(NSDictionary *)response];
            NSLog(@"%@", response);
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)getVehicleInfoFromCloud:(NSString *)Id {
    // prompt progress HUD
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFCloud callFunctionInBackground:@"GetVehicleInfo" withParameters:@{@"Id":Id} block:^(NSNumber *response, NSError *error) {
        if (!error) {
            [self copyDict:self.CarSelInfo.details from:(NSDictionary *)response];
            //[self setInfoDict:(NSDictionary *)response];
            NSLog(@"%@", [self.CarSelInfo details]);
            // update car info table
            [self updateCellsInInfo];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark table view/local data utils

-(void)updateCellInMenu:(NSString *)data atRow:(NSInteger *)row {
    [[self selected] replaceObjectAtIndex:row withObject:data!=nil?data:@"[Not Selected]"];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:MENU_SECTION];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [[self tableView] beginUpdates];
    [[self tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [[self tableView] endUpdates];
}

-(void)updateCellInInfo:(NSInteger *)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:INFO_SECTION];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [[self tableView] beginUpdates];
    [[self tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [[self tableView] endUpdates];
}

-(void)updateCellsInInfo {
    for (int i = 0; i < self.CarSelInfo.details.count; ++i) {
        [self updateCellInInfo:i];
    }
}

-(void)clearCellsInInfo {
    [self clearDict:[self.CarSelInfo details]];
    [self updateCellsInInfo];
}

-(void)clearDict:(NSMutableDictionary *)dict {
    NSArray *keys = [dict allKeys];
    for (id key in keys) {
        dict[key] = [NSNull null];
    }
}

-(void)copyDict:(NSMutableDictionary *)dest from:(NSDictionary *)src {
    NSArray *keys = [src allKeys];
    for (id key in keys) {
        dest[key] = src[key];
    }
}

@end
