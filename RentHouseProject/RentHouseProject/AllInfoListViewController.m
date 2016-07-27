//
//  AllInfoListViewController.m
//  RentHouseProject
//
//  Created by conandi on 16/7/24.
//  Copyright © 2016年 Chenyang. All rights reserved.
//

#import "AllInfoListViewController.h"
#import "SellPropertyTableViewCell.h"
#import "AllListDetailViewController.h"
#import "MBProgressHUD.h"

@interface AllInfoListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtn_Tapped:(UIBarButtonItem *)sender;
@property (strong, nonatomic) NSArray *resultArray;
@end

@implementation AllInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self callAllListPropertyAPI];
    [self prepareData];
    // Do any additional setup after loading the view.
}

-(void)callAllListPropertyAPI{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.rjtmobile.com/realestate/getproperty.php?psearch&pname=&pptype=&ploc=&pcatid="]];
    NSLog(@"%@",url);
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",error);
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            _resultArray = [NSMutableArray arrayWithArray:json];
            //_saveArray = [[NSArray alloc]initWithArray:_resultArray];
            NSLog(@"%@",_resultArray);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
    }]resume];
    
}

-(void) prepareData{
    
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

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SellPropertyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellPropertyTableViewCell"];
    NSString *str =[[_resultArray objectAtIndex:indexPath.row]valueForKey:@"Property Image 1"];
    NSLog(@"%@",str);
    if ([str length]) {
        NSString *imageStr = [str stringByReplacingOccurrencesOfString:@"\\"withString:@"/"];
        NSString *imageString = [imageStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        cell.propertyImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",imageString]]]];
    }else{
        cell.propertyImageView.image = [UIImage imageNamed:@"house"];
    }
    cell.propertyName.text = [NSString stringWithFormat:@"Name: %@",[[_resultArray objectAtIndex:indexPath.row] valueForKey:@"Property Name"]];
    cell.propertyType.text = [NSString stringWithFormat:@"Type: %@",[[_resultArray objectAtIndex:indexPath.row] valueForKey:@"Property Type"]];
    cell.propertyCost.text = [NSString stringWithFormat:@"Cost: $%@",[[_resultArray objectAtIndex:indexPath.row] valueForKey:@"Property Cost"]];
    cell.propertyAddress1.text = [NSString stringWithFormat:@"Address: %@ %@",[[_resultArray objectAtIndex:indexPath.row] valueForKey:@"Property Address1"],[[_resultArray objectAtIndex:indexPath.row] valueForKey:@"Property Address2"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AllListDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AllListDetailViewController"];
    [controller setPassDict:[_resultArray objectAtIndex:indexPath.row]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)backBtn_Tapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
