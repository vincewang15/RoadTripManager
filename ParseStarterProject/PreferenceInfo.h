//
//  PreferenceInfo.h
//  RTMProject
//
//  Created by Yu Xiao on 7/26/15.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PreferenceInfo : NSObject {
    BOOL showGas;
    BOOL showLodging;
    BOOL showFood;
    NSString *gasPref;
    NSString *lodgingPref;
    NSString *foodPref;
}

-(void) savePreferenceInfoToCloud:(void (^)(BOOL successed, NSError *error))completionHandler;
-(void) retrievePreferenceInfoFromCloud:(void (^)(BOOL successed, NSError *error))completionHandler;

@property (assign) BOOL showGas;
@property (assign) BOOL showLodging;
@property (assign) BOOL showFood;
@property (nonatomic, strong) NSString *gasPref;
@property (nonatomic, strong) NSString *lodgingPref;
@property (nonatomic, strong) NSString *foodPref;
@end
