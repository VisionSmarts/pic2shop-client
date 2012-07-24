//
//  pic2shopClientViewController.h
//  pic2shopClient
//  Copyright 2010-2012 Vision Smarts SPRL
//

#import <UIKit/UIKit.h>

@interface pic2shopClientViewController : UIViewController<UIActionSheetDelegate> {
    BOOL pic2shopIsInstalled;
    BOOL pic2shopPROIsInstalled;
    int  versionToInstall;
}

@property (nonatomic, retain) IBOutlet UILabel *resultIsLabel;
@property (nonatomic, retain) IBOutlet UILabel *barcodeLabel;
@property (nonatomic, retain) IBOutlet UILabel *formatLabel;

@property (nonatomic, retain) IBOutlet UISwitch *UPCSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *ITFSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *Code39Switch;
@property (nonatomic, retain) IBOutlet UISwitch *Code128Switch;
@property (nonatomic, retain) IBOutlet UISwitch *CodabarSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *QRSwitch;

@property (nonatomic, retain) IBOutlet UILabel *pic2shopInstalledLabel;
@property (nonatomic, retain) IBOutlet UILabel *pic2shopPROInstalledLabel;

@property (nonatomic, retain) IBOutlet UIButton *scanButton;


-(IBAction)switchUPC:(id)sender;
-(IBAction)switchITF:(id)sender;
-(IBAction)switchCode39:(id)sender;
-(IBAction)switchCode128:(id)sender;
-(IBAction)switchCodabar:(id)sender;
-(IBAction)switchQR:(id)sender;
-(IBAction)scan:(id)sender;

-(void)updateBarcode:(NSString*)code andFormat:(NSString*)format;
-(void)checkForPic2shop;

@end

