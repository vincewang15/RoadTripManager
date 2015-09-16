//
//  CarInfo.m
//  RTMProject
//
//  Created by Yu Xiao on 7/26/15.
//
//

#import "CarInfo.h"

@implementation CarInfo
@synthesize year;
@synthesize make;
@synthesize model;
@synthesize option;
@synthesize Id;
@synthesize details;

#pragma mark - Helper Class for Storing Car Info

-(CarInfo *) getInfoFromPFObject:(PFObject *)object {
    [self setYear:object[@"year"]];
    [self setMake:object[@"make"]];
    [self setModel:object[@"model"]];
    [self setId:object[@"Id"]];
    [self setOption:object[@"option"]];
    [self setDetails:object[@"details"]];
    return self;
}

-(BOOL) isInfoComplete {
    return self.year!=nil && self.make!=nil && self.model!=nil && self.option!=nil && details!=nil;
}

-(void) checkInfoExist:(void (^)(BOOL doesExist, NSError *error))completionHandler {
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"CAR_INFO"];
    [query whereKey:@"username" equalTo:[currentUser username]];
    [query whereKey:@"Id" equalTo:self.Id];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            // find succeeded
            completionHandler([objects count]>0, error);
        } else {
            completionHandler(NO, error);
        }
    }];
}

-(void) saveCarInfoToCloud:(void (^)(BOOL successed, NSError *error))completionHandler {
    if (![self isInfoComplete]) {
        completionHandler(NO, nil);
    } else {
        [self checkInfoExist:^(BOOL doesExist, NSError *error){
            if (!error && !doesExist) {
                [self __saveCarInfoToCloud:completionHandler];
            } else {
                completionHandler(!doesExist, error);
            }
        }];
    }
}

-(void) __saveCarInfoToCloud:(void (^)(BOOL successed, NSError *error))completionHandler {
    PFObject *carInfo = [PFObject objectWithClassName:@"CAR_INFO"];
    carInfo[@"year"] = self.year;
    carInfo[@"make"] = self.make;
    carInfo[@"model"] = self.model;
    carInfo[@"option"] = self.option;
    carInfo[@"Id"] = self.Id;
    carInfo[@"details"] = self.details;
    // get user information
    PFUser *currentUser = [PFUser currentUser];
    carInfo[@"username"] = [currentUser username];
    [carInfo saveInBackgroundWithBlock:^(BOOL successed, NSError *error){
        if (successed) {
            NSLog(@"Save Car Info Successed");
        } else {
            NSLog(@"Save Car Info Failure with Code: %@",error);
        }
        completionHandler(successed, error);
    }];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"year:%@, make:%@, model:%@, option:%@, details:%@",self.year, self.make, self.model, self.option, self.details];
}
@end
