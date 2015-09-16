//
//  PreferenceInfo.m
//  RTMProject
//
//  Created by Yu Xiao on 7/26/15.
//
//

#import "PreferenceInfo.h"

@implementation PreferenceInfo
@synthesize gasPref;
@synthesize lodgingPref;
@synthesize foodPref;
@synthesize showGas;
@synthesize showLodging;
@synthesize showFood;

#pragma mark - Constant Deleration
static NSString * const DatabaseName = @"PREFERENCE_INFO";
static NSString * const PrefDefault = @"All";

#pragma mark - Public Method to store/load data from cloud

-(void) savePreferenceInfoToCloud:(void (^)(BOOL successed, NSError *error))completionHandler {
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:DatabaseName];
    [query whereKey:@"username" equalTo:[currentUser username]==nil?@"":[currentUser username]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError*error) {
        if (!error) {
            if ([objects count] == 0) { // not exist, create one
                [self __savePreferenceInfoToCloud:completionHandler];
            } else if ([objects count] == 1){ // has one, update
                [self __updatePreferenceInfoToCloud:objects[0] then:completionHandler];
            } else { // TODO:should not happens, but happens, clear all and create one
                
            }
        }
    }];
}

-(void) retrievePreferenceInfoFromCloud:(void (^)(BOOL successed, NSError *error))completionHandler {
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:DatabaseName];
    [query whereKey:@"username" equalTo:[currentUser username]==nil?@"":[currentUser username]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error && [objects count] == 1) {
            [self __parsePFObject:objects[0]];
            completionHandler(YES, error);
        } else {
            completionHandler(NO, error);
        }
    }];
}

#pragma mark - helper function to communication with cloud

-(void) __updatePreferenceInfoToCloud:(PFObject *)object then:(void (^)(BOOL successed, NSError *error))completionHandler {
    [self __makePFObject:object];
    [object saveInBackgroundWithBlock:completionHandler];
}

-(void) __savePreferenceInfoToCloud:(void (^)(BOOL successed, NSError *error))completionHandler {
    PFObject *object = [PFObject objectWithClassName:DatabaseName];
    [self __makePFObject:object];
    [object saveInBackgroundWithBlock:completionHandler];
}

-(void)__makePFObject:(PFObject *)object {
    object[@"Show_gas"] = [[NSNumber alloc] initWithBool:self.showGas];
    object[@"Show_food"] = [[NSNumber alloc] initWithBool:self.showFood];
    object[@"Show_lodging"] = [[NSNumber alloc] initWithBool:self.showLodging];
    object[@"Pref_gas"] = self.gasPref ? self.gasPref : @"All";
    object[@"Pref_food"] = self.foodPref ? self.foodPref : @"All";
    object[@"Pref_lodging"] = self.lodgingPref ? self.lodgingPref : @"All";
    object[@"username"] = [[PFUser currentUser] username];
}

-(void)__parsePFObject:(PFObject *)object {
    self.showGas = [object[@"Show_gas"] boolValue];
    self.showLodging = [object[@"Show_lodging"] boolValue];
    self.showFood = [object[@"Show_food"] boolValue];
    self.gasPref = [object[@"Pref_gas"] isEqualToString:PrefDefault] ? nil : object[@"Pref_gas"];
    self.foodPref = [object[@"Pref_food"] isEqualToString:PrefDefault] ? nil : object[@"Pref_food"];
    self.lodgingPref = [object[@"Pref_lodging"] isEqualToString:PrefDefault] ? nil : object[@"Pref_lodging"];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"show_gas:%d, show_lodging:%d, show_food:%d, pref_gas:%@, pref_lodging:%@, pref_food:%@", self.showGas, self.showLodging, self.showFood, self.gasPref, self.lodgingPref, self.foodPref];
}

@end
