//
//  pic2shopClientAppDelegate.h
//  pic2shopClient
//  Copyright 2010-2015 Vision Smarts SPRL
//

#import <UIKit/UIKit.h>

@class pic2shopClientViewController;

@interface pic2shopClientAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    pic2shopClientViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet pic2shopClientViewController *viewController;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;

@end

