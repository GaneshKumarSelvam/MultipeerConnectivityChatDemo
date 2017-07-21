//
//  PeerManager.m
//  PeerToPeerDemo
//
//  Created by Tarun Sharma on 03/07/17.
//  Copyright © 2017 Chetaru Web LInk Private Limited. All rights reserved.
//

#import "PeerManager.h"

@implementation PeerManager
-(id)init{
    self = [super init];
    
    if (self) {
        _peerID = nil;
        _peerSession = nil;
        _browser = nil;
        _peerAdvertiser = nil;
    }
    
    return self;
}

#pragma mark OwnMethods
-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName{
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    
    _peerSession = [[MCSession alloc] initWithPeer:_peerID];
    _peerSession.delegate = self;
}


-(void)setupMCBrowser{
    _browser = [[MCBrowserViewController alloc] initWithServiceType:@"chat" session:_peerSession];
}



-(void)advertiseSelf:(BOOL)shouldAdvertise{
    if (shouldAdvertise) {
        _peerAdvertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat"
                                                           discoveryInfo:nil
                                                                 session:_peerSession];
        [_peerAdvertiser start];
    }
    else{
        [_peerAdvertiser stop];
        _peerAdvertiser = nil;
    }
}
#pragma mark MCDelegates

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSDictionary *dict = @{@"data": data,
                           @"peerID": peerID
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                        object:nil
                                                      userInfo:dict];
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}
@end
