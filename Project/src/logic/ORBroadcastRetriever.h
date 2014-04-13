/* Copyright (c) 2014, Massimo Gengarelli, orwell-int members
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  - Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * - Neither the name of the orwell-int organization nor the
 * names of its contributors may be used to endorse or promote products
 * derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL MASSIMO GENGARELLI BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>
#import "ORIPFour.h"

@interface ORBroadcastRetriever : NSObject
@property (strong, nonatomic, readonly) NSString *firstIp;
@property (strong, nonatomic, readonly) NSString *secondIp;
@property (strong, nonatomic, readonly) NSString *responderIp;
@property (strong, nonatomic, readonly) NSNumber *firstPort;
@property (strong, nonatomic, readonly) NSNumber *secondPort;
@property (strong, nonatomic, readonly) ORIPFour *ipFour;
@property (strong, nonatomic, readonly) NSArray *ipFourArray;

+ (id)retriever;
+ (id)retrieverWithTimeout:(int)timeout;
- (NSArray *)retrieveAddresses;
- (BOOL)retrieveAddress;
- (BOOL)sendMessageToServer:(int *)socket;
- (NSData *)getResponseFromServer:(int *)socket;
- (void)parseMessageFromServer:(NSData *)message;

@end