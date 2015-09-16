//
//  RTMTabBarController.m
//  RTMProject
//
//  Created by Yu Xiao on 7/26/15.
//
//

#import "RTMTabBarController.h"

@implementation RTMTabBarController

#pragma mark - Set a Login check when Tab status changed

- (void)viewDidAppear:(BOOL)animated {
    [self setDelegate:self];
    [super viewDidAppear:animated];
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser){ // not current user
        RTMLoginViewController *loginVC = [[RTMLoginViewController alloc] init];
        [loginVC setDelegate:self]; // Set ourselve as delegate
        [self presentViewController:loginVC animated:YES completion:NULL];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser){ // not current user
        RTMLoginViewController *loginVC = [[RTMLoginViewController alloc] init];
        [loginVC setDelegate:self]; // Set ourselve as delegate
        [self presentViewController:loginVC animated:YES completion:NULL];
    }
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
    NSLog(@"Did loggin with User: %@", [user username]);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
