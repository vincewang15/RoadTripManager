//
//  FifthViewControllerModel.h
//  roadTrip Storyboard
//
//  Created by NahNah Kim on 7/21/15.
//  Copyright (c) 2015 NahNah Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendModelSelProtocol <NSObject>

-(void) sendModelSelToSecond:(NSString *)selectedString;

@end

@interface ModelPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *models;
    NSString *modelSel;
}


@property (nonatomic, strong)NSArray *models;
@property (nonatomic, strong)NSString *modelSel;
@property (nonatomic, assign)id delegate;


@end