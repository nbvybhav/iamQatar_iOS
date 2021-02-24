//
//  AddAddressViewController.h
//  IamQatar
//
//  Created by alisons on 4/12/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface AddAddressViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *fullNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumTxt;
@property (weak, nonatomic) IBOutlet UITextField *buildingName;
@property (weak, nonatomic) IBOutlet UIButton *btnMoreInfo;
@property (weak, nonatomic) IBOutlet UITextField *flatNoTxt;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UITextField *streetTxt;
//@property (weak, nonatomic) IBOutlet UITextField *landmarkTxt;
@property (weak, nonatomic) IBOutlet UITextView *moreInfoTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnShowMap;
@property (weak, nonatomic) IBOutlet UIButton *radioButtonOther;

//@property (weak, nonatomic) IBOutlet UITextField *stateTxt;
@property (weak, nonatomic) IBOutlet UIButton *radioButtonHome;
@property (weak, nonatomic) IBOutlet UIButton *radioButtonWork;
@property (weak, nonatomic) NSMutableDictionary *dictionaryRecieved;
@property (strong, nonatomic) IBOutlet UITextField *buildingNameTxt;



@end
