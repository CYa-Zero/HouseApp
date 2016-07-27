//
//  AddNewPropertyViewController.h
//  RentHouseProject
//
//  Created by conandi on 16/7/21.
//  Copyright © 2016年 Chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController2.h"
#import "ELCImagePickerHeader.h"
@interface AddNewPropertyViewController : UIViewController<UPdateCoordinate,ELCImagePickerControllerDelegate>
@property (strong, nonatomic) NSArray *passArray;
@end
