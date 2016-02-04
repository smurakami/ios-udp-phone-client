//
//  UDP.h
//  UDPClient
//
//  Created by 村上晋太郎 on 2016/02/04.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UDPDelegate;

@interface UDP : NSObject

@property (nonatomic, weak,   readwrite) id<UDPDelegate>        delegate;
@property (nonatomic, assign, readonly, getter=isServer) BOOL   server;
@property (nonatomic, copy,   readonly ) NSString *             hostName;
@property (nonatomic, copy,   readonly ) NSData *               hostAddress;
@property (nonatomic, assign, readonly ) NSUInteger             port;

- (void)startServerOnPort:(NSUInteger)port;
- (void)startConnectedToHostName:(NSString *)hostName port:(NSUInteger)port;
- (void)sendData:(NSData *)data;
- (void)stop;

- (NSString *)getIPAddress;

@end

@protocol UDPDelegate <NSObject>
@optional
- (void)udp:(UDP *)udp didReceiveData:(NSData *)data fromAddress:(NSData *)addr;
- (void)udp:(UDP *)udp didReceiveError:(NSError *)error;
- (void)udp:(UDP *)udp didSendData:(NSData *)data toAddress:(NSData *)addr;
- (void)udp:(UDP *)udp didFailToSendData:(NSData *)data toAddress:(NSData *)addr error:(NSError *)error;
- (void)udp:(UDP *)udp didStartWithAddress:(NSData *)address;
- (void)udp:(UDP *)udp didStopWithError:(NSError *)error;
@end
