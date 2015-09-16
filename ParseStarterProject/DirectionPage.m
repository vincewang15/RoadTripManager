//
//  DirectionPage.m
//  RTMProject
//
//  Created by Vincewang on 7/28/15.
//
//

#import "DirectionPage.h"

@interface DirectionPage ()

@end

@implementation DirectionPage

@synthesize instructions;
@synthesize directinstruction;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if(!self.showGas)
    self.instructionText.text=self.directinstruction;
    else{
      NSString *totalinstruction=[[NSString alloc]init];
        for(int i=0;i< [self.endPoints count];++i){
        NSString *eachinstruction=instructions[[self.endPoints objectAtIndex:i]];
            if([eachinstruction length]!=0){
            totalinstruction=[totalinstruction stringByAppendingString:eachinstruction];
            totalinstruction=[totalinstruction stringByAppendingString:@"\n\n"];
            if(i==[self.endPoints count]-2){
                totalinstruction=[totalinstruction stringByReplacingOccurrencesOfString:@"destination"
                                                            withString:@"gas station"];
            }
            }
         }
        self.instructionText.text=totalinstruction;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
