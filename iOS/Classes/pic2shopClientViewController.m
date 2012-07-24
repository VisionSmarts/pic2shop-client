//
//  pic2shopClientViewController.m
//  pic2shopClient
//  Copyright 2010-2012 Vision Smarts SPRL
//

#import "pic2shopClientViewController.h"

@implementation pic2shopClientViewController

@synthesize resultIsLabel,barcodeLabel,formatLabel,UPCSwitch,ITFSwitch,Code39Switch,Code128Switch,CodabarSwitch,QRSwitch;
@synthesize pic2shopInstalledLabel,pic2shopPROInstalledLabel,scanButton;


- (void)viewDidLoad {
    [super viewDidLoad];
 
	[self checkForPic2shop];
	
	self.resultIsLabel.hidden = YES;	
	self.barcodeLabel.hidden  = YES;	
	self.formatLabel.hidden   = YES;	
}

-(void)checkForPic2shop {
    // check which apps are already installed
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"pic2shop:"]]) {
		// pic2shop is there
		self.pic2shopInstalledLabel.text = @"Pic2shop is installed";
        pic2shopIsInstalled = YES;
	}
	else {
		// pic2shop is not there
		self.pic2shopInstalledLabel.text = @"Pic2shop is not installed";
        pic2shopIsInstalled = NO;		
	}	
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"p2spro:"]]) {
		// pic2shop is there
		self.pic2shopPROInstalledLabel.text = @"Pic2shop PRO is installed";
        pic2shopPROIsInstalled = YES;
	}
	else {
		// pic2shop is not there
		self.pic2shopPROInstalledLabel.text = @"Pic2shop PRO is not installed";
        pic2shopPROIsInstalled = NO;		
	}
    
	// reset some switches if user has not installed suitable app
    if (!pic2shopIsInstalled && !pic2shopPROIsInstalled) {
        UPCSwitch.on = NO;
        QRSwitch.on  = NO;
    }
    if (!pic2shopPROIsInstalled) {
        Code39Switch.on  = NO;
        Code128Switch.on = NO;
        CodabarSwitch.on = NO;
        ITFSwitch.on     = NO;
    }
}

-(void)updateBarcode:(NSString*)code andFormat:(NSString*)format {
	self.barcodeLabel.text    = code;
    if ([code length]>36) {
        // very crude text size adjustment
        self.barcodeLabel.font = [self.barcodeLabel.font fontWithSize:30.0 * 6.0 / sqrt([code length]) ];
    }
    else {
        self.barcodeLabel.font = [self.barcodeLabel.font fontWithSize:30.0];
    }
	self.barcodeLabel.hidden  = NO;
	self.resultIsLabel.hidden = NO;
    if (format) {
        self.formatLabel.text=[NSString stringWithFormat:@"(%@)",format];
        self.formatLabel.hidden = NO;       
    }
    else {
        self.formatLabel.hidden = YES;
    }
}

-(void)installPic2shop {
	// go to App Store
	NSURL *urlapp = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=308740640&mt=8"];
	[[UIApplication sharedApplication] openURL:urlapp];
}

-(void)installPic2shopPRO {
	// go to App Store
	NSURL *urlapp = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=382585125&mt=8"];
	[[UIApplication sharedApplication] openURL:urlapp];
}

-(void)promptForPic2shop:(int)version forFormat:(NSString*)format {
    versionToInstall = version;
    // offer to install pic2shop (version==1) or pic2shop PRO (version==2)
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"To scan %@ you need to %@", format, version==1 ? @"install the free app pic2shop": @"purchase pic2shop PRO"] delegate:self cancelButtonTitle:@"No Thanks"destructiveButtonTitle:nil otherButtonTitles:@"Install it", nil ];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.view];
	[actionSheet release];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // OK, Install
        if (versionToInstall == 1) {
            [self installPic2shop];
        }  
        else if (versionToInstall == 2) {
            [self installPic2shopPRO];
        }  
    }
    else { // No Thanks
        // we have to reset some switches
        [self checkForPic2shop];
    }
    versionToInstall = 0;
}
         
-(IBAction)scan:(id)sender {
	// launch pic2shop PRO or pic2shop, call us back after scan
    
    NSString *formats = @"";
    if (UPCSwitch.on) formats = [formats stringByAppendingString:@",EAN13,EAN8,UPCE"];  // UPCA is subset of EAN13
    if (Code39Switch.on) formats = [formats stringByAppendingString:@",Code39"];
    if (Code128Switch.on) formats = [formats stringByAppendingString:@",Code128"];
    if (ITFSwitch.on) formats = [formats stringByAppendingString:@",ITF"];
    if (CodabarSwitch.on) formats = [formats stringByAppendingString:@",Codabar"];
    if (QRSwitch.on) formats = [formats stringByAppendingString:@",QR"];

    if ([formats length]>0) {  // at least one format has been selected
        formats = [formats stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@""]; // remove leading ","
        if (pic2shopPROIsInstalled) {
            NSURL *urlp2s = [NSURL URLWithString:[NSString stringWithFormat:@"p2spro://scan?formats=%@&callback=p2sclient%%3A///result%%3Fcode%%3DCODE%%26format%%3DFORMAT", formats ] ]; 
            // non-encoded, callback=p2sclient:///result?code=CODE&format=FORMAT
            // pic2shop PRO will replace "CODE" by barcode and "FORMAT" by format
            NSLog(@"opening URL: %@", urlp2s);
            [[UIApplication sharedApplication] openURL:urlp2s];
        }
        else {
            if (pic2shopIsInstalled) {
                // pic2shop always scans UPC-A, UPC-E, EAN13, EAN8 and QR, one cannot restrict to some formats
                NSURL *urlp2s = [NSURL URLWithString:@"pic2shop://scan?callback=p2sclient%3A///result%3Fcode%3DEAN%26qr%3DQR"]; 
                // non-encoded, callback=p2sclient:///result?code=EAN&qr=QR
                // pic2shop will replace "EAN" by barcode or "QR" by QR code
                NSLog(@"opening URL: %@", urlp2s);
                [[UIApplication sharedApplication] openURL:urlp2s];
            }
        }
    }
}

-(IBAction)switchUPC:(id)sender {
    if ( (UPCSwitch.on) && (!pic2shopIsInstalled) && (!pic2shopPROIsInstalled) ) {
        [self promptForPic2shop:1 forFormat:@"UPC & EAN barcodes"];
    }
}
-(IBAction)switchITF:(id)sender {
    if ( (ITFSwitch.on)  && (!pic2shopPROIsInstalled) ) {
        [self promptForPic2shop:2 forFormat:@"ITF barcodes"];
    }    
}
-(IBAction)switchCode39:(id)sender {
    if ( (Code39Switch.on)  && (!pic2shopPROIsInstalled) ) {
        [self promptForPic2shop:2 forFormat:@"Code39 barcodes"];
    }        
}
-(IBAction)switchCode128:(id)sender {
    if ( (Code128Switch.on)  && (!pic2shopPROIsInstalled) ) {
        [self promptForPic2shop:2 forFormat:@"Code 128 barcodes"];
    }    
}
-(IBAction)switchCodabar:(id)sender {
    if ( (CodabarSwitch.on)  && (!pic2shopPROIsInstalled) ) {
        [self promptForPic2shop:2 forFormat:@"Codabar barcodes"];
    }    
}
-(IBAction)switchQR:(id)sender {
    if ( (QRSwitch.on) && (!pic2shopIsInstalled) && (!pic2shopPROIsInstalled) ) {
        [self promptForPic2shop:1 forFormat:@"QR codes"];
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
