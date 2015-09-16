//
//  DirectionPage.h
//  RTMProject
//
//  Created by Vincewang on 7/28/15.
//
//

#import <UIKit/UIKit.h>
#import "MapPart.h"

@interface DirectionPage : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *instructionText;
@property (nonatomic, strong) NSMutableDictionary *instructions;
@property (nonatomic, strong) NSString *directinstruction;
@property (nonatomic, strong) NSMutableArray *endPoints;
@property (assign) BOOL showGas;

@end
