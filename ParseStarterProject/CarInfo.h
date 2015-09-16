//
//  CarInfo.h
//  RTMProject
//
//  Created by Yu Xiao on 7/26/15.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CarInfo : NSObject {
    NSString *year;
    NSString *make;
    NSString *model;
    NSString *option;
    NSString *Id;
    NSMutableDictionary *details;
}

-(CarInfo *) getInfoFromPFObject:(PFObject *)object;
-(void) saveCarInfoToCloud:(void (^)(BOOL successed, NSError *error))completionHandler;

@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *make;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *option;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSMutableDictionary *details;

@end
