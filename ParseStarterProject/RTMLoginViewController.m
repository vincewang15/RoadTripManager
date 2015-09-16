//
//  RTMLoginViewController.m
//  RTMProject
//
//  Created by Yu Xiao on 7/26/15.
//  Referenced from https://www.parse.com/tutorials/login-and-signup-views
//
//

#import "RTMLoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RTMLoginViewController ()

@end

@implementation RTMLoginViewController
@synthesize label;
@synthesize label2;
@synthesize label3;

#pragma mark - Custom UI Design

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pic2.jpg"]]];
    //[self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"signUp.jpg"]]];
    [self.signUpController.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"signup3 copy.jpg"]]];
    self.logInView.logo = label;
    self.signUpController.signUpView.logo = label2;
    
    CGRect labelRect = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 70);
    CGRect labelRect2 = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 90);
    CGRect labelRect3 = CGRectMake(0, 170, [UIScreen mainScreen].bounds.size.width, 40);
    
    label = [[UILabel alloc] initWithFrame:labelRect];
    label2 = [[UILabel alloc]initWithFrame:labelRect2];
    label3 = [[UILabel alloc]initWithFrame:labelRect3];
    
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:40.0f]];
    [label2 setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:40.0f]];
    [label3 setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25.0f]];
    //[label setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:88.0/255.0 blue:79.0/255.0 alpha:0.4]];
    //[label2 setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:88.0/255.0 blue:79.0/255.0 alpha:1.0]];
    //[label3 setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:88.0/255.0 blue:79.0/255.0 alpha:0.7]];
    label.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
    label2.textColor = [UIColor colorWithRed:77.0/255 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
    label3.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label2.textAlignment = NSTextAlignmentCenter;
    label3.textAlignment = NSTextAlignmentCenter;
    
    label.text = @"Road Trip Manager";
    label2.text = @"Road Trip Manager";
    label3.text = @"save money on gas!";
    [self.view addSubview:label];
    [self.signUpController.view addSubview:label2];
    [self.view addSubview:label3];
    
    
    self.logInView.signUpButton.backgroundColor = [UIColor colorWithRed:0.0/250.0 green:206.0/255.0 blue:209.0/255.0 alpha:.7];
    
    [self.logInView.usernameField setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:.5]];
    [self.signUpController.signUpView.usernameField setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:.5]];
    [self.logInView.passwordField setBackgroundColor:[UIColor colorWithRed:250.0/250.0 green:250.0/255.0 blue:250.0/255.0 alpha:.65]];
    [self.signUpController.signUpView.passwordField setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:.5]];
    [self.signUpController.signUpView.emailField setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:.5]];
    [self.logInView.passwordForgottenButton setTitleColor:[UIColor colorWithRed:250.0/250.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Delegate PFLoginViewController

-(BOOL) logInViewController:(PFLogInViewController * __nonnull)logInController shouldBeginLogInWithUsername:(NSString * __nonnull)username password:(NSString * __nonnull)password {
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // begin login process
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make Sure you fill out all of the information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return NO;
    }
}

-(void)logInViewController:(PFLogInViewController * __nonnull)logInController didLogInUser:(PFUser * __nonnull)user {
    NSLog(@"Did login");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)viewDidLayoutSubviews {
    
    [self.logInView.usernameField setFrame:CGRectMake(0.0, 245.0f, [UIScreen mainScreen].bounds.size.width, 50.0f)];
    [self.signUpController.signUpView.usernameField setFrame:CGRectMake(35.0, 245.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(0.0f, 295.0f, [UIScreen mainScreen].bounds.size.width, 50.0f)];
    [self.signUpController.signUpView.passwordField setFrame:CGRectMake(35.0f, 295.0f, 250.0f, 50.0f)];
    [self.logInView.logInButton setFrame:CGRectMake(0.0f, 345.0f, [UIScreen mainScreen].bounds.size.width, 50.0f)];
    [self.signUpController.signUpView.emailField setFrame:CGRectMake(35.0f, 345.0f, 250.0f, 50.0f)];
    [self.logInView.passwordForgottenButton setFrame:CGRectMake(0.0f, 395.0f, [UIScreen mainScreen].bounds.size.width, 50.0f)];
    [self.signUpController.signUpView.signUpButton setFrame:CGRectMake(25.0f, 415.0f, 270.0f, 50.0f)];
}

#pragma mark - Sign up view
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//
//}


@end
