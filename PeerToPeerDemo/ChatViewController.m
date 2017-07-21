//
//  ChatViewController.m
//  PeerToPeerDemo
//
//  Created by Tarun Sharma on 03/07/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()
-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _sendMessageTF.delegate = self;
     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   [textField resignFirstResponder];
    return YES;
}


-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    [_chatTextView performSelectorOnMainThread:@selector(setText:) withObject:[_chatTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
}
- (IBAction)sendButtonClick:(id)sender {
    NSData *dataToSend = [_sendMessageTF.text dataUsingEncoding:NSUTF8StringEncoding];
    __block NSError *error;
    MCPeerID *myPeerID =_appDelegate.peerManager.peerSession.myPeerID;
    NSString * myDisplayName=myPeerID.displayName;
 
    [_appDelegate.peerManager.peerSession.connectedPeers enumerateObjectsUsingBlock:^(MCPeerID *aPeer, NSUInteger idx, BOOL *stop) {
        _destinationPeerID = aPeer;
        *stop = YES;
        if (*stop) {
            [_appDelegate.peerManager.peerSession sendData:dataToSend
                                                   toPeers:@[_destinationPeerID]
                                                  withMode:MCSessionSendDataReliable
                                                     error:&error];
            [_chatTextView setText:[_chatTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", myDisplayName,_sendMessageTF.text]]];
            [_sendMessageTF setText:@""];
        }
    }];
   
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }

    
}
@end
