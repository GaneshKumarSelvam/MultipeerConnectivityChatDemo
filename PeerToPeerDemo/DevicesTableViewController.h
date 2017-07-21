//
//  DevicesTableViewController.h
//  PeerToPeerDemo
//
//  Created by Tarun Sharma on 03/07/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface DevicesTableViewController : UITableViewController<MCBrowserViewControllerDelegate>

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;
@property (nonatomic, strong) NSMutableDictionary * deviceDictionary;

- (IBAction)browseForDevicesButtonClick:(id)sender;

@end
