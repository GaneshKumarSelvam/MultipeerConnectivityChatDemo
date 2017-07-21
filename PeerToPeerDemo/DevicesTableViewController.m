//
//  DevicesTableViewController.m
//  PeerToPeerDemo
//
//  Created by Tarun Sharma on 03/07/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import "DevicesTableViewController.h"
#import "ChatViewController.h"
@interface DevicesTableViewController ()
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;

@end

@implementation DevicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _arrConnectedDevices = [[NSMutableArray alloc] init];
    _deviceDictionary=[[NSMutableDictionary alloc]init];

    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[_appDelegate peerManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[_appDelegate peerManager] advertiseSelf:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID * peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString * peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [_deviceDictionary setObject:peerID forKey:@"peer_id"];
            [_deviceDictionary setObject:peerDisplayName forKey:@"peer_display_name"];
        
            [_arrConnectedDevices addObject:_deviceDictionary];
            NSLog(@"Device %@",_arrConnectedDevices);
        }
        else if (state == MCSessionStateNotConnected){
            if ([_arrConnectedDevices count] > 0) {
                
               NSUInteger index  = [_arrConnectedDevices indexOfObjectPassingTest:
                          ^BOOL(NSDictionary *dict, NSUInteger idx, BOOL *stop)
                          {
                              return [[dict objectForKey:@"peer_display_name"] isEqual:peerDisplayName];
                          }
                          ];
                
                [_arrConnectedDevices removeObjectAtIndex:index];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
        });
       
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_arrConnectedDevices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deviceCell"];
    }
    
    cell.textLabel.text = [[_arrConnectedDevices objectAtIndex:indexPath.row] objectForKey:@"peer_display_name"];
    
    return cell;
}




- (IBAction)browseForDevicesButtonClick:(id)sender {
    [[_appDelegate peerManager] setupMCBrowser];
    [[[_appDelegate peerManager] browser] setDelegate:self];
    [self presentViewController:[[_appDelegate peerManager] browser] animated:YES completion:nil];
}

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.peerManager.browser dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.peerManager.browser dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"sendChatToPeerSegue"]) {
        ChatViewController * chatVC=[segue destinationViewController];
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        [chatVC setDestinationPeerID:[[_arrConnectedDevices objectAtIndex:indexPath.row ]objectForKey:@"peer_id"]];
    }
}
@end
