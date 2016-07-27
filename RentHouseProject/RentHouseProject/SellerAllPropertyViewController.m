//
//  SellerAllPropertyViewController.m
//  RentHouseProject
//
//  Created by conandi on 16/7/21.
//  Copyright © 2016年 Chenyang. All rights reserved.
//

#import "SellerAllPropertyViewController.h"
#import "SellPropertyTableViewCell.h"
#import "AddNewPropertyViewController.h"
#import "MBProgressHUD.h"

@interface SellerAllPropertyViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addBtn_Tapped:(UIBarButtonItem *)sender;
- (IBAction)backBtn_Tapped:(UIBarButtonItem *)sender;


@property (strong, nonatomic) NSMutableArray *resultArray;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSArray *actionArray;
@end

@implementation SellerAllPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    [self prepareData];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareData{
    [self getUserID];
    [self callAllPropertyAPI];
}

-(void)getUserID{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault valueForKey:@"kuserid"] length]){
        _userID = [userDefault valueForKey:@"kuserid"];
    }else{
        [self showAlertwithText:@"cannot get userID"];
    }
}

-(void)callAllPropertyAPI{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.rjtmobile.com/realestate/getproperty.php?all&userid=%@",_userID]];
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
    AddNewPropertyViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewPropertyViewController"];
    [controller setPassArray:[_resultArray objectAtIndex:indexPath.row]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED{
    
    UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"share" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSArray *arrResult = @[[NSString stringWithFormat:@"Name: %@",[[_resultArray objectAtIndex:indexPath.row] valueForKey:@"Property Name"]], [NSString stringWithFormat:@"Type: %@",[[_resultArray objectAtIndex:indexPath.row] valueForKey:@"Property Type"]], [NSString stringWithFormat:@"Cost: %@",[[_resultArray objectAtIndex:indexPath.row] valueForKey:@"Property Cost"]], [NSString stringWithFormat:@"Address: %@ %@",[[_resultArray objectAtIndex:indexPath.row] valueForKey:@"Property Address1"],[[_resultArray objectAtIndex:indexPath.row] valueForKey:@"Property Address2"]]];
        
        UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:arrResult applicationActivities:nil];
        NSArray *array = @[UIActivityTypePrint, UIActivityTypeOpenInIBooks,UIActivityTypePostToWeibo];
        activity.excludedActivityTypes = array;
        [self presentViewController:activity animated:YES completion:nil];
    }];
    shareAction.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self callDeleteAPIWithIndexPath:indexPath];
        [_resultArray  removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    _actionArray = [[NSArray alloc]initWithObjects:deleteAction, shareAction, nil];
    return _actionArray;
}

-(void)callDeleteAPIWithIndexPath:(NSIndexPath *)indexPath{
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self getNSURLRequestWithIndexPath:indexPath] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([str isEqualToString:@"bool(true)\n"]) {
                    [self showAlertwithText:@"Register Successfully!"];
                    [self callAllPropertyAPI];
                    //[self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self showAlertwithText:@"Register fail, Please try later"];
                }
            });
            
        }
    }]resume];
}

-(NSURLRequest *)getNSURLRequestWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",[_resultArray objectAtIndex:indexPath.row]);
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.rjtmobile.com/realestate/register.php?property&delete&pptyid=%@",[[_resultArray objectAtIndex:indexPath.row] valueForKey:@"Property Id"]]];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    // add image data
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    return request;
    
}


#pragma mark - button

- (IBAction)addBtn_Tapped:(UIBarButtonItem *)sender {
    AddNewPropertyViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewPropertyViewController"];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)backBtn_Tapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) showAlertwithText:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
