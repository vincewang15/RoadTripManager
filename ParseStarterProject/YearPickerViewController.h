//
//  ThirdViewControllerYear.h
//  roadTrip Storyboard
//
//  Created by NahNah Kim on 7/21/15.
//  Copyright (c) 2015 NahNah Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendDataProtocol <NSObject>

-(void) sendDataToSecond:(NSString *)myStringData;

@end

@interface YearPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

//@property (strong, nonatomic) IBOutlet UILabel *yearSelected;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *years;
@property (nonatomic, strong) NSString *yearSel;

@property(nonatomic,assign)id delegate;
@end