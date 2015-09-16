//
//  MapPart.h
//  RTMProject
//
//  Created by Vincewang on 7/22/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CarInfo.h"
#import "PreferenceInfo.h"
#import "MBProgressHUD.h"


@interface MapPart : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@property (strong, nonatomic) CLLocationManager *locationManager;


@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITextField *destinationText;
@property (weak, nonatomic) IBOutlet UITextField *startText;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@property (strong, nonatomic) NSString *allSteps;

@property (nonatomic, strong) CarInfo *theCarInfo;
@property (nonatomic, strong) PreferenceInfo *thePrefInfo;
@property (nonatomic, strong) NSMutableDictionary *instructions;
@end
