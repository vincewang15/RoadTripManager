//
//  GasViewController.h
//  roadTrip Storyboard
//
//  Created by NahNah Kim on 7/22/15.
//  Copyright (c) 2015 NahNah Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendGasSelProtocol <NSObject>

-(void) sendGasSelToSettingView:(NSString *)myStringData;
@end


@interface GasViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *gasStation;
@property(nonatomic,assign)id delegate;
@property (nonatomic, strong) NSString *gasSel;
@property (nonatomic, strong) UILabel *gasSelectedLabel;
@end