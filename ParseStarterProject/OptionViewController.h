//
//  OptionViewController.h
//  RTMProject
//
//  Created by Yu Xiao on 7/23/15.
//
//

#import <UIKit/UIKit.h>

@protocol sendOptionSelPro <NSObject>

-(void)sendOptionSelToSecond:(NSString *)selectedString;

@end

@interface OptionViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *options;
    NSString *optionSel;
}

@property (nonatomic, strong)NSArray *options;
@property (nonatomic, strong)NSString *optionSel;
@property (nonatomic, assign)id delegate;

@end
