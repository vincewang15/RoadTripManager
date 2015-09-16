//
//  MapPart.m
//  RTMProject
//
//  Created by Vincewang on 7/22/15.
//
//

#import "MapPart.h"
#import <Parse/Parse.h>
#import "GasStation.h"
#import "DirectionPage.h"
#import "YelpAPI.h"

@interface MapPart ()

typedef void (^CompletionBlock)(BOOL);

@end

@implementation MapPart
@synthesize theCarInfo;
@synthesize thePrefInfo;
@synthesize instructions;

@synthesize locationManager;

NSString *food;
CLPlacemark *starter;
CLPlacemark *destination;
MKPointAnnotation* starterPA;
MKPointAnnotation* destinationPA;
MKRoute *routeDetails;
NSMutableArray *arrayForPoints;
NSMutableArray *arrayForGas;
NSMutableArray *arrayForZipCode;
NSMutableArray *candidate;  //address for gas station
NSMutableArray *arrayForGeo;
NSMutableArray *arrayForName;    //brand for gas station
NSMutableArray *arrayForPrice;     //price of gas
NSMutableDictionary *dictionaryForGasStation;
NSMutableDictionary *dictionaryForRest;

NSString *nameOfFuel;
int fulldistance;
int numOffuel;
int interval1;
int interval2;
int flag;
int flagcap;
double totalDistance;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.mapView.delegate = self;
    // Test theCarInfo received
    NSLog(@"Received Car Info:%@", self.theCarInfo);
    // Retrieve the Preference Info
    self.thePrefInfo = [[PreferenceInfo alloc] init];
    [[self thePrefInfo] retrievePreferenceInfoFromCloud:^(BOOL successed, NSError *error){
        if (!error && successed) {
            NSLog(@"Retrieved Preference from Cloud: %@", [self thePrefInfo]);
        } else {
            NSLog(@"Retrieved Preference Failed with Error: %@", error);
        }
    }];
    
    self.locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    // [self.destinationText setText:@"washington university"];
    // [self.startText setText:@"stl"];
    [self setUpEverything];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}


-(void)drawByCoordinate:(CLLocationCoordinate2D)startPlace endBy:(CLLocationCoordinate2D)endPlace{
    MKPlacemark *startMKP= [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(startPlace.latitude,startPlace.longitude) addressDictionary:nil];
    MKPlacemark *endMKP= [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(endPlace.latitude,endPlace.longitude) addressDictionary:nil];
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    [directionsRequest setSource:[[MKMapItem alloc] initWithPlacemark:startMKP]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:endMKP]];
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            routeDetails = response.routes[0];
            [self.mapView addOverlay:routeDetails.polyline];
        }
        
    }];
}

-(void)drawByCLPlacemark:(CLPlacemark *)startPlace endBy:(CLPlacemark *)endPlace address:(NSString *)a{
    MKPlacemark *startMKP= [[MKPlacemark alloc] initWithPlacemark:startPlace];
    MKPlacemark *endMKP= [[MKPlacemark alloc] initWithPlacemark:endPlace];
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    [directionsRequest setSource:[[MKMapItem alloc] initWithPlacemark:startMKP]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:endMKP]];
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            MKRoute *newrouteDetails = response.routes[0];
            if(self.thePrefInfo.showGas)
                [self.mapView addOverlay:newrouteDetails.polyline];
            NSString* everyinstruction=[[NSString alloc]init];
            for (int i = 0; i < newrouteDetails.steps.count; i++) {
                MKRouteStep *step = [newrouteDetails.steps objectAtIndex:i];
                NSString *newStep = step.instructions;
                everyinstruction = [everyinstruction stringByAppendingString:newStep];
                everyinstruction = [everyinstruction stringByAppendingString:@"\n\n"];
                //  NSLog(@"%f %f",step.polyline.coordinate.latitude,step.polyline.coordinate.longitude);
            }
            [self.instructions setObject:everyinstruction forKey:a];
            NSLog(@"%@",a);
            NSLog(@"%@",everyinstruction);
        }
        
    }];
}



-(void)getGeoPoint:(NSMutableArray *)candidatePoints completion:(void (^)(BOOL error))completion{
    
    arrayForGeo=[[NSMutableArray alloc]init];
    [arrayForGeo addObject:starter];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        for(NSString *address in candidatePoints){
            dispatch_group_t requestGroup = dispatch_group_create();
            dispatch_group_enter(requestGroup);
            CLGeocoder *geocoderTemp = [[CLGeocoder alloc] init];
            [geocoderTemp geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
                if (!error) {
                    [arrayForGeo addObject:[placemarks lastObject]];
                }
                // NSLog(@"Inside");
                dispatch_group_leave(requestGroup);
            }];
            dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER);
        }
        [arrayForGeo addObject:destination];
        completion(YES);
    });
    
}


-(void)getGasStation:(NSMutableArray *)arrayForZipCode completion:(void (^)(BOOL error))completion{
    
    arrayForGas=[[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        flag=0;
        flagcap=[arrayForZipCode count];
        dispatch_group_t requestGroup = dispatch_group_create();
        for(NSString *zipcode in arrayForZipCode){
            
            if(flag==0){
                dispatch_group_enter(requestGroup);
                flag++;
            }
            [PFCloud callFunctionInBackground:@"GetGasStationByZipCode" withParameters:@{@"ZipCode":zipcode} block:^(NSNumber *response,NSError *error) {
                if (!error) {
                    int index=-1;
                    int min=-1;
                    float price=FLT_MAX;
                    for(NSDictionary* tempStations in (NSArray *)response){
                        index++;
                        NSString* nowprice=tempStations[nameOfFuel];
                        if(![nowprice isEqualToString:@"N/A"]){
                            if([[nowprice substringFromIndex:1] floatValue]<price){
                                min=index;
                                price=[[nowprice substringFromIndex:1] floatValue];
                            }
                        }
                        //[arrayForGas addObject:[[GasStation alloc]initWith:tempStations]];
                        //       NSLog(@"%@",(NSArray *)tempStations);
                    }
                    if(index!=-1){
                        [arrayForGas addObject:[[GasStation alloc]initWith:[(NSArray *)response objectAtIndex:index]]];
                    }
                }
                // NSLog(@"Inside");
                flag++;
                if(flag>flagcap){
                    dispatch_group_leave(requestGroup);
                    flag=0;
                }
            }];
            
        }
        dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER);
        completion(YES);
    });
    
}

-(void)getZipCode:(NSMutableArray *)arrayForPoints completion:(void (^)(BOOL error))completion{
    arrayForZipCode=[[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        dispatch_group_t requestGroup = dispatch_group_create();
        for(CLLocation *tempPoint in arrayForPoints){
            dispatch_group_enter(requestGroup);
            CLGeocoder *geoforpoint = [[CLGeocoder alloc] init] ;
            [geoforpoint reverseGeocodeLocation:tempPoint completionHandler:^(NSArray *placeforzip, NSError *error) {
                if (!error) {
                    if (placeforzip && placeforzip.count > 0)
                    {
                        CLPlacemark *placemarkforzip = placeforzip[0];
                        NSString *tempzip=placemarkforzip.postalCode;
                        
                        if([arrayForZipCode count]>0){
                            if(![[arrayForZipCode lastObject]isEqualToString:tempzip])
                                [arrayForZipCode addObject:tempzip];
                        }else{
                            [arrayForZipCode addObject:tempzip];
                        }
                    }
                }
                
                //    NSLog(@"1");
                dispatch_group_leave(requestGroup);
            }];
            dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER);
            //     NSLog(@"2");
        }
        completion(YES);
    });
}

/*- (IBAction)buttonOfYu:(UIButton *)sender {
    YelpAPI* newyelp=[[YelpAPI alloc]init];
    [newyelp queryTopBusinessInfoForTerm:food location:@"Chicago" completionHandler:^(NSDictionary *jsonResponse, NSError *error){
        if(!error){
            NSLog(@"%@",jsonResponse);
             NSDictionary *rest=[jsonResponse objectAtIndex:0];
             NSLog(@"%@",rest);
            NSDictionary* locforrest=jsonResponse[@"location"];
            NSDictionary* coorforrest=locforrest[@"coordinate"];
            double lati=[coorforrest[@"latitude"] doubleValue];
            double longi=[coorforrest[@"longitude"] doubleValue];
            double rate=[jsonResponse[@"rating"] doubleValue];
            NSString *ratingsign=@"Rating: ";
            [self addAnnforRestaurant:lati another:longi name:jsonResponse[@"name"] rate:[ratingsign stringByAppendingString:[NSString stringWithFormat:@"%0.2f", rate]]];
        }
    }
     
     ];
}*/

- (IBAction)routeButtonPressed:(UIButton *)sender {
    if(!starter||!destination)
        return;
    [self.mapView removeOverlays:self.mapView.overlays];
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKPlacemark *destinationmark = [[MKPlacemark alloc] initWithPlacemark:destination];
    MKPlacemark *startmark=[[MKPlacemark alloc] initWithPlacemark:starter];
    [directionsRequest setSource:[[MKMapItem alloc] initWithPlacemark:startmark]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:destinationmark]];
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    // show spinning view
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            routeDetails = response.routes.lastObject;
            totalDistance= routeDetails.distance/1609.344;
            self.destinationLabel.text = [placemark.addressDictionary objectForKey:@"Street"];
            self.distanceLabel.text = [NSString stringWithFormat:@"%0.1f Miles", routeDetails.distance/1609.344];
            int hour=(routeDetails.distance/1690.344)/60;
            int minute=(int)(routeDetails.distance/1690.344-60*hour+0.5);
        
            self.time.text=[NSString stringWithFormat:@"%d hrs %d mins", hour,minute];
            numOffuel=((routeDetails.distance/1000)/(fulldistance-100))+1;
            
            self.allSteps = @"";
            NSLog(@"%@ %lu",@"route step: ",(unsigned long)routeDetails.steps.count);
            if(![thePrefInfo showGas]){
                [self.mapView addOverlay:routeDetails.polyline];
            }
            arrayForPoints=[[NSMutableArray alloc]init];
            int flag=0;
            int count=0;
            for (int i = 0; i < routeDetails.steps.count; i++) {
                MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
                NSString *newStep = step.instructions;
                self.allSteps = [self.allSteps stringByAppendingString:newStep];
                self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
                if(step.distance<3000){
                    if(flag==0&&count==0){
                        [arrayForPoints addObject:[[CLLocation alloc] initWithLatitude:step.polyline.coordinate.latitude longitude:step.polyline.coordinate.longitude]];
                        flag=1;
                    }
                    if(count==7)
                        count=0;
                    else
                        count++;
                }else{
                    for(int j=0;j<step.polyline.pointCount;j+=50){
                        CLLocationCoordinate2D tempCoor=MKCoordinateForMapPoint(step.polyline.points[j]);
                        [arrayForPoints addObject:[[CLLocation alloc] initWithLatitude:tempCoor.latitude longitude:tempCoor.longitude]];
                    }
                    flag=0;
                    count=-1;
                }
            }
            
            //  [self sendInfo];
            [self getZipCode:arrayForPoints completion:^(BOOL error){
                NSLog(@"%@ %lu",@"zipcode:" ,(unsigned long)arrayForZipCode.count);
                [self getGasStation:arrayForZipCode completion:^(BOOL error){
                    NSLog(@"%@ %lu",@"gas station:",arrayForGas.count);
                    int index=0;
                    candidate=[[NSMutableArray alloc]init];
                    arrayForName=[[NSMutableArray alloc]init];
                    arrayForPrice=[[NSMutableArray alloc]init];
                    dictionaryForGasStation=[[NSMutableDictionary alloc]init];
                    interval1=(int)[arrayForGas count]/(numOffuel);
                    interval2=interval1/2;
                    int next=interval1;
                    /*   for(GasStation *forPrint in arrayForGas){
                     NSLog(@"%@ %f",forPrint.address,[forPrint getPrice:nameOfFuel]);
                     }*/
                    while(index<[arrayForGas count]){
                        int i=index;
                        int min=-1;
                        float price=FLT_MAX;
                        for(;i<next&&i<[arrayForGas count];i++){
                            GasStation *tempS=[arrayForGas objectAtIndex:i];
                            if([tempS getPrice:nameOfFuel]<price){
                                min=i;
                                price=[tempS getPrice:nameOfFuel];
                            }
                        }
                        if(min>-1){
                            GasStation *tempS=[arrayForGas objectAtIndex:min];
                            [candidate addObject:tempS.address];
                            [arrayForName addObject:tempS.brand];
                            [arrayForPrice addObject:[NSString stringWithFormat:@"%@ %0.2f", @"$",[tempS getPrice:nameOfFuel]]];
                            [dictionaryForGasStation setObject:tempS forKey:[candidate lastObject]];
                            index=MAX(next, min+interval2);
                            next=min+interval1;
                            
                        }else{
                            index=next;
                            next=next+interval1;
                        }
                    }
                    NSLog(@"%@ %lu",@"Candidate:",[candidate count]);
                    [self getGeoPoint:candidate completion:^(BOOL error) {
                        
                        self.instructions=[[NSMutableDictionary alloc]init];
                        NSLog(@"%lu",(unsigned long)[arrayForGeo count]);
                        for(int i=0;i<[arrayForGeo count]-1;++i){
                            CLPlacemark* firstP=[arrayForGeo objectAtIndex:i];
                            CLPlacemark* secondP=[arrayForGeo objectAtIndex:i+1];
                            NSString *addr=(i<[arrayForGeo count]-2)?[candidate objectAtIndex:i]:self.destinationText.text;
                            [self drawByCLPlacemark:firstP endBy:secondP address:addr];
                            if(i>0){
                                if(self.thePrefInfo.showGas)
                                    [self addAnnotation:firstP name:[[arrayForName objectAtIndex:i-1] stringByAppendingString:[arrayForPrice objectAtIndex:i-1]] address:[candidate objectAtIndex:i-1]];
                                NSLog(@"%@ %@",@"name of GS:",[arrayForName objectAtIndex:i-1]);
                            }
                        }
                        [candidate addObject:self.destinationText.text];
                        [self addAnnotation1:starter name:self.startText.text];
                        [self addAnnotation2:destination name:self.destinationText.text];
                    }];
                    if(self.thePrefInfo.showFood){
                        [self searchRest];
                        for(NSString* tempA in candidate){
                            [self searchRestByAddress:tempA];
                        }
                    }
                }];
                
            }];
        }
        // hide spinning view
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        float spanX;
        float spanY;
        if(totalDistance<100){
            spanX=0.5;
            spanY=0.5;
        }else{
            spanX = numOffuel*fulldistance/100.0;
            spanY = numOffuel*fulldistance/100.0;
        }
        MKCoordinateRegion region;
        region.center.latitude = starter.location.coordinate.latitude;
        region.center.longitude = starter.location.coordinate.longitude;
        region.span = MKCoordinateSpanMake(spanX, spanY);
        [self.mapView setRegion:region animated:YES];
    }];
    
}


- (IBAction)addressSearch:(UITextField *)sender {
    self.destinationLabel.text = nil;
    self.distanceLabel.text = @"distance";
    [self.mapView removeOverlay:routeDetails.polyline];
    [self.mapView removeAnnotation:starterPA];
    CLGeocoder *geocoderTemp = [[CLGeocoder alloc] init];
    [geocoderTemp geocodeAddressString:sender.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            starter = [placemarks lastObject];
            float spanX = 0.50725;
            float spanY = 0.50725;
            MKCoordinateRegion region;
            region.center.latitude = starter.location.coordinate.latitude;
            region.center.longitude = starter.location.coordinate.longitude;
            region.span = MKCoordinateSpanMake(spanX, spanY);
            [self.mapView setRegion:region animated:YES];
            [self addAnnotation1:starter name:sender.text];
        }
    }];
}

- (IBAction)startsearch:(UITextField *)sender {
    self.destinationLabel.text = nil;
    self.distanceLabel.text = @"distance";
    [self.mapView removeOverlay:routeDetails.polyline];
    [self.mapView removeAnnotation:destinationPA];
    CLGeocoder *geocoderTemp = [[CLGeocoder alloc] init];
    [geocoderTemp geocodeAddressString:sender.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            destination = [placemarks lastObject];
            float spanX = 0.50725;
            float spanY = 0.50725;
            MKCoordinateRegion region;
            region.center.latitude = destination.location.coordinate.latitude;
            region.center.longitude = destination.location.coordinate.longitude;
            region.span = MKCoordinateSpanMake(spanX, spanY);
            [self.mapView setRegion:region animated:YES];
            [self addAnnotation2:destination name:sender.text];
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked");
    }
    //   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    //   [alertView show];
}

-(void)searchRest{
    YelpAPI* newyelp=[[YelpAPI alloc]init];
    [newyelp queryTopBusinessInfoForTerm:food location:self.destinationText.text completionHandler:^(NSDictionary *jsonResponse, NSError *error){
        if(!error){
            NSLog(@"%@",jsonResponse);
            /*  NSDictionary *rest=[jsonResponse objectAtIndex:0];
             NSLog(@"%@",rest);*/
            NSDictionary* locforrest=jsonResponse[@"location"];
            NSDictionary* coorforrest=locforrest[@"coordinate"];
            double lati=[coorforrest[@"latitude"] doubleValue];
            double longi=[coorforrest[@"longitude"] doubleValue];
            double rate=[jsonResponse[@"rating"] doubleValue];
            NSString *ratingsign=@"Rating: ";
            [dictionaryForRest setObject:jsonResponse forKey:jsonResponse[@"name"]];
            [self addAnnforRestaurant:lati another:longi name:jsonResponse[@"name"] rate:[ratingsign stringByAppendingString:[NSString stringWithFormat:@"%0.2f", rate]]];
        }
    }
    ];
}

-(void)searchRestByAddress:(NSString *)address{
    YelpAPI* newyelp=[[YelpAPI alloc]init];
    [newyelp queryTopBusinessInfoForTerm:food location:address completionHandler:^(NSDictionary *jsonResponse, NSError *error){
        if(!error){
            NSLog(@"%@",jsonResponse);
            /*  NSDictionary *rest=[jsonResponse objectAtIndex:0];
             NSLog(@"%@",rest);*/
            NSDictionary* locforrest=jsonResponse[@"location"];
            NSDictionary* coorforrest=locforrest[@"coordinate"];
            double lati=[coorforrest[@"latitude"] doubleValue];
            double longi=[coorforrest[@"longitude"] doubleValue];
            double rate=[jsonResponse[@"rating"] doubleValue];
            NSString *ratingsign=@"Rating: ";
            [dictionaryForRest setObject:jsonResponse forKey:jsonResponse[@"name"]];
            [self addAnnforRestaurant:lati another:longi name:jsonResponse[@"name"] rate:[ratingsign stringByAppendingString:[NSString stringWithFormat:@"%0.2f", rate]]];
        }
    }
    ];
}

-(void)addAnnforRestaurant:(double)latitude another:(double)longitude name:(NSString *)n rate:(NSString *)r{
    MKPointAnnotation* tempAnno=[[MKPointAnnotation alloc] init];
    tempAnno.coordinate=CLLocationCoordinate2DMake(latitude,longitude);
    tempAnno.title=n;
    tempAnno.subtitle=r;
    [self.mapView addAnnotation:tempAnno];
}

-(void)addAnnotation:(CLPlacemark *)placemarkTemp name:(NSString *)n address:(NSString *)p{
    MKPointAnnotation* tempAnno=[[MKPointAnnotation alloc] init];
    tempAnno.coordinate=CLLocationCoordinate2DMake(placemarkTemp.location.coordinate.latitude, placemarkTemp.location.coordinate.longitude);
    tempAnno.title=n;
    tempAnno.subtitle=p;
    [self.mapView addAnnotation:tempAnno];
    [self.mapView setNeedsDisplay];
}


- (void)addAnnotation1:(CLPlacemark *)placemarkTemp name:(NSString *)n{
    starterPA = [[MKPointAnnotation alloc] init];
    starterPA.coordinate = CLLocationCoordinate2DMake(placemarkTemp.location.coordinate.latitude, placemarkTemp.location.coordinate.longitude);
    starterPA.title = n;
    starterPA.subtitle = [placemarkTemp.addressDictionary objectForKey:@"City"];
    [self.mapView addAnnotation:starterPA];
    [self.mapView setNeedsDisplay];
    
}

- (void)addAnnotation2:(CLPlacemark *)placemarkTemp name:(NSString *)n{
    destinationPA = [[MKPointAnnotation alloc] init];
    destinationPA.coordinate = CLLocationCoordinate2DMake(placemarkTemp.location.coordinate.latitude, placemarkTemp.location.coordinate.longitude);
    destinationPA.title = n;
    destinationPA.subtitle = [placemarkTemp.addressDictionary objectForKey:@"City"];
    [self.mapView addAnnotation:destinationPA];
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    routeLineRenderer.strokeColor = [UIColor redColor];
    routeLineRenderer.lineWidth = 5;
    return routeLineRenderer;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:[annotation title]];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.calloutOffset = CGPointMake(0, 16);
            pinView.canShowCallout = YES;
            pinView.pinColor=MKPinAnnotationColorPurple;
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
            
            //NahNah added:
            pinView.draggable = NO;
            pinView.highlighted = YES;
            pinView.animatesDrop = TRUE;
            pinView.canShowCallout = YES;
            
            // Add an image to the left callout.
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like"]];
            pinView.leftCalloutAccessoryView = iconView;
            
            NSString* addressOfAnno=[annotation subtitle];
            if(dictionaryForRest[[annotation title]]){
                pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]];
                pinView.calloutOffset = CGPointMake(0, 16);
                pinView.canShowCallout = YES;
                pinView.pinColor=MKPinAnnotationColorGreen;
                UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like"]];
                iconView.bounds = CGRectMake(0,0,32,32);
                pinView.leftCalloutAccessoryView = iconView;
                UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                pinView.rightCalloutAccessoryView = rightButton;
            }
            else if(dictionaryForGasStation[addressOfAnno]==nil){
                // If an existing pin view was not available, create one.
                pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation subtitle]];
                pinView.calloutOffset = CGPointMake(0, 16);
                pinView.canShowCallout = YES;
                pinView.pinColor=MKPinAnnotationColorPurple;
                //   UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                //   pinView.rightCalloutAccessoryView = rightButton;
            }else{
                pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation subtitle]];
                pinView.calloutOffset = CGPointMake(0, 16);
                pinView.canShowCallout = YES;
                
                GasStation *gasstation=dictionaryForGasStation[[annotation subtitle]];
                if ([gasstation.brand isEqualToString:@" Mobil "]){
                    pinView.image = [UIImage imageNamed:@"mobil.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Phillips 66 "]){
                    pinView.image = [UIImage imageNamed:@"phillips66.png"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Conoco "]){
                    pinView.image = [UIImage imageNamed:@"conoco.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Conoco "]){
                    pinView.image = [UIImage imageNamed:@"conoco.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Circle K "]){
                    pinView.image = [UIImage imageNamed:@"Circle-K.png"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" BP "]){
                    pinView.image = [UIImage imageNamed:@"bp.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Zx "]){
                    pinView.image = [UIImage imageNamed:@"ZX.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Zoomerz "]){
                    pinView.image = [UIImage imageNamed:@"zoomerz.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Zip Trip "]){
                    pinView.image = [UIImage imageNamed:@"ziptrip.jpeg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Xtramart "]){
                    pinView.image = [UIImage imageNamed:@"Xtra-Mart.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Woodys Food Store "]){
                    pinView.image = [UIImage imageNamed:@"woodys.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Wilcohess "]){
                    pinView.image = [UIImage imageNamed:@"wilcohess.png"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Western Convenience Stores "]){
                    pinView.image = [UIImage imageNamed:@"WesternConveniencelogo.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Wawa "]){
                    pinView.image = [UIImage imageNamed:@"wawa.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Vp Racing Fuels "]){
                    pinView.image = [UIImage imageNamed:@"vp.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Valero "]){
                    pinView.image = [UIImage imageNamed:@"valero.png"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Usa Gasoline "]){
                    pinView.image = [UIImage imageNamed:@"usagasoline.png"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" United Dairy Farmers "]){
                    pinView.image = [UIImage imageNamed:@"united dairy farmers.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Shell "]){
                    pinView.image = [UIImage imageNamed:@"shell.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Amoco "]){
                    pinView.image = [UIImage imageNamed:@"amoco.png"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Chevron "]){
                    pinView.image = [UIImage imageNamed:@"Chevron.jpg"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                else if ([gasstation.brand isEqualToString:@" Citgo "]){
                    pinView.image = [UIImage imageNamed:@"citgo.png"];
                    pinView.bounds = CGRectMake(0,0,32,32);}
                
                
                
                //no young foods
                //no woodmans markets
                
                
                else
                {pinView.image = [UIImage imageNamed:@"Gas Station-32.png"];}
                //pinColor=MKPinAnnotationColorRed;
                
                UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                pinView.rightCalloutAccessoryView = rightButton;
                UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"door"]];
                pinView.leftCalloutAccessoryView = iconView;
                //GasStation *gasstation=dictionaryForGasStation[addressOfAnno];
                
            }
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    if(dictionaryForRest[[view.annotation title]]){
        NSDictionary* dictforRest=dictionaryForRest[[view.annotation title]];
        NSString* name=[view.annotation title];
        NSString* rating=[view.annotation subtitle];
        NSString* phone=dictforRest[@"display_phone"];
        phone=([phone length]>0)?phone:@"Unknown";
        [[[UIAlertView alloc] initWithTitle:@"Restaurant details"
                                    message:[NSString stringWithFormat:@"%@ \n\n  %@ \n\n phone number: %@", name, rating,phone] delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }else{
    NSString* addressOfAnno=[view.annotation subtitle];
    GasStation *gasstation = dictionaryForGasStation[addressOfAnno];
    NSString *brandforgasstation=gasstation.brand;
    NSString *addressforgasstation = gasstation.address;
    NSString *premiumGasPrice = gasstation.premium;
    NSString *plusGasPrice = gasstation.plus;
    NSString *regularGasPrice = gasstation.regular;
    NSString *dieselGasPrice = gasstation.diesel;
    
    
    [[[UIAlertView alloc] initWithTitle:@"Gas station details"
                                message:[NSString stringWithFormat:@"%@ \n\n premium gas/gal: %@ \n plus gas/gal: %@ \n regular gas/gal: %@ \n diesel gas/gal: %@ \n\n Address: %@", brandforgasstation, premiumGasPrice, plusGasPrice, regularGasPrice, dieselGasPrice, addressforgasstation] delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
    }
}




- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    NSLog(@"%@", currentLocation);
    
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            
            NSLog(@"Country: %@", placemark.country);
            NSLog(@"Area: %@", placemark.administrativeArea);
            NSLog(@"City: %@", placemark.locality);
            NSLog(@"Code: %@", placemark.postalCode);
            NSLog(@"Road: %@", placemark.thoroughfare);
            NSLog(@"Number: %@", placemark.subThoroughfare);
            NSLog(@"%f %f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
            // Stop Location Manager
            float spanX = 0.50725;
            float spanY = 0.50725;
            MKCoordinateRegion region;
            region.center.latitude = placemark.location.coordinate.latitude;
            region.center.longitude = placemark.location.coordinate.longitude;
            region.span = MKCoordinateSpanMake(spanX, spanY);
            [self.mapView setRegion:region animated:YES];
            [self.mapView setShowsUserLocation:YES];
            [self.locationManager stopUpdatingLocation];
            
        } else {
            NSLog(@"%@", error.debugDescription);
            [self.locationManager stopUpdatingLocation];
            
        }
    }];
}

-(void)setUpEverything{
    NSMutableDictionary* carDict=self.theCarInfo.details;
    if([carDict[@"engineFuel"] isKindOfClass:[NSNull class]]){
        nameOfFuel=@"regular";
    }else{
        NSString* fuel=carDict[@"engineFuel"];
        if([fuel isEqualToString:@"Diesel"]){
            nameOfFuel=@"diesel";
        }else if ([fuel isEqualToString:@"Plus"]||[fuel isEqualToString:@"Plus Unleaded"]){
            nameOfFuel=@"plus";
        }else if ([fuel isEqualToString:@"Premium"]||[fuel isEqualToString:@"Premium Unleaded"]){
            nameOfFuel=@"premium";
        }else{
            nameOfFuel=@"regular";
        }
    }
    if([carDict[@"lkmHighway"] isKindOfClass:[NSNull class]]||[carDict[@"fuelCap"] isKindOfClass:[NSNull class]]){
        fulldistance=700;
    }else{
        fulldistance=[carDict[@"lkmHighway"] floatValue]*[carDict[@"fuelCap"] floatValue];
    }
    food=[[NSString alloc]init];
    if(self.thePrefInfo.showFood)
        food=self.thePrefInfo.foodPref;
    dictionaryForRest=[[NSMutableDictionary alloc]init];
}

- (IBAction)showInstructions:(UIButton *)sender {
    [self performSegueWithIdentifier:@"Route Pusher" sender:self.allSteps];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"Route Pusher"]){
        DirectionPage *nextpage=(DirectionPage *)[segue destinationViewController];
        nextpage.directinstruction=sender;
        nextpage.instructions=self.instructions;
        nextpage.endPoints=candidate;
        nextpage.showGas=self.thePrefInfo.showGas;
    }
}




/*- (void)didReceiveMemoryWarning
 {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }*/

@end
