//
//  HotelOptionVC.h
//  RTMProject
//
//  Created by NahNah Kim on 7/23/15.
//
//


#import <UIKit/UIKit.h>

@protocol sendHotelSelProtocol <NSObject>

-(void) sendHotelSelToSettingView:(NSString *)myStringData;
@end


@interface HotelOptionVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *lodging;
@property (nonatomic, strong) NSString *lodgingSel;
@property(nonatomic,assign)id delegate;
@property (nonatomic, strong) UILabel *lodgingSelectedLabel;
@end