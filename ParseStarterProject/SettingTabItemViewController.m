//
//  settingsTab.m
//  RTMProject
//
//  Created by NahNah Kim on 7/24/15.
//
//
#import "GasViewController.h"
#import "SettingTabItemViewController.h"
#import "GasOptionViewController.h"
#import "HotelOptionVC.h"
#import "FoodOptionVC.h"
#import "RTMLoginViewController.h"

@interface SettingTabItemViewController ()
#define SELECT_ROW      1
#define GAS_SECTION     0
#define LODGING_SECTION 1
#define FOOD_SECTION    2

@end

static NSString * const PrefDefault = @"All";

@implementation SettingTabItemViewController
@synthesize headers;
@synthesize selected;
@synthesize tableData;
@synthesize gas;
//@synthesize gasSel;
@synthesize lodging;
@synthesize food;
@synthesize delegate;
@synthesize gasSwitch;
@synthesize foodSwitch;
@synthesize lodgingSwitch;
@synthesize thePrefInfo;


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    [[self navigationItem] setTitle:@"Your Preferences"];
//    
//    //do something like background color, title, etc you self
//    [self.view addSubview:navbar];
    
        self.title = @"Settings";
        self.tabBarItem.image = [UIImage imageNamed:@"Settings-25.png"];
    
    //self.title.prompt: @"Road Trip Manager";
    
    // Do any additional setup after loading the view, typically from a nib.
    tableData=[[NSArray alloc] initWithObjects:@"Preferred gas station: ", @"Preferred motel: ", @"Preferred food style: ", nil];
    headers = [[NSArray alloc] initWithObjects:@"Gas", @"Sleep", @"Food", nil];
    //self.headers = [headers componentsSeparatedByString:@" "];
    selected = [[NSMutableArray alloc] initWithObjects:@"All", @"All", @"All", nil];
    self.thePrefInfo = [[PreferenceInfo alloc] init];
    // @TODO initiate through database query
//    self.thePrefInfo.showGas = YES;
//    self.thePrefInfo.showLodging = YES;
//    self.thePrefInfo.showFood = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.thePrefInfo retrievePreferenceInfoFromCloud:^(BOOL successed, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error && successed) {
            NSLog(@"Retrieved Preference from Cloud");
            [self refreshTableByPreference:self.thePrefInfo];
        } else {
            NSLog(@"Retrieved Preference Failed with Error: %@", error);
        }
        
    }];

    // Set the LogOut Left Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(buttonLogOutAction)];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // store result to cloud
    [[self thePrefInfo] savePreferenceInfoToCloud:^(BOOL successed, NSError *error){
        if (!error && successed) {
            NSLog(@"Save Preference Successed.");
        } else {
            NSLog(@"Save Preference Failed With Error: %@", error);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [headers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
    }
    
    if (indexPath.section==0){
        if (indexPath.row==0){
            cell.textLabel.text = @"Show Gas";
            gasSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = gasSwitch;
            [cell addSubview:gasSwitch];
            [gasSwitch setOn:YES animated:YES];
            [gasSwitch addTarget:self action:@selector(changeGasSwitch:) forControlEvents:UIControlEventValueChanged];
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
        }
        if (indexPath.row==1){
            cell.textLabel.text = @"Preferred Gas Station: ";
            cell.detailTextLabel.text = [[self selected] objectAtIndex:indexPath.section];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
        }
    }
    
    if (indexPath.section==1){
        if (indexPath.row==0){
            cell.textLabel.text = @"Show Lodging";
            lodgingSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = lodgingSwitch;
            [cell addSubview:lodgingSwitch];
            [lodgingSwitch setOn:YES animated:YES];
            [lodgingSwitch addTarget:self action:@selector(changeLodgingSwitch:) forControlEvents:UIControlEventValueChanged];
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
        }
        if (indexPath.row==1){
            cell.textLabel.text = @"Preferred Lodging: ";
            cell.detailTextLabel.text = [[self selected] objectAtIndex:indexPath.section];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
        }
//        if (indexPath.row==2){
//            cell.textLabel.text = @"Price ($USD):";
//            UISlider *priceSlider = [[UISlider alloc] initWithFrame:CGRectMake(0.0, 10.0, 180.0, 10.0)];
//            cell.accessoryView = priceSlider;
//            priceSlider.minimumValue = 0;
//            priceSlider.maximumValue = 200;
//            
//            [priceSlider setMinimumValue: 0.0];
//            [priceSlider setMaximumValue: 100.0];
//            priceSlider.value = 50.0;
//            [priceSlider addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
//            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
//        }
    }
    
    if (indexPath.section==2){
        if (indexPath.row==0){
            cell.textLabel.text = @"Show Food";
            foodSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = foodSwitch;
            [cell addSubview:foodSwitch];
            [foodSwitch setOn:YES animated:YES];
            [foodSwitch addTarget:self action:@selector(changeFoodSwitch:) forControlEvents:UIControlEventValueChanged];
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
        }
        if (indexPath.row==1){
            cell.textLabel.text = @"Preferred Food: ";
            cell.detailTextLabel.text = [[self selected] objectAtIndex:indexPath.section];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
        }
//        if (indexPath.row==2){
//            cell.textLabel.text = @"Price ($USD):";
//            UISlider *priceSlider = [[UISlider alloc] initWithFrame:CGRectMake(0.0, 10.0, 180.0, 10.0)];
//            cell.accessoryView = priceSlider;
//            priceSlider.minimumValue = 0;
//            priceSlider.maximumValue = 200;
//            
//            [priceSlider setMinimumValue: 0.0];
//            [priceSlider setMaximumValue: 100.0];
//            priceSlider.value = 50.0;
//            [priceSlider addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
//            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
//        }
    }
    return cell;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        if (!gasSwitch.on) {
//            return 0.0f;
//        }else{
//            return 44.0f;
//        }
//    }
//    
//   if (indexPath.section == 1) {
//        if (!lodgingSwitch.on) {
//            return 0.0f;
//        }else{
//            return 44.0f;
//        }
//   }
//    
//    if (indexPath.section==2){
//        if (!foodSwitch.on){
//        return 0.0f;
//    }
//        else {
//                return 44.0f;
//    }
// }
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView.deselectRowAtIndexPath:(NsIndexPath *)indexPath {
//    if (!gasSwitch.on){
//        
//    }
//}

#pragma mark - Switch Button Functions

- (void) changeGasSwitch:(id)sender {
    [self hideCellBySwitch:gasSwitch atRow:SELECT_ROW inSection:GAS_SECTION];
    [self.thePrefInfo setShowGas:gasSwitch.on];

}

- (void) changeLodgingSwitch:(id)sender{
    [self hideCellBySwitch:lodgingSwitch atRow:SELECT_ROW inSection:LODGING_SECTION];
    [self.thePrefInfo setShowLodging:lodgingSwitch.on];
}

- (void) changeFoodSwitch:(id)sender{
    [self hideCellBySwitch:foodSwitch atRow:SELECT_ROW inSection:FOOD_SECTION];
    [self.thePrefInfo setShowFood:foodSwitch.on];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [headers objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    //Put your common code here
    // lets say you need all background color to be white. do this here
    //[headerView setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:10.0/255.0 alpha:1.0]];
    
    
    
    
    [headerView setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:119.0/255.0 blue:34.0/255.0 alpha:1.0]];
    //Check the section and do section specific contents
    
   
    
    //Check the section and do section specific contents
    
    if (section == 0){
        [headerView setText:@"  Gas"];
        [headerView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.5]];
        headerView.textColor = [UIColor colorWithRed:255.0/255.0 green:249.0/255.0 blue:173.0/255.0 alpha:1.0];//
    }
    else if (section == 1){
        [headerView setText:@"  Lodging"];
        [headerView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.5]];
        headerView.textColor = [UIColor colorWithRed:255.0/255.0 green:249.0/255.0 blue:173.0/255.0 alpha:1.0];//
    }
    else if (section == 2){
        [headerView setText:@"  Food"];
        [headerView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.5]];
        headerView.textColor = [UIColor colorWithRed:255.0/255.0 green:249.0/255.0 blue:173.0/255.0 alpha:1.0];//
    }
    
    return headerView;
    
    
    //    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
    //    [sectionView setBackgroundColor:[UIColor whiteColor]];
    //    return sectionView;
}


#pragma mark - For Navigation Control

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *segueString = [NSString stringWithFormat:@"%@: Segue", [headers objectAtIndex:indexPath.section]];
    
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:segueString sender:[headers objectAtIndex:indexPath.row]];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Gas: Segue"]) {
        GasViewController *myVC1 = (GasViewController *)[segue destinationViewController];
        //[myVC1 setGas:[self gas]];
        [myVC1 setGasSel:[self.thePrefInfo gasPref]];
        myVC1.delegate = self;
    }
    
    else if ([[segue identifier] isEqualToString:@"Sleep: Segue"]) {
        HotelOptionVC *myVC2 = (HotelOptionVC *)[segue destinationViewController];
        [myVC2 setLodging:[self lodging]];
        [myVC2 setLodgingSel:[self.thePrefInfo lodgingPref]];
        myVC2.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"Food: Segue"]) {
        FoodOptionVC *myVC3 = (FoodOptionVC *)[segue destinationViewController];
        [myVC3 setFood:[self food]];
        [myVC3 setFoodSel:[self.thePrefInfo foodPref]];
         myVC3.delegate = self;
    }
}

#pragma mark Protocal callback from preference pickers

-(void)sendGasSelToSettingView:(NSString *)myStringData{
    
    [self updateCellInTable:myStringData atRow:SELECT_ROW inSection:GAS_SECTION withDefault:@"All"];
    // cache selected gas
    [self.thePrefInfo setGasPref:myStringData];
}

-(void)sendHotelSelToSettingView:(NSString *)myStringData{
    
    [self updateCellInTable:myStringData atRow:SELECT_ROW inSection:LODGING_SECTION withDefault:@"All"];
    // cache selected gas
    [self.thePrefInfo setLodgingPref:myStringData];
    // @TODO store user gas preference to local db
}

-(void)sendFoodSelToSettingView:(NSString *)myStringData{
    
    [self updateCellInTable:myStringData atRow:SELECT_ROW inSection:FOOD_SECTION withDefault:@"All"];
    // cache selected gas
    [self.thePrefInfo setFoodPref:myStringData];
    // @TODO store user gas preference to local db
}



#pragma mark table view/local data utils

-(void)updateCellInTable:(NSString *)data atRow:(NSInteger *)row inSection:(NSInteger *)section withDefault:(NSString *)defaultString{
    [[self selected] replaceObjectAtIndex:section withObject:data!=nil?data:defaultString];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [[self tableView] beginUpdates];
    [[self tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [[self tableView] endUpdates];
}

- (void)hideCellBySwitch:(UISwitch *)sw atRow:(NSInteger *)row inSection:(NSInteger *)section {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    [cell setHidden:!sw.on];
}

#pragma mark - Utils for buttons

- (void)buttonLogOutAction{
    [PFUser logOut];
    NSLog(@"User did logout");
    // Right now Simply directed to About page!
    [self.tabBarController setSelectedIndex:2];
    
}

- (void)refreshTableByPreference:(PreferenceInfo *)pref {
    [gasSwitch setOn:pref.showGas];
    [lodgingSwitch setOn:pref.showLodging];
    [foodSwitch setOn:pref.showFood];
    [self hideCellBySwitch:gasSwitch atRow:SELECT_ROW inSection:GAS_SECTION];
    [self hideCellBySwitch:lodgingSwitch atRow:SELECT_ROW inSection:LODGING_SECTION];
    [self hideCellBySwitch:foodSwitch atRow:SELECT_ROW inSection:FOOD_SECTION];
    [self updateCellInTable:pref.gasPref atRow:SELECT_ROW inSection:GAS_SECTION withDefault:PrefDefault];
    [self updateCellInTable:pref.lodgingPref atRow:SELECT_ROW inSection:LODGING_SECTION withDefault:PrefDefault];
    [self updateCellInTable:pref.foodPref atRow:SELECT_ROW inSection:FOOD_SECTION withDefault:PrefDefault];
}

@end