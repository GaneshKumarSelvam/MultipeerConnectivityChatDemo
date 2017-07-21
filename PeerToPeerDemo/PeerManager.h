//
//  PeerManager.h
//  PeerToPeerDemo
//
//  Created by Tarun Sharma on 03/07/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
@interface PeerManager : NSObject<MCSessionDelegate>

@property (nonatomic, strong) MCPeerID * peerID;
@property (nonatomic, strong) MCSession * peerSession;
@property (nonatomic, strong) MCBrowserViewController * browser;
@property (nonatomic, strong) MCAdvertiserAssistant * peerAdvertiser;
-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;
@end
