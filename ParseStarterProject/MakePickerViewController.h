//
//  FourthViewControllerMake.h
//  roadTrip Storyboard
//
//  Created by NahNah Kim on 7/21/15.
//  Copyright (c) 2015 NahNah Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendMakeSelProtocol <NSObject>

-(void) sendMakeSelToSecond:(NSString *)selectedString;

@end

@interface MakePickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *makes;
    NSString *makeSel;
}

//@property (strong, nonatomic) IBOutlet UILabel *makeSelected;


@property (nonatomic, strong)NSArray *makes;
@property (nonatomic, strong)NSString *makeSel;
@property (nonatomic, assign)id delegate;
@end