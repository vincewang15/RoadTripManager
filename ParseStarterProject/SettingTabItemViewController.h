//
//  settingsTab.h
//  RTMProject
//
//  Created by NahNah Kim on 7/24/15.
//
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFLoginViewController.h>
#import <Parse/Parse.h>
#import "PreferenceInfo.h"
#import "MBProgressHUD.h"

@interface SettingTabItemViewController : UITableViewController{
}

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSArray *headers;
@property (nonatomic, strong) NSMutableArray *selected;
@property (nonatomic, strong) UISwitch *gasSwitch;
@property (nonatomic, strong) UISwitch *foodSwitch;
@property (nonatomic, strong) UISwitch *lodgingSwitch;

@property (nonatomic, strong) NSArray *gas;
//@property (nonatomic, strong) NSString *gasSel;
@property (nonatomic, strong) NSArray *lodging;
@property (nonatomic, strong) NSArray *food;
//@property (strong, nonatomic) IBOutlet UIButton *almostDoneButton;

@property (nonatomic, strong) PreferenceInfo *thePrefInfo;
@property(nonatomic,assign)id delegate;

@end