//
//  FoodOptionVC.h
//  RTMProject
//
//  Created by NahNah Kim on 7/23/15.
//
//

#import <UIKit/UIKit.h>

@protocol sendFoodSelProtocol <NSObject>

-(void) sendFoodSelToSettingView:(NSString *)myStringData;
@end


@interface FoodOptionVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *food;
@property (nonatomic, strong) NSString *foodSel;
@property(nonatomic,assign)id delegate;
@property (nonatomic, strong) UILabel *foodSelectedLabel;
@end