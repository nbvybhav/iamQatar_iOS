//
//  ProfileViewController.m
//  IamQatar
//
//  Created by alisons on 9/7/16.
//  Copyright © 2016 alisons. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "IamQatar-Swift.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define patternForEmail @"^(\\w[.]?)*\\w+[@](\\w[.]?)*\\w+[.][a-z]{2,4}$"

NSString *jumpToHome = @"";


@interface ProfileViewController ()
{
    AppDelegate *profileAppDelegate;
}
@end

@implementation ProfileViewController
{
    Menu *menu;
    UITapGestureRecognizer * menuHideTap;
    BOOL isSelected;
    int deviceHieght;
    UIImage         *cameraPhoto,*galleryImage;
    NSString        *cameraString;
    BOOL            reloadNeeded;
}


//MARK:- VIEW DIDLOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    self.title = @"PROFILE";

    for(UITabBarItem * tabBarItem in self.tabBarController.tabBar.items){
        tabBarItem.title = @"";
        //tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
    
    profileAppDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    deviceHieght = [[UIScreen mainScreen] bounds].size.height;

    //--------setting menu frame---------//
    isSelected = NO;
    menu= [[Menu alloc]init];
    NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"Menu" owner:self options:nil];
    menu = [nib1 objectAtIndex:0];
    menu.frame=CGRectMake(-290, 0, 275,deviceHieght);
    menu.delegate = self;
    [self.tabBarController.view addSubview:menu];
    menuHideTap.enabled = NO;
        [menu setHidden:YES];

    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];

    menuHideTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    [self.view addGestureRecognizer:menuHideTap];
    menuHideTap.enabled = NO;

    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];

    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];

    cameraString = @"";
    
    _saveBtnOutlet.enabled = NO;
    _editBtnOutlet.enabled = YES;
    reloadNeeded = YES;

    //Tab bar tintcolor
    self.tabBarController.tabBar.tintColor = [UIColor lightGrayColor];
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor lightGrayColor];

    //Banner shadow & corner radius
    //_bannerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //_bannerView.layer.shadowRadius = 4.0f;
    //_bannerView.layer.shadowOffset = CGSizeZero;
    //_bannerView.layer.shadowOpacity = 0.8f;
    //_bannerView.clipsToBounds = false;
//
//    _bannerImage.clipsToBounds = true;
//    _bannerImage.layer.cornerRadius = 10;
    
    
    _bannerViewHeightConstraint.constant = self.view.frame.size.width / 1.7;
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *hideKeyBoard =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(hideKeyBoard:)];
    [self.mainCotentView addGestureRecognizer:hideKeyBoard];
}


//The event handling method
- (void)hideKeyBoard:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
    
}

-(void)viewDidLayoutSubviews{

    _profileNameTF.layer.masksToBounds = false;
    _profileNameTF.layer.shadowRadius = 3.0;
    _profileNameTF.layer.shadowColor = [[UIColor blackColor] CGColor];
    _profileNameTF.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _profileNameTF.layer.shadowOpacity = 0.5;

    _profileEmailTF.layer.masksToBounds = false;
    _profileEmailTF.layer.shadowRadius = 3.0;
    _profileEmailTF.layer.shadowColor = [[UIColor blackColor] CGColor];
    _profileEmailTF.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _profileEmailTF.layer.shadowOpacity = 0.5;

    _profilePhoneTF.layer.masksToBounds = false;
    _profilePhoneTF.layer.shadowRadius = 3.0;
    _profilePhoneTF.layer.shadowColor = [[UIColor blackColor] CGColor];
    _profilePhoneTF.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _profilePhoneTF.layer.shadowOpacity = 0.5;


    //imageView corner radius
    _profileUserImgView.layer.cornerRadius = _profileUserImgView.frame.size.width/2;
    _profileUserImgView.backgroundColor    = [UIColor whiteColor];
    _profileUserImgView.clipsToBounds      = YES;
    _profileUserImgView.layer.borderColor  = [[UIColor orangeColor] CGColor];
    _profileUserImgView.layer.borderWidth  = 2.0;

    //[self.view insertSubview:_profileUserName belowSubview:menu];
    //[self.view addSubview:_profileUserMailID];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:true];
    _profileNameTF.borderStyle  = UITextBorderStyleRoundedRect;
    _profileEmailTF.borderStyle = UITextBorderStyleRoundedRect;
    _profilePhoneTF.borderStyle = UITextBorderStyleRoundedRect;

    //Jump to Home tab
    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

    if([plistVal isEqualToString:@"YES"]||[jumpToHome isEqualToString:@"YES"]){
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    }

    [menu.btnLogout setTitle:@"Log Out" forState:UIControlStateNormal];
    //    NSString *plistVal = [[NSString alloc]init];
    //    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];
    //    if([plistVal isEqualToString:@"YES"]){
    //        [menu.btnLogout setTitle:@"Log In" forState:UIControlStateNormal];
    //    }else{
    //        [menu.btnLogout setTitle:@"Log Out" forState:UIControlStateNormal];
    //    }

    //Google Analytics tracker
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Profile"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    ////-----showing tabar item at index 2 (back button)-------//
    //KOLA[[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:YES] ;
    self.tabBarController.delegate = self;

    if(reloadNeeded)
    { [self setUpProfileDetails];}
}

-(void)viewDidDisappear:(BOOL)animated
{
    menuHideTap.enabled = NO;
        [menu setHidden:YES];
    isSelected = NO;
    menu.frame=CGRectMake(-290, 0, 275, deviceHieght);
    [[[self.tabBarController.tabBar subviews]objectAtIndex:4]setHidden:FALSE] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
//    menuHideTap.enabled = NO;
        [menu setHidden:YES];
//    isSelected = NO;
//    menu.frame=CGRectMake(0, 625, 275, 335);
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    [self.mainScrollView setContentOffset:CGPointMake(0, 200)];
    self.mainContentViewHeghtConstraint.constant = 800;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self.mainScrollView setContentOffset:CGPointMake(0, 200)];
    self.mainContentViewHeghtConstraint.constant = 700;
    
}

//MARK:- METHODS
// MENU SWIPE
-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->menu.frame=CGRectMake(-290, 0, 275, self->deviceHieght);
        self->isSelected = NO;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
        self->menuHideTap.enabled = NO;
        [self->menu setHidden:YES];
    }];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self->menu setHidden:NO];
        self->menuHideTap.enabled = YES;
        self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
        self->isSelected = YES;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
}

- (void)setUpProfileDetails{

    NSLog(@"email>%@",[profileAppDelegate.userProfileDetails objectForKey:@"email"]);

    NSString *name = [[NSString alloc]init];
    name = [NSString stringWithFormat:@"%@",[profileAppDelegate.userProfileDetails objectForKey:@"username"]];

    if ([name length]!=0 || ![name isEqualToString:@""])
    {
        _profileUserName.text   = [NSString stringWithFormat:@"%@",[[profileAppDelegate.userProfileDetails objectForKey:@"username"] capitalizedString]];

        _profileNameTF.text = [NSString stringWithFormat:@"%@",[[profileAppDelegate.userProfileDetails objectForKey:@"username"] capitalizedString]];
    }else{
        _profileUserName.text   = [NSString stringWithFormat:@"%@ %@",[[profileAppDelegate.userProfileDetails objectForKey:@"first_name"] capitalizedString],[[profileAppDelegate.userProfileDetails objectForKey:@"last_name"] capitalizedString]];

        _profileNameTF.text = [NSString stringWithFormat:@"%@ %@",[[profileAppDelegate.userProfileDetails objectForKey:@"first_name"] capitalizedString],[[profileAppDelegate.userProfileDetails objectForKey:@"last_name"] capitalizedString]];
    }



    _profileEmailTF.text   = [profileAppDelegate.userProfileDetails objectForKey:@"email"];
    _profilePhoneTF.text   = [profileAppDelegate.userProfileDetails objectForKey:@"phone"];
    _profileAddressTF.text = [profileAppDelegate.userProfileDetails objectForKey:@"address"];

    NSURL *imageUrl    = [NSURL URLWithString:[profileAppDelegate.userProfileDetails objectForKey:@"image"]];
    _profileUserImgView.contentMode   = UIViewContentModeScaleAspectFit;
    [_profileUserImgView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"profilePic.png"]];

    _profileAddressTF.userInteractionEnabled = NO;
    _profilePhoneTF.userInteractionEnabled   = NO;
    _profileNameTF.userInteractionEnabled    = NO;
    _profileImgPicker.userInteractionEnabled = NO;

    [_profileNameTF resignFirstResponder];
    [_profileEmailTF resignFirstResponder];
    [_profilePhoneTF resignFirstResponder];
    [_profileAddressTF resignFirstResponder];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

//MARK:- TABBAR DELEGATE
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    jumpToHome = [NSString stringWithFormat:@"NO"];

    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
    {
        if (isSelected) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->isSelected = NO;
                self->menu.frame=CGRectMake(-290, 0, 275, self->deviceHieght);
            } completion:^(BOOL finished){
                // if you want to do something once the animation finishes, put it here
                self->menuHideTap.enabled = NO;
        [self->menu setHidden:YES];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self->menu setHidden:NO];
                self->menuHideTap.enabled = YES;
                self->isSelected = YES;

                if ([[UIScreen mainScreen] bounds].size.height == 736.0){
                    self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
                }
                else if([[UIScreen mainScreen] bounds].size.height == 667.0){
                    self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
                }
                else{
                    self->menu.frame=CGRectMake(0, 0, 275, self->deviceHieght);
                }

            } completion:^(BOOL finished){
                // if you want to do something once the animation finishes, put it here

            }];
        }
        return NO;
    }else if (viewController == [self.tabBarController.viewControllers objectAtIndex:3])
    {
//        [self.navigationController popViewControllerAnimated:YES];
        //[self.tabBarController setSelectedIndex:2];
        //[Utility exitAlert:self];
         //return NO;
        //self.tabBarController.tabBar.selectedItem = [self.tabBarController.tabBar.items objectAtIndex:2];
    }
    return YES;
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    if (viewController == [self.tabBarController.viewControllers objectAtIndex:0])
//    {
//
//    }
//}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//MARK:- BUTTOB ACTION
- (IBAction)onSaveBtnClicked:(id)sender
{
  if ([Utility reachable]) {
      
      if(_profilePhoneTF.text.length ==0)
      {
           [AlertController alertWithMessage:@"Enter phone number!" presentingViewController:self];
      }else if(_profileNameTF.text.length ==0){
           [AlertController alertWithMessage:@"Enter name field!" presentingViewController:self];
      }else
      {
        [ProgressHUD show];
                    
        NSData *imageData = UIImageJPEGRepresentation(self.profileUserImgView.image, 0.5);
        NSDictionary *parameters = @{@"user_id": [profileAppDelegate.userProfileDetails objectForKey:@"user_id"],@"phone": self.profilePhoneTF.text,@"email":_profileEmailTF.text,@"first_name":_profileNameTF.text,@"image":cameraString};
        
//            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"%@"parentURL]];
        
          
//            AFHTTPRequestOperation *op = [manager POST:[NSString stringWithFormat:@"%@api.php?page=updateProfile",parentURL]parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
//          {
//                [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
//            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//                NSString *text = [responseObject objectForKey:@"text"];
//                NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//                if ([[responseObject objectForKey:@"value"] count] !=0)
//                {
//                    [AlertController alertWithMessage:@"Profile details updated!" presentingViewController:self];
//                    profileAppDelegate.userProfileDetails = [responseObject objectForKey:@"value"];
//                    [self setUpProfileDetails];
//
//
//                    _saveBtnOutlet.enabled = NO;
//                    _editBtnOutlet.enabled = YES;
//                }else
//                {
//                    [AlertController alertWithMessage:text presentingViewController:self];
//                    NSLog(@"User Doesnot Exist");
//                }
//                [ProgressHUD dismiss];
//
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@ ***** %@", operation.responseString, error);
//                [ProgressHUD dismiss];
//            }];
//            [op start];
          
          
          
//          AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//          AFHTTPRequestOperation *op = [manager POST:[NSString stringWithFormat:@"%@api.php?page=updateProfile",parentURL]parameters:parameters headers:nil progress :nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
//           {
//                 [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
//             }  success:^(NSURLSessionTask *task, id responseObject) {
//                NSString *text = [responseObject objectForKey:@"text"];
////                NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//                NSLog(@"Success: %@ ", responseObject);
//                if ([[responseObject objectForKey:@"value"] count] !=0)
//                {
//                    [AlertController alertWithMessage:@"Profile details updated!" presentingViewController:self];
//                    self->profileAppDelegate.userProfileDetails = [responseObject objectForKey:@"value"];
//                    [self setUpProfileDetails];
//
//
//                    self->_saveBtnOutlet.enabled = NO;
//                    self->_editBtnOutlet.enabled = YES;
//                }else
//                {
//                    [AlertController alertWithMessage:text presentingViewController:self];
//                    NSLog(@"User Doesnot Exist");
//                }
//                [ProgressHUD dismiss];
//
//            } failure:^(NSURLSessionTask *task, NSError *error) {
////                NSLog(@"Error: %@ ***** %@", operation.responseString, error);
//                NSLog(@"Error: %@ ", error);
//                [ProgressHUD dismiss];
//            }];
          
          
          
          
          
          NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@api.php?page=updateProfile",parentURL] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                } error:nil];

          AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

          NSURLSessionUploadTask *uploadTask;
          uploadTask = [manager
                        uploadTaskWithStreamedRequest:request
                        progress:^(NSProgress * _Nonnull uploadProgress) {
                            // This is not called back on the main queue.
                            // You are responsible for dispatching to the main queue for UI updates
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //Update the progress view
//                                [progressView setProgress:uploadProgress.fractionCompleted];
                            });
                        }
                        completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                            if (error) {
                                NSLog(@"Error: %@", error);
                            } else {
                                NSString *text = [responseObject objectForKey:@"text"];
                                if ([[responseObject objectForKey:@"value"] count] !=0)
                                {
                                    [AlertController alertWithMessage:@"Profile details updated!" presentingViewController:self];
                                    self->profileAppDelegate.userProfileDetails = [responseObject objectForKey:@"value"];
                                    [self setUpProfileDetails];
                                
                        
                                    self->_saveBtnOutlet.enabled = NO;
                                    self->_editBtnOutlet.enabled = YES;
                                }else{
                                    [AlertController alertWithMessage:text presentingViewController:self];
                                    NSLog(@"User Doesnot Exist");
                                }
                                [ProgressHUD dismiss];
                                NSLog(@"%@ %@", response, responseObject);
                            }
                        }];

          [uploadTask resume];

      }
  }else
  {
      [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
  }
}
- (IBAction)onEditBtnClicked:(id)sender {
    
    _profileAddressTF.userInteractionEnabled = YES;
    _profilePhoneTF.userInteractionEnabled   = YES;
    _profileNameTF.userInteractionEnabled    = YES;
    _profileImgPicker.userInteractionEnabled = YES;
    _saveBtnOutlet.enabled = YES;
    _editBtnOutlet.enabled = NO;
    
}

- (IBAction)onProfileImageBtnPressed:(id)sender {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Photo"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction =[UIAlertAction
                                  actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleDestructive
                                  handler:^(UIAlertAction * action)
                                  {
                                      [alertController dismissViewControllerAnimated:YES completion:nil];
                                      
                                  }];
    // UIAlertActionStyleCancel
    UIAlertAction *deleteAction = [UIAlertAction
                                   actionWithTitle:@"Take Photo"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       
                                       if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                       {
//                                           UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                                                                 message:@"Device has no camera"
//                                                                                                delegate:nil
//                                                                                       cancelButtonTitle:@"OK"
//                                                                                       otherButtonTitles: nil];
//                                           [myAlertView show];
                                           UIAlertController * alert = [UIAlertController
                                                           alertControllerWithTitle:@"Error"
                                                                            message:@"Device has no camera"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                           UIAlertAction* ok = [UIAlertAction
                                                               actionWithTitle:@"OK"
                                                                         style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction * action) {
                                                                           //Handle your yes please button action here
                                                                       }];
                                           [alert addAction:ok];
                                           [self presentViewController:alert animated:YES completion:nil];
                                       }
                                       else
                                       {
                                           UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                           picker.delegate = self;
                                           picker.allowsEditing = YES;
                                           picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                           
                                           [self presentViewController:picker animated:YES completion:NULL];
                                       }
                                       
                                   }];
    // UIAlertActionStyleDestructive
    UIAlertAction *archiveAction = [UIAlertAction
                                    actionWithTitle:@"From Gallery"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                        picker.delegate = self;
                                        picker.allowsEditing = YES;
                                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                        
                                        [self presentViewController:picker animated:YES completion:NULL];
                                        
                                    }];
    // UIAlertActionStyleDefault
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [alertController addAction:cancelAction];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = sender;
        UIButton *btn=(UIButton *)sender;
        popover.sourceRect = btn.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma mark - Image Picker Controller delegate methods

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary  *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    // Edited image works great (if you allowed editing)
        
//        // AND the original image works great
//        _profileUserImgView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        // AND do whatever you want with it, (NSDictionary *)info is fine now
//        _profileUserImgView.image = [info objectForKey:UIImagePickerControllerEditedImage];
   
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:(NSString*)kUTTypeImage])
    {
        UIImage *photoTaken = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        self->_profileUserImgView.image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSData *webData = UIImagePNGRepresentation(photoTaken);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:@"JPG"];
        
        self->cameraPhoto  = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        self->cameraString = [UIImagePNGRepresentation(self->cameraPhoto) base64EncodedStringWithOptions:0];
        
        [webData writeToFile:localFilePath atomically:YES];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
  }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
//    UIAlertView *alert;
    if (error) {
//        alert = [[UIAlertView alloc] initWithTitle:@"Error!"
//                                           message:[error localizedDescription]
//                                          delegate:nil
//                                 cancelButtonTitle:@"OK"
//                                 otherButtonTitles:nil];
//        [alert show];
        UIAlertController * alert = [UIAlertController
                        alertControllerWithTitle:@"Error!"
                                         message:[error localizedDescription]
                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                            actionWithTitle:@"OK"
                                      style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)onProfileSelectionBtnCliCked:(id)sender {
    
    reloadNeeded = NO;
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Photo"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction =[UIAlertAction
                                  actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleDestructive
                                  handler:^(UIAlertAction * action)
                                  {
                                      [alertController dismissViewControllerAnimated:YES completion:nil];
                                  }];  // UIAlertActionStyleCancel
    UIAlertAction *deleteAction = [UIAlertAction
                                   actionWithTitle:@"Take Photo"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                       {
                                           
//                                           UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera"delegate:nil cancelButtonTitle:@"OK"otherButtonTitles: nil];
//                                           [myAlertView show];
                                           UIAlertController * alert = [UIAlertController
                                                           alertControllerWithTitle:@"Error"
                                                                            message:@"Device has no camera"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                           UIAlertAction* ok = [UIAlertAction
                                                               actionWithTitle:@"OK"
                                                                         style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction * action) {
                                                                           //Handle your yes please button action here
                                                                       }];
                                           [alert addAction:ok];
                                           [self presentViewController:alert animated:YES completion:nil];
                                       }
                                       else
                                       {
                                           UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                           picker.delegate = self;
                                           picker.allowsEditing = YES;
                                           picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                           
                                           [self presentViewController:picker animated:YES completion:NULL];
                                           //                                           newMedia = YES;
                                       }
                                       
                                   }];  // UIAlertActionStyleDestructive
    UIAlertAction *archiveAction = [UIAlertAction
                                    actionWithTitle:@" From Gallery"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                        picker.delegate = self;
                                        picker.allowsEditing = YES;
                                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                        [self presentViewController:picker animated:YES completion:NULL];
                                    }];// UIAlertActionStyleDefault
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [alertController addAction:cancelAction];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = sender;
        UIButton *btn=(UIButton *)sender;
        popover.sourceRect = btn.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [self presentViewController:alertController animated:YES completion:nil];
}



-(BOOL)textViewDidBeginEditing:(UITextView *)textView {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if (textView.tag == 123) {
        [self.view setFrame:CGRectMake(0,-110,screenWidth,screenHeight)];
        return YES;
    }else{
        return  NO;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if (textView.tag == 123) {
    [self.view setFrame:CGRectMake(0,0,screenWidth,screenHeight)];
        return YES;
    }else{
        return  NO;
    }
}

#pragma mark - PopUpMenu delegates
-(void)todaysDeal:(Menu *)sender{
    RetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
    view.pushedFrom = @"todaysDeal";
    [self.navigationController pushViewController:view animated:YES];
}
-(void)whatsNew:(Menu *)sender{
    RetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"retailView"];
    view.pushedFrom = @"whatsNew";
    [self.navigationController pushViewController:view animated:YES];
}
-(void)emergencyContact:(Menu *)sender{
    emergencyContactViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"contactView"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)contest:(Menu *)sender{

    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

    if([plistVal isEqualToString:@"YES"]){
        LoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];

        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
        [self.navigationController presentViewController:view animated:NO completion:nil];
    }else{
        contestViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"contestView"];
        [self.navigationController pushViewController:view animated:YES];
    }
}
-(void)GoProfilePage:(Menu *)sender{
    NSString *plistVal = [[NSString alloc]init];
    plistVal = [Utility getfromplist:@"skippedUser" plist:@"iq"];

    if([plistVal isEqualToString:@"YES"]){
        LoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];

        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
        [self.navigationController presentViewController:view animated:NO completion:nil];
    }else{
        ProfileViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"profileView"];
        [self.navigationController pushViewController:view animated:YES];
    }
}
-(void)GoAboutUsPage:(Menu *)sender{
    AboutUsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutUsView"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)History:(Menu *)sender{
//    OrderHistoryViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
//    [self.navigationController pushViewController:view animated:YES];
    OrderHistoryNewViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryNewViewController"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)ContactUs:(Menu *)sender{
    ContactUsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)goTermsOfUse:(Menu *)sender{
    TermsAndConditionsVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsAndConditionsVC"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)LogOut:(Menu *)sender{
    LoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController popToRootViewControllerAnimated:NO];

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];

    //G+ signout
    GIDSignIn *signin = [GIDSignIn sharedInstance];
    [signin signOut];

  //Logout plist clear
    [Utility addtoplist:@"" key:@"login" plist:@"iq"];

    //Resetting 'skipped user' value
    [Utility addtoplist:@"NO"key:@"skippedUser" plist:@"iq"];

    [self.navigationController presentViewController:view animated:NO completion:nil];
}


@end
