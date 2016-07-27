//
//  MapViewController.m
//  RentHouseProject
//
//  Created by conandi on 16/7/21.
//  Copyright © 2016年 Chenyang. All rights reserved.
//

#import "MapViewController2.h"

@interface MapViewController2 ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)backBtn_Tapped:(UIBarButtonItem *)sender;
- (IBAction)selectBtn_Tapped:(UIBarButtonItem *)sender;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longtitude;
@property(strong,nonatomic) CLLocationManager *locationManager;
@end

@implementation MapViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareMapView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareMapView{
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setMapType:MKMapTypeStandard];
    
    _locationManager = [[CLLocationManager alloc]init];
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    //[lpgr dealloc];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    NSLog(@"%f,%f",touchMapCoordinate.latitude, touchMapCoordinate.longitude);
    _latitude = [NSString stringWithFormat:@"%f",touchMapCoordinate.latitude];
    _longtitude = [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annot];
    
    //[annot release];
}

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id) annotation {
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"myPin"] ; } else { pin.annotation = annotation;
        }
    pin.animatesDrop = YES;
    pin.draggable = YES; return pin;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        [annotationView.annotation setCoordinate:droppedAt];
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        _latitude = [NSString stringWithFormat:@"%f",droppedAt.latitude];
        _longtitude = [NSString stringWithFormat:@"%f",droppedAt.longitude];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtn_Tapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectBtn_Tapped:(UIBarButtonItem *)sender {
    [self.myUpdateCoordinate updateTextCoordinate:_latitude withLongtitude:_longtitude];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
