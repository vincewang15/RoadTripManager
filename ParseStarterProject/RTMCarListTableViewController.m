//
// This is the template PFQueryTableViewController subclass file. Use it to customize your own subclass.
//

#import <UIKit/UIKit.h>
#import "RTMCarListTableViewController.h"

@interface RTMCarListTableViewController ()

@end

@implementation RTMCarListTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"CAR_INFO";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"make";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        //self.imageKey = @"cars_icon.png";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 20;
    }
    return self;

}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goToAddCar:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadObjects];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    // save to own car info structure
    self.carInfoArray = nil;
    self.carInfoArray = [[NSMutableArray alloc] init];
    for (id object in [self objects]) {
        CarInfo *carInfo = [[CarInfo alloc] init];
        [self.carInfoArray addObject: [carInfo getInfoFromPFObject:object]];
    }
}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
 
     PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
     
     PFUser *currentUser = [PFUser currentUser];
     
     [query whereKey:@"username" equalTo:[currentUser username]==nil?@"":[currentUser username]];
     
     [query orderByDescending:@"createdAt"];
 
     return query;
 }


 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 static NSString *CellIdentifier = @"Cell";
 
 PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
         cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         cell.textLabel.font = [UIFont systemFontOfSize:19.0];
     }
 
     // Configure the cell
     cell.textLabel.text = [self makeCarBasicString:object];
     cell.detailTextLabel.text = [self makeCarDetailsString:object];
     
     if (indexPath.row==0 || indexPath.row==10){
         cell.textLabel.textColor=[UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1.0];
         cell.imageView.image =[UIImage imageNamed:@"Car-50(1).png"];
         [cell.imageView setContentMode: UIViewContentModeScaleAspectFit];
     }
     if (indexPath.row==1 || indexPath.row==11){
         cell.textLabel.textColor=[UIColor colorWithRed:90.0/255.0 green:200.0/255.0 blue:250.0/255.0 alpha:1.0];
         cell.imageView.image =[UIImage imageNamed:@"Car-50(2).png"];
         [cell.imageView setContentMode: UIViewContentModeScaleAspectFit];
     }
     if (indexPath.row==2 || indexPath.row==12){
         cell.textLabel.textColor=[UIColor colorWithRed:52.0/255.0 green:170.0/255.0 blue:220.0/255.0 alpha:1.0];
         cell.imageView.image =[UIImage imageNamed:@"Car-50(3).png"];
         [cell.imageView setContentMode: UIViewContentModeScaleAspectFit];
     }
     if (indexPath.row==3 || indexPath.row==13){
         cell.textLabel.textColor=[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
         cell.imageView.image =[UIImage imageNamed:@"Car-50(4).png"];
         [cell.imageView setContentMode: UIViewContentModeScaleAspectFit];
     }
     if (indexPath.row==4 || indexPath.row==14){
         cell.textLabel.textColor=[UIColor colorWithRed:88.0/255.0 green:86.0/255.0 blue:214.0/255.0 alpha:1.0];
         cell.imageView.image =[UIImage imageNamed:@"Car-50(5).png"];
         [cell.imageView setContentMode: UIViewContentModeScaleAspectFit];
     }
     if (indexPath.row==5 || indexPath.row==15){
         cell.textLabel.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:147.0/255.0 alpha:1.0];
         cell.imageView.image =[UIImage imageNamed:@"Car-50(6).png"];
         [cell.imageView setContentMode: UIViewContentModeScaleAspectFit];
     }
     if (indexPath.row==6 || indexPath.row==16){
         cell.textLabel.textColor=[UIColor colorWithRed:255.0/255.0 green:45.0/255.0 blue:85.0/255.0 alpha:1.0];
         cell.imageView.image =[UIImage imageNamed:@"Car-50(7).png"];
         [cell.imageView setContentMode: UIViewContentModeScaleAspectFit];
     }
     if (indexPath.row==7 || indexPath.row==17){
         cell.textLabel.textColor=[UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1.0];
         cell.imageView.image =[UIImage imageNamed:@"Car-50(8).png"];
         [cell.imageView setContentMode: UIViewContentModeScaleAspectFit];
     }
     if (indexPath.row==8 || indexPath.row==18){
         cell.textLabel.textColor=[UIColor colorWithRed:255.0/255.0 green:149.0/255.0 blue:0.0/255.0 alpha:1.0];
         cell.imageView.image =[UIImage imageNamed:@"Car-50(9).png"];
         [cell.imageView setContentMode: UIViewContentModeScaleAspectFit];
     }
     if (indexPath.row==9 || indexPath.row==19){
         cell.textLabel.textColor=[UIColor colorWithRed:255.0/255.0 green:200.0/255.0 blue:50.0/255.0 alpha:1.0];
         cell.imageView.image =[UIImage imageNamed:@"Car-50(10).png"];
         [cell.imageView setContentMode: UIViewContentModeScaleAspectFit];
     }
     [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
     
//     CGSize itemSize = CGSizeMake(38,38);
//     UIGraphicsBeginImageContextWithOptions(itemSize, NO,UIScreen.mainScreen.scale);
//     CGRect imageRect = CGRectMake(5.0, 5.0, itemSize.width, itemSize.height);
//     [cell.imageView.image drawInRect:imageRect];
//     cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//     UIGraphicsEndImageContext();
     
     return cell;
 }


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDataSource


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
     [self removeObjectAtIndexPath:indexPath];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"map segue" sender:[[self carInfoArray] objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"map segue"]) {
        MapPart *mapVC = (MapPart *)[segue destinationViewController];
        mapVC.theCarInfo = sender;
    }
    
}

#pragma mark - Self Implementing Method

- (void)goToAddCar:(id) sender{
    [self performSegueWithIdentifier:@"myView" sender:self];
}

- (NSString *)makeCarBasicString:(PFObject *)object {
    NSMutableString *yearStr = object[@"year"];
    NSMutableString *makeStr = object[@"make"];
    NSMutableString *modelStr = object[@"model"];
    return [NSString stringWithFormat:@"%@ %@ %@", yearStr, makeStr, modelStr];
}

- (NSString *)makeCarDetailsString:(PFObject *)object {
   
    NSMutableString *optionStr = object[@"option"];
    
    return [NSString stringWithFormat:@"%@", optionStr];
}


@end