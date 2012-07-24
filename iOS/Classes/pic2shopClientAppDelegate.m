//
//  pic2shopClientAppDelegate.m
//  pic2shopClient
//  Copyright 2010-2012 Vision Smarts SPRL
//

#import "pic2shopClientAppDelegate.h"
#import "pic2shopClientViewController.h"

@implementation pic2shopClientAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
    NSArray *pvs = [query componentsSeparatedByString:@"&"];
    for (NSString *pv in pvs) {
        NSArray  *array = [pv componentsSeparatedByString:@"="];
        NSString *key   = [[array objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val   = [[array objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:key];
    }
    return params;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	// p2sclient://host/path?query - we only used the query part
    NSLog(@"got result back: %@", [url query]);
    NSDictionary *results = [self parseQueryString:[url query]];
    NSString *barcode = [results valueForKey:@"code"];
    NSString *format = [results valueForKey:@"format"]; 
    
    // pic2shop does not return a format
    if (format == nil) {
        format = @"UPC/EAN";
    }
    
    // pic2shop returns QR separately
    // we gave "qr=QR" in callback string, now check if "QR" has been replaced by a QR code payload 
    if ( ([results valueForKey:@"qr"] != nil) && (! [ [results valueForKey:@"qr"] isEqualToString:@"QR"]) ) {
        barcode = [results valueForKey:@"qr"];
        format  = @"QR";
    }
    
	[viewController updateBarcode:barcode andFormat:format];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// pic2shop or pic2shop PRO may have been installed or deleted while we were suspended
	[viewController checkForPic2shop];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
