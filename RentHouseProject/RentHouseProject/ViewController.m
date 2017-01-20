//
//  ViewController.m
//  RentHouseProject
//
//  Created by Chenyang on 7/20/16.
//  Copyright © 2016 Chenyang. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "SellerAllPropertyViewController.h"
#import "AllInfoViewController.h"
#import "BuyerMainViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIImageView *loginBackGroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *LoginTitleImage;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) NSString *userType;
@property (weak, nonatomic) IBOutlet UIButton *sellerBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyerBtn;
@property (weak, nonatomic) IBOutlet UIButton *rememberMeBtn;

- (IBAction)sellerBtn_Tapped:(UIButton *)sender;
- (IBAction)buyerBtn_Tapped:(UIButton *)sender;
- (IBAction)rememberMeBtn_Tapped:(UIButton *)sender;
- (IBAction)signInBtn_Tapped:(UIButton *)sender;
- (IBAction)registerBtn_Tapped:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault valueForKey:@"kemail"] length]&&[[userDefault valueForKey:@"kpass"] length]){
        _emailText.text = [userDefault valueForKey:@"kemail"];
        _passwordText.text = [userDefault valueForKey:@"kpass"];
    }
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"hello");
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

-(void)prepareView{
    [UIView animateWithDuration:0.5 animations:^{
        _subView.frame = CGRectMake(_subView.frame.origin.x, 30, _subView.frame.size.width, _subView.frame.size.height);
        _backGroundView.frame = CGRectMake(_backGroundView.frame.origin.x, 30, _backGroundView.frame.size.width, _backGroundView.frame.size.height);
        _LoginTitleImage.frame = CGRectMake(_LoginTitleImage.frame.origin.x, 30, _LoginTitleImage.frame.size.width, _LoginTitleImage.frame.size.height);
    }completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)callSignInAPI{
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self getNSURLRequest] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",json);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([json count]) {
                    //[self showAlertwithText:@"Login Successfully!"];
                    if ([_buyerBtn isSelected]) {
                        //                        NSUserDefaults*defaults = [NSUserDefaults standardUserDefaults];
                        NSString *uid = [[json objectAtIndex:0] valueForKey:@"User Id"];
                        NSString *temp = [NSString stringWithFormat:@"%@",uid];
                        //                        [defaults setValue:temp forKey:@"kuserid"];
                        [[NSUserDefaults standardUserDefaults]setObject:temp forKey:@"kuserid"];
                        NSLog(@"!!!!!!!!!!%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"kuserid"]);
                        NSLog(@"%@",[json valueForKey:@"User Id"]);
                    }
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setObject:[[json objectAtIndex:0] valueForKey:@"User Id"] forKey:@"kuserid"];
                    [userDefault setObject:[[json objectAtIndex:0] valueForKey:@"User Type"] forKey:@"kusertype"];
                    [userDefault synchronize];
                    
                    if ([_userType isEqual: @"buyer"]) {
                        BuyerMainViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyerMainViewController"];
                        [self.navigationController pushViewController:controller animated:YES];
                    }else{
                        AllInfoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AllInfoViewController"];
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                }else{
                    [self showAlertwithText:@"Login fail, Please try later"];
                }
            });
            
        }
    }]resume];
}

-(NSURLRequest *)getNSURLRequest{
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[NSString stringWithFormat:@"%@",_emailText.text] forKey:@"email"];
    [_params setObject:[NSString stringWithFormat:@"%@", _passwordText.text] forKey:@"password"];
    [_params setObject:[NSString stringWithFormat:@"%@", _userType] forKey:@"usertype"];
    NSLog(@"%@",_params);
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:@"http://rjtmobile.com/realestate/register.php?login"];
    
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
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        NSLog(@"%@",param);
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
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

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.emailText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}


#pragma mark - Button

- (IBAction)sellerBtn_Tapped:(UIButton *)sender {
    _sellerBtn = sender;
    _sellerBtn.selected = !_sellerBtn.selected;
    _userType = nil;
    _userType = @"seller";
    [_buyerBtn setSelected:NO];
}

- (IBAction)buyerBtn_Tapped:(UIButton *)sender {
    _buyerBtn = sender;
    _buyerBtn.selected = !_buyerBtn.selected;
    _userType = nil;
    _userType = @"buyer";
    [_sellerBtn setSelected:NO];
}

- (IBAction)rememberMeBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:_emailText.text forKey:@"kemail"];
        [userDefault setObject:_passwordText.text forKey:@"kpass"];
        [userDefault synchronize];
    }else{
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"" forKey:@"kemail"];
        [userDefault setObject:@"" forKey:@"kpass"];
        [userDefault synchronize];
    }
}

- (IBAction)signInBtn_Tapped:(UIButton *)sender {
    if([self checkValidation]){
        [self callSignInAPI];
    }else{
        [self showAlertwithText:@"Cannot Sign in"];
    }
    
}

-(BOOL)checkValidation{
    if(_emailText.text && _passwordText.text && _userType){
        return YES;
    }
    else{
        return NO;
    }
}

- (IBAction)registerBtn_Tapped:(UIButton *)sender {
    RegisterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self presentViewController:controller animated:YES completion:nil];
}

-(void) showAlertwithText:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
