//
//  MapViewController.h
//  RentHouseProject
//
//  Created by conandi on 16/7/21.
//  Copyright © 2016年 Chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol UPdateCoordinate  <NSObject>

-(void) updateTextCoordinate:(NSString *)latiutude withLongtitude:(NSString *)longtitude;

@end

@interface MapViewController2 : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
@property (nonatomic, assign) id<UPdateCoordinate> myUpdateCoordinate;
@end
