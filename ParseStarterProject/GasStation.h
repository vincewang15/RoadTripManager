//
//  GasStation.h
//  RTMProject
//
//  Created by Vincewang on 7/25/15.
//
//

#import <Foundation/Foundation.h>

@interface GasStation : NSObject

@property (strong,nonatomic) NSString *diesel;
@property (strong,nonatomic) NSString *plus;
@property (strong,nonatomic) NSString *premium;
@property (strong,nonatomic) NSString *regular;

@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *brand;

-(instancetype)initWith:(NSDictionary *)dictionary;
-(double)getdiesel;
-(double)getplus;
-(double)getpremium;
-(double)getregular;
-(double)getPrice:(NSString *)name;
@end
