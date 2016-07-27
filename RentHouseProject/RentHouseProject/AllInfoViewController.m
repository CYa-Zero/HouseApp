//
//  AllInfoViewController.m
//  RentHouseProject
//
//  Created by conandi on 16/7/23.
//  Copyright © 2016年 Chenyang. All rights reserved.
//

#import "AllInfoViewController.h"
#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"
#import "SellerAllPropertyViewController.h"
#import "AddNewPropertyViewController.h"
#import "SellPropertyTableViewCell.h"
#import "AllInfoListViewController.h"
static NSString *const menuCellIdentifier = @"rotationCell";

@interface AllInfoViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
YALContextMenuTableViewDelegate
>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)menuBtn_Tapped:(UIBarButtonItem *)sender;
- (IBAction)signoutBtn_Tapped:(UIBarButtonItem *)sender;
@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;
@property (strong, nonatomic) NSArray *resultArray;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longtitude;
@property(strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation AllInfoViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiateMenuOptions];
    [self prepareMapView];
    // set custom navigationBar with a bigger height
}

-(void) prepareMapView{
        [self.mapView setShowsUserLocation:YES];
        [self.mapView setZoomEnabled:YES];
        [self.mapView setMapType:MKMapTypeStandard];
        
        _locationManager = [[CLLocationManager alloc]init];
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contextMenuTableView updateAlongsideRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}

#pragma mark - IBAction

- (IBAction)menuBtn_Tapped:(UIBarButtonItem *)sender {
    // init YALContextMenuTableView tableView
    if (!self.contextMenuTableView) {
        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        self.contextMenuTableView.animationDuration = 0.15;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;
        //optional - implement menu items layout
        self.contextMenuTableView.menuItemsSide = Right;
        self.contextMenuTableView.menuItemsAppearanceDirection = FromTopToBottom;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }
    
    // it is better to use this method only for proper animation
    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
    [self.contextMenuTableView reloadData];
}

- (IBAction)signoutBtn_Tapped:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Local methods

- (void)initiateMenuOptions {
    self.menuTitles = @[@"Close",
                        @"My Properties",
                        @"Add new",
                        @"All properties",];
    
    self.menuIcons = @[[UIImage imageNamed:@"Icnclose"],
                       [UIImage imageNamed:@"myself"],
                       [UIImage imageNamed:@"BtnAdd"],
                       [UIImage imageNamed:@"allList"]];
}


#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Menu dismissed with indexpath of the row = %ld", (long)indexPath.row);
    
}

#pragma mark - YALContextMenuTableView UITableViewDataSource, UITableViewDelegate

- (CGFloat)tableView:(YALContextMenuTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(YALContextMenuTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
        NSLog(@"%@",cell.reuseIdentifier);
        if (cell) {
            cell.backgroundColor = [UIColor clearColor];
            cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
            NSLog(@"%@",cell.menuTitleLabel.text);
            cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
        }
        
        return cell;
    
}

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            [tableView dismisWithIndexPath:indexPath];
            break;
        }
        case 1:{
            SellerAllPropertyViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SellerAllPropertyViewController"];
            [self presentViewController:controller animated:YES completion:nil];
        }
        case 2:{
            AddNewPropertyViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewPropertyViewController"];
            [self presentViewController:controller animated:YES completion:nil];
        }
        case 3:{
            AllInfoListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AllInfoListViewController"];
            [self presentViewController:controller animated:YES completion:nil];
        }
        default:
            break;
    }
//    [tableView dismisWithIndexPath:indexPath];
}


@end