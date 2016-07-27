//
//  AddNewPropertyViewController.m
//  RentHouseProject
//
//  Created by conandi on 16/7/21.
//  Copyright © 2016年 Chenyang. All rights reserved.
//

#import "AddNewPropertyViewController.h"
#import "MapViewController2.h"
@interface AddNewPropertyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *propertyNameText;
@property (weak, nonatomic) IBOutlet UIButton *plotBtn;
@property (weak, nonatomic) IBOutlet UIButton *flatBtn;
@property (weak, nonatomic) IBOutlet UIButton *houseBtn;
@property (weak, nonatomic) IBOutlet UIButton *officeBtn;
@property (weak, nonatomic) IBOutlet UIButton *villaBtn;
@property (weak, nonatomic) IBOutlet UIButton *saleBtn;
@property (weak, nonatomic) IBOutlet UIButton *rentBtn;
@property (weak, nonatomic) IBOutlet UITextField *address1;
@property (weak, nonatomic) IBOutlet UITextField *address2;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeText;
@property (weak, nonatomic) IBOutlet UITextField *LatitudeText;
@property (weak, nonatomic) IBOutlet UITextField *LongitudeText;
@property (weak, nonatomic) IBOutlet UITextField *costText;
@property (weak, nonatomic) IBOutlet UITextField *sizeText;
@property (weak, nonatomic) IBOutlet UITextView *Description;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage1;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage2;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage3;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *uploadBtn;

- (IBAction)plotBtn_Tapped:(UIButton *)sender;
- (IBAction)flatBtn_Tapped:(UIButton *)sender;
- (IBAction)houseBtn_Tapped:(UIButton *)sender;
- (IBAction)officeBtn_Tapped:(UIButton *)sender;
- (IBAction)villaBtn_Tapped:(UIButton *)sender;
- (IBAction)saleBtn_Tapped:(UIButton *)sender;
- (IBAction)rentBtn_Tapped:(UIButton *)sender;
- (IBAction)findInMapBtn_Tapped:(UIButton *)sender;
- (IBAction)addPhotoBtn_Tapped:(UIButton *)sender;
- (IBAction)backBtn_Tapped:(UIBarButtonItem *)sender;
- (IBAction)UploadBtn_Tapped:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *propertyType;
@property (strong, nonatomic) NSString *propertyCategory;
@property (strong, nonatomic) NSString *propertyID;
@end

@implementation AddNewPropertyViewController
@synthesize passArray = _passArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserID];
    if (_passArray) {
        [self prepareView];
    }
    // Do any additional setup after loading the view.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)getUserID{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault valueForKey:@"kuserid"] length]){
        _userID = [userDefault valueForKey:@"kuserid"];
    }else{
        [self showAlertwithText:@"cannot get userID"];
    }
}

-(void)prepareView{
    _uploadBtn.title = @"Update";
    _propertyNameText.text = [_passArray valueForKey:@"Property Name"];
    _address1.text = [_passArray valueForKey:@"Property Address1"];
    _address2.text = [_passArray valueForKey:@"Property Address2"];
    _zipCodeText.text = [_passArray valueForKey:@"Property Zip"];
    _LatitudeText.text = [NSString stringWithFormat:@"%@",[_passArray valueForKey:@"Property Latitude"]];
    _LongitudeText.text = [NSString stringWithFormat:@"%@",[_passArray valueForKey:@"Property Longitude"]];
    _costText.text = [_passArray valueForKey:@"Property Cost"];
    _sizeText.text = [_passArray valueForKey:@"Property Size"];
    _Description.text = [_passArray valueForKey:@"Property Desc"];
    _propertyID = [_passArray valueForKey:@"Property Id"];
    if ([[_passArray valueForKey:@"Property Type"]  isEqual: @"Plot"] || [[_passArray valueForKey:@"Property Type"]  isEqual: @"plot"]) {
        [_plotBtn setSelected:YES];
        _propertyType = @"plot";
    }else if ([[_passArray valueForKey:@"Property Type"]  isEqual: @"Flat"] || [[_passArray valueForKey:@"Property Type"]  isEqual: @"flat"]) {
        [_flatBtn setSelected:YES];
        _propertyType = @"flat";
    }else if ([[_passArray valueForKey:@"Property Type"]  isEqual: @"House"] || [[_passArray valueForKey:@"Property Type"]  isEqual: @"house"]) {
        [_houseBtn setSelected:YES];
        _propertyType = @"house";
    }else if ([[_passArray valueForKey:@"Property Type"]  isEqual: @"Office"] || [[_passArray valueForKey:@"Property Type"]  isEqual: @"office"]) {
        [_officeBtn setSelected:YES];
        _propertyType = @"office";
    }else if ([[_passArray valueForKey:@"Property Type"]  isEqual: @"Villa"] || [[_passArray valueForKey:@"Property Type"]  isEqual: @"villa"]) {
        [_villaBtn setSelected:YES];
        _propertyType = @"villa";
    }
    
    if ([[_passArray valueForKey:@"Property Category"] isEqualToString:@"1"]) {
        [_saleBtn setSelected:YES];
        _propertyCategory = @"1";
    }else if([[_passArray valueForKey:@"Property Category"] isEqualToString:@"2"]){
        [_rentBtn setSelected:YES];
        _propertyCategory = @"2";
    }
    
    NSString *str1 =[_passArray valueForKey:@"Property Image 1"];
    NSLog(@"%@",str1);
    if ([str1 length]) {
        NSString *imageStr = [str1 stringByReplacingOccurrencesOfString:@"\\"withString:@"/"];
        NSString *imageString = [imageStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        _photoImage1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",imageString]]]];
    }else{
        _photoImage1.image = [UIImage imageNamed:@"house"];
    }
    
    NSString *str2 =[_passArray valueForKey:@"Property Image 2"];
    NSLog(@"%@",str2);
    if ([str2 length]) {
        NSString *imageStr = [str2 stringByReplacingOccurrencesOfString:@"\\"withString:@"/"];
        NSString *imageString = [imageStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        _photoImage2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",imageString]]]];
    }else{
        _photoImage2.image = [UIImage imageNamed:@"house"];
    }
    
    NSString *str3 =[_passArray valueForKey:@"Property Image 3"];
    NSLog(@"%@",str3);
    if ([str3 length]) {
        NSString *imageStr = [str3 stringByReplacingOccurrencesOfString:@"\\"withString:@"/"];
        NSString *imageString = [imageStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        _photoImage3.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",imageString]]]];
    }else{
        _photoImage3.image = [UIImage imageNamed:@"house"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

-(void)callUploadAndUpdateAPI{
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self getNSURLRequest] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",error);
        if (!error) {
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",data);
            NSLog(@"%@",str);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([str isEqualToString:@"bool(true)\n"]) {
                    //[self showAlertwithText:@"Register Successfully!"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self showAlertwithText:@"Upload fail, Please try later"];
                }
            });
            
        }
    }]resume];
}

-(NSURLRequest *)getNSURLRequest{
    NSURL* requestURL;
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[NSString stringWithFormat:@"%@",_propertyNameText.text] forKey:@"propertyname"];
    [_params setObject:[NSString stringWithFormat:@"%@",_propertyType] forKey:@"propertytype"];
    [_params setObject:[NSString stringWithFormat:@"%@",_propertyCategory] forKey:@"propertycat"];
    [_params setObject:[NSString stringWithFormat:@"%@",_address1.text] forKey:@"propertyaddress1"];
    [_params setObject:[NSString stringWithFormat:@"%@",_address2.text] forKey:@"propertyaddress2"];
    [_params setObject:[NSString stringWithFormat:@"%@",_zipCodeText.text] forKey:@"propertyzip"];
    [_params setObject:[NSString stringWithFormat:@"%@",_costText.text] forKey:@"propertycost"];
    [_params setObject:[NSString stringWithFormat:@"%@",_LatitudeText.text] forKey:@"propertylat"];
    [_params setObject:[NSString stringWithFormat:@"%@",_LongitudeText.text] forKey:@"propertylong"];
    [_params setObject:[NSString stringWithFormat:@"%@",_sizeText.text] forKey:@"propertysize"];
    [_params setObject:[NSString stringWithFormat:@"%@",_Description.text] forKey:@"propertydesc"];
    [_params setObject:[NSString stringWithFormat:@"yes"] forKey:@"userstatus"];
    [_params setObject:[NSString stringWithFormat:@"%@",_userID] forKey:@"userid"];
    NSLog(@"%@",_params);
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant1 = @"propertyimg1";
    NSString* FileParamConstant2 = @"propertyimg2";
    NSString* FileParamConstant3 = @"propertyimg3";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    if (_passArray) {
        requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.rjtmobile.com/realestate/register.php?property&edit&pptyid=%@",_propertyID]];
    }else{
        requestURL = [NSURL URLWithString:@"http://www.rjtmobile.com/realestate/register.php?property&add"];
    }
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
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data1
    NSData *imageData1 = UIImageJPEGRepresentation(_photoImage1.image, 1.0);
    if (imageData1) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@1.jpg\"\r\n", FileParamConstant1,_propertyNameText.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData1];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    // add image data2
    NSData *imageData2 = UIImageJPEGRepresentation(_photoImage2.image, 1.0);
    if (imageData2) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@2.jpg\"\r\n", FileParamConstant2,_propertyNameText.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData2];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    // add image data3
    NSData *imageData3 = UIImageJPEGRepresentation(_photoImage3.image, 1.0);
    if (imageData3) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@3.jpg\"\r\n", FileParamConstant3,_propertyNameText.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData3];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - textField and textView

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if(textView == _Description)
    {
        [self animatedTextFieldMove:textView UP:YES];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if(textView == _Description)
    {
        [self animatedTextFieldMove:textView UP:NO];
    }

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}// return NO to disallow editing.

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}// return NO to not change text

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}// called when 'return' key pressed. return NO to ignore.

-(void) animatedTextFieldMove:(UITextView *)textView UP:(BOOL)up{
    
    const int movementDistance = 50;
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance:movementDistance);
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.propertyNameText resignFirstResponder];
    [self.address1 resignFirstResponder];
    [self.address2 resignFirstResponder];
    [self.zipCodeText resignFirstResponder];
    [self.LatitudeText resignFirstResponder];
    [self.LongitudeText resignFirstResponder];
    [self.costText resignFirstResponder];
    [self.sizeText resignFirstResponder];
    [self.Description resignFirstResponder];
}


#pragma mark - Button

- (IBAction)plotBtn_Tapped:(UIButton *)sender {
    _plotBtn = sender;
    _plotBtn.selected = !_plotBtn.selected;
    _propertyType = nil;
    _propertyType = @"plot";
    [_flatBtn setSelected:NO];
    [_houseBtn setSelected:NO];
    [_officeBtn setSelected:NO];
    [_villaBtn setSelected:NO];
}

- (IBAction)flatBtn_Tapped:(UIButton *)sender {
    _flatBtn = sender;
    _flatBtn.selected = !_flatBtn.selected;
    _propertyType = nil;
    _propertyType = @"flat";
    [_plotBtn setSelected:NO];
    [_houseBtn setSelected:NO];
    [_officeBtn setSelected:NO];
    [_villaBtn setSelected:NO];
}

- (IBAction)houseBtn_Tapped:(UIButton *)sender {
    _houseBtn = sender;
    _houseBtn.selected = !_houseBtn.selected;
    _propertyType = nil;
    _propertyType = @"house";
    [_plotBtn setSelected:NO];
    [_flatBtn setSelected:NO];
    [_officeBtn setSelected:NO];
    [_villaBtn setSelected:NO];
}

- (IBAction)officeBtn_Tapped:(UIButton *)sender {
    _officeBtn = sender;
    _officeBtn.selected = !_officeBtn.selected;
    _propertyType = nil;
    _propertyType = @"office";
    [_plotBtn setSelected:NO];
    [_flatBtn setSelected:NO];
    [_houseBtn setSelected:NO];
    [_villaBtn setSelected:NO];
}

- (IBAction)villaBtn_Tapped:(UIButton *)sender {
    _villaBtn = sender;
    _villaBtn.selected = !_villaBtn.selected;
    _propertyType = nil;
    _propertyType = @"villa";
    [_plotBtn setSelected:NO];
    [_flatBtn setSelected:NO];
    [_houseBtn setSelected:NO];
    [_officeBtn setSelected:NO];
}

- (IBAction)saleBtn_Tapped:(UIButton *)sender {
    _saleBtn = sender;
    _saleBtn.selected = !_saleBtn.selected;
    _propertyCategory = nil;
    _propertyCategory = @"1";
    [_rentBtn  setSelected:NO];
}

- (IBAction)rentBtn_Tapped:(UIButton *)sender {
    _rentBtn = sender;
    _rentBtn.selected = !_rentBtn.selected;
    _propertyCategory = nil;
    _propertyCategory = @"2";
    [_saleBtn setSelected:NO];
}

- (IBAction)findInMapBtn_Tapped:(UIButton *)sender {
    MapViewController2 *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController2"];
    [controller setMyUpdateCoordinate:self];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)backBtn_Tapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)UploadBtn_Tapped:(UIBarButtonItem *)sender {
    if ([self checkValidation]) {
        [self callUploadAndUpdateAPI];
    }else{
        [self showAlertwithText:@"All infomation are required."];
    }
}

-(BOOL)checkValidation{
    if ([_propertyNameText.text length] && [_propertyType length] && [_propertyCategory length] && [_address1.text length] && [_address2.text length] && [_zipCodeText.text length] && [_LatitudeText.text length] && [_LongitudeText.text length] && [_costText.text length] && [_sizeText.text length] && [_Description.text length]) {
        return YES;
    }else{
        return NO;
    }
}

-(void) updateTextCoordinate:(NSString *)latiutude withLongtitude:(NSString *)longtitude{
    _LatitudeText.text = latiutude;
    _LongitudeText.text = longtitude;
}

-(void) showAlertwithText:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - mutiplePhotoPicker

- (IBAction)addPhotoBtn_Tapped:(UIButton *)sender {
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    //elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
            }
    }
    if ([images count]>0) {
        _photoImage1.image = [images objectAtIndex:0];
    }
    if ([images count]>1) {
        _photoImage2.image = [images objectAtIndex:1];
    }
    if ([images count]>2) {
        _photoImage3.image = [images objectAtIndex:2];
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
