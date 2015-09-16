//
//  aboutTab.m
//  RTMProject
//
//  Created by NahNah Kim on 7/24/15.
//
//

#import "aboutTab.h"
//#import <Parse/Parse.h>
//#import "PreferenceInfo.h"


@interface aboutTab ()

@end

@implementation aboutTab
@synthesize aboutBlurb;
@synthesize aboutWelcomeLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background6.png"]];
    
    CGRect labelRect = CGRectMake(15, 240, ([UIScreen mainScreen].bounds.size.width)-30, 170);
    aboutBlurb = [[UILabel alloc] initWithFrame:labelRect];
    //[aboutBlurb setBackgroundColor:[UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:0.4]];
    [aboutBlurb setTextColor:[UIColor purpleColor]];//colorWithRed:153.0/255.0 green:51.0/255.0 blue:255.0/255.0 alpha:1.0]];
    //dark blue: UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    [aboutBlurb setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18]];
    //aboutBlurb.textAlignment = NSTextAlignmentCenter;
    aboutBlurb.text = @"Use Road Trip Manager to save money on gas for your road trips.  We pull up the cheapest gas for you along your most efficient route. Happy road-tripping!";
    
    //We also provide you with options for lodging and food on your road trip.Thank you for using Road Trip Manager, and if you like us, share us with your friends.
    
    aboutBlurb.lineBreakMode = NSLineBreakByWordWrapping;
    aboutBlurb.numberOfLines = 0;
    [self.view addSubview:aboutBlurb];

     CGRect labelRect2 = CGRectMake(15, 97, ([UIScreen mainScreen].bounds.size.width)-30, 150);
     aboutWelcomeLabel = [[UILabel alloc] initWithFrame:labelRect2];
    [aboutWelcomeLabel setTextColor:[UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0]];
    //[aboutWelcomeLabel setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:224.0/255.0 alpha:0.3]];
    [aboutWelcomeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:50]];
    aboutWelcomeLabel.text = @"Greetings, road-tripper!";
    aboutWelcomeLabel.textAlignment = NSTextAlignmentCenter;
    aboutWelcomeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    aboutWelcomeLabel.numberOfLines = 0;
    [self.view addSubview:aboutWelcomeLabel];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end