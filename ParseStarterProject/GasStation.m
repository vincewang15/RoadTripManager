//
//  GasStation.m
//  RTMProject
//
//  Created by Vincewang on 7/25/15.
//
//

#import "GasStation.h"

@implementation GasStation
-(instancetype)initWith:(NSDictionary *)dictionary{
    self=[super init];
    if(self){
        NSString *locality=dictionary[@"address_locality"];
        NSString *street=dictionary[@"address_street"];
        self.address=[street stringByAppendingString:locality];
        self.brand=dictionary[@"brand"];
        self.diesel=dictionary[@"diesel"];
        self.plus=dictionary[@"plus"];
        self.premium=dictionary[@"premium"];
        self.regular=dictionary[@"regular"];
    }
    return self;
}

-(double)getdiesel{
    if([self.diesel isEqualToString:@"N/A"]){
        return FLT_MAX;
    }else{
        return[[self.diesel substringFromIndex:1] floatValue];
    }
}

-(double)getplus{
    if([self.plus isEqualToString:@"N/A"]){
        return FLT_MAX;
    }else{
        return[[self.plus substringFromIndex:1] floatValue];
    }

}

-(double)getpremium{
    if([self.premium isEqualToString:@"N/A"]){
        return FLT_MAX;
    }else{
        return[[self.premium substringFromIndex:1] floatValue];
    }

}

-(double)getregular{
    if([self.regular isEqualToString:@"N/A"]){
        return FLT_MAX;
    }else{
        return[[self.regular substringFromIndex:1] floatValue];
    }
}

-(double)getPrice:(NSString *)name{
    if([name isEqualToString:@"plus"]){
        return [self getplus];
    }else if ([name isEqualToString:@"premium"]){
        return [self getpremium];
    }else if ([name isEqualToString:@"diesel"]){
        return [self getdiesel];
    }else{
        return [self getregular];
    }
}

@end
