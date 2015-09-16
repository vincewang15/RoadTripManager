//
//  RTMCarListTableViewController.h
//  RTMProject
//
//  Created by Yu Xiao on 7/26/15.
//
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "CarInfo.h"
#import "MapPart.h"

@interface RTMCarListTableViewController : PFQueryTableViewController

@property (nonatomic, strong) NSMutableArray *carInfoArray;
@end
