//
//  AllListDetailViewController.h
//  RentHouseProject
//
//  Created by conandi on 16/7/24.
//  Copyright © 2016年 Chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface AllListDetailViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property (strong, nonatomic) NSDictionary *passDict;
@end
