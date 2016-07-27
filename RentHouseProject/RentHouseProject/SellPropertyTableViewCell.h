//
//  SellPropertyTableViewCell.h
//  RentHouseProject
//
//  Created by conandi on 16/7/21.
//  Copyright © 2016年 Chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellPropertyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *propertyImageView;
@property (weak, nonatomic) IBOutlet UILabel *propertyName;
@property (weak, nonatomic) IBOutlet UILabel *propertyType;
@property (weak, nonatomic) IBOutlet UILabel *propertyCost;
@property (weak, nonatomic) IBOutlet UILabel *propertyAddress1;


@end
