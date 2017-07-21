//
//  ChatViewController.h
//  PeerToPeerDemo
//
//  Created by Tarun Sharma on 03/07/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ChatViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *sendMessageTF;
- (IBAction)sendButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) MCPeerID * destinationPeerID;
@end
