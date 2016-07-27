//
//  AllListDetailViewController.m
//  RentHouseProject
//
//  Created by conandi on 16/7/24.
//  Copyright © 2016年 Chenyang. All rights reserved.
//

#import "AllListDetailViewController.h"
#import "ListDetailCollectionViewCell.h"

@interface AllListDetailViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *propertyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyAddressLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)backBtn_Tapped:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSMutableArray *imageUrlStringArray;
@end

@implementation AllListDetailViewController
@synthesize passDict = _passDict;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    // Do any additional setup after loading the view.
}

-(void)prepareData{
    _imageUrlStringArray = [[NSMutableArray alloc]init];
    _propertyNameLabel.text = [_passDict valueForKey:@"Property Name"];
    _propertyTypeLabel.text = [_passDict valueForKey:@"Property Type"];
    if ([[_passDict valueForKey:@"Property Category"] isEqualToString:@"1"]) {
        _propertyCategoryLabel.text = @"For Sale";
        _propertyCostLabel.text = [NSString stringWithFormat:@"Sale at Price: $%@",[_passDict valueForKey:@"Property Cost"]];
    }else{
        _propertyCategoryLabel.text = @"For Rent";
        _propertyCostLabel.text = [NSString stringWithFormat:@"Rent at Price: $%@/Month",[_passDict valueForKey:@"Property Cost"]];
    }
    _propertyAddressLabel.text = [NSString stringWithFormat:@"%@ %@",[_passDict valueForKey:@"Property Address1"],[_passDict valueForKey:@"Property Address2"]];
    
    NSString *str1 =[_passDict valueForKey:@"Property Image 1"];
    NSLog(@"%@",str1);
    if ([str1 length]) {
        NSString *imageStr = [str1 stringByReplacingOccurrencesOfString:@"\\"withString:@"/"];
        NSString *imageStrin = [imageStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *imageString = [NSString stringWithFormat:@"http://%@",imageStrin];
        [_imageUrlStringArray addObject:imageString];
    }
    NSString *str2 =[_passDict valueForKey:@"Property Image 2"];
    NSLog(@"%@",str2);
    if ([str2 length]) {
        NSString *imageStr = [str2 stringByReplacingOccurrencesOfString:@"\\"withString:@"/"];
        NSString *imageStrin = [imageStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *imageString = [NSString stringWithFormat:@"http://%@",imageStrin];
        [_imageUrlStringArray addObject:imageString];
    }
    NSString *str3 =[_passDict valueForKey:@"Property Image 3"];
    NSLog(@"%@",str3);
    if ([str3 length]) {
        NSString *imageStr = [str3 stringByReplacingOccurrencesOfString:@"\\"withString:@"/"];
        NSString *imageStrin = [imageStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *imageString = [NSString stringWithFormat:@"http://%@",imageStrin];
        [_imageUrlStringArray addObject:imageString];
    }
    [self showLocationInMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - collectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ListDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListDetailCollectionViewCell" forIndexPath:indexPath];
    NSLog(@"%@",[_imageUrlStringArray objectAtIndex:indexPath.row]);
    cell.houseImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_imageUrlStringArray objectAtIndex:indexPath.row]]]]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)[_imageUrlStringArray count]);
    return [_imageUrlStringArray count];
    
}

#pragma mark - mapView

-(void)showLocationInMap{
    //NSMutableArray *arre = [[NSMutableArray alloc] init];
    CLLocationDegrees lat = [[_passDict valueForKey:@"Property Latitude"] doubleValue];
    CLLocationDegrees log = [[_passDict valueForKey:@"Property Longitude"]  doubleValue];
    MKPointAnnotation *markAnotation;
        
    NSLog(@"%@ %@",[_passDict valueForKey:@"Property Latitude"],[_passDict valueForKey:@"Property Longitude"]);
    markAnotation = [[MKPointAnnotation alloc]init];
    markAnotation.title = [_passDict valueForKey:@"Property Name"];
    //markAnotation.subtitle = loc.city;
    markAnotation.coordinate = CLLocationCoordinate2DMake(lat,log);
    // setup the map pin with all data and add to map view
        
    [self.mapView addAnnotation:markAnotation];
    
}



- (IBAction)backBtn_Tapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
