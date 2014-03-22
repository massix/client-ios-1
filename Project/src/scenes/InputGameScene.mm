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

#import "InputGameScene.h"
#import "ORButton.h"
#import "ORTextField.h"
#import "ServerCommunicator.h"
#import "CallbackResponder.h"
#import "ORArrowButton.h"

#import "robot.pb.h"
#import "controller.pb.h"

#import <MotionJpegImageView.h>

@interface InputGameScene() <CallbackResponder>
@property (strong, nonatomic) ORTextField *playerTextField;
@property (strong, nonatomic) ServerCommunicator *serverCommunicator;

@property (strong, nonatomic) ORArrowButton *leftButton;
@property (strong, nonatomic) ORArrowButton *downButton;
@property (strong, nonatomic) ORArrowButton *rightButton;
@property (strong, nonatomic) ORArrowButton *upButton;
@property (strong, nonatomic) NSMutableArray *buttonsArray;
@property (strong, nonatomic) MotionJpegImageView *mjpegViewer;

@end

@implementation InputGameScene

@synthesize playerTextField = _playerTextField;
@synthesize serverCommunicator = _serverCommunicator;
@synthesize leftButton = _leftButton;
@synthesize downButton = _downButton;
@synthesize rightButton = _rightButton;
@synthesize upButton = _upButton;
@synthesize buttonsArray = _buttonsArray;
@synthesize mjpegViewer = _mjpegViewer;

- (id)init
{
	self = [super init];
	[self addBackButton];
	[self registerSelector:@selector(onBackButton:)];
	
	_playerTextField = [ORTextField textFieldWithWidth:Sparrow.stage.width - 30.0f height:40.0f text:@""];
	
	_buttonsArray = [NSMutableArray array];

	_leftButton = [[ORArrowButton alloc] initWithRotation:LEFT];
	_leftButton.name = @"left";
	[_buttonsArray addObject:_leftButton];
	
	_rightButton = [[ORArrowButton alloc] initWithRotation:RIGHT];
	_rightButton.name = @"right";
	[_buttonsArray addObject:_rightButton];

	_downButton = [[ORArrowButton alloc] initWithRotation:DOWN];
	_downButton.name = @"down";
	[_buttonsArray addObject:_downButton];

	_upButton = [[ORArrowButton alloc] initWithRotation:UP];
	_upButton.name = @"up";
	[_buttonsArray addObject:_upButton];

	DDLogDebug(@"Initing _mjpegViewer");
	_mjpegViewer = [[MotionJpegImageView alloc] initWithFrame:CGRectMake(0.0f, self.playerTextField.height + self.playerTextField.y + 15.0f, 310.0f, 235.0f)];
	_mjpegViewer.url = [NSURL URLWithString:@"http://87.232.128.229/axis-cgi/mjpg/video.cgi"];
	_mjpegViewer.hidden = NO;


	// Event block
	for (ORArrowButton *button in _buttonsArray) {
		[button addEventListenerForType:SP_EVENT_TYPE_TRIGGERED block:^(SPEvent *event) {
			using namespace orwell::messages;
			ORArrowButton *button = (ORArrowButton *) event.target;
			DDLogInfo(@"Button %@ pressed, rotation: %d", button.name, button.rotation);

			double left = 0, right = 0;
			
			Input inputMessage;
			switch (button.rotation) {
				case UP:
					left = 1;
					right = 1;
					break;
				case DOWN:
					left = -1;
					right = -1;
					break;
				case LEFT:
					left = 1;
					right = -1;
					break;
				case RIGHT:
					left = -1;
					right = 1;
					break;
			}
			
			DDLogDebug(@"Sending message with left: %f, right: %f", left, right);
			
			inputMessage.mutable_move()->set_left(left);
			inputMessage.mutable_move()->set_right(right);
			inputMessage.mutable_fire()->set_weapon1(false);
			inputMessage.mutable_fire()->set_weapon2(false);
			
			ServerMessage *message = [[ServerMessage alloc] init];
			message.tag = @"Input ";
			message.receiver = @"iphoneclient ";
			message.payload = [NSData dataWithBytes:inputMessage.SerializeAsString().c_str() length:inputMessage.SerializeAsString().length()];
			DDLogDebug(@"Pushing message Input");
			
			[_serverCommunicator pushMessage:message];
			[_mjpegViewer pause];
			[_mjpegViewer play];

		}];
	}
	
	// This is active already
	_serverCommunicator = [ServerCommunicator initSingleton];
	[_serverCommunicator registerResponder:self forMessage:@"Input"];

	return self;
}

- (void)onBackButton:(SPEvent *)event
{
	[self unregisterSelector:@selector(onBackButton:)];
	[self dispatchEventWithType:EVENT_TYPE_INPUT_SCENE_CLOSING bubbles:YES];

	[_mjpegViewer removeFromSuperview];
}

- (void)placeObjectInStage
{
	DDLogDebug(@"Inited with robot name: %@", self.robotName);
	DDLogDebug(@"Inited with player name: %@", self.playerName);

	DDLogDebug(@"Placed mjpegViewer in screen %@", [_mjpegViewer debugDescription]);

	self.playerTextField.text = [NSString stringWithFormat:@"%@ @ %@", self.playerName, self.robotName];
	self.playerTextField.x = 15.0f;
	self.playerTextField.y = 10.0f;
	[self addChild:self.playerTextField];

	[Sparrow.currentController.view addSubview:_mjpegViewer];
	
	float downSide = [self getBackButtonY] - self.downButton.height - 15.0f;
	float separator = 20.0f;

	self.downButton.x = (Sparrow.stage.width / 2) - (self.downButton.width / 2);
	self.downButton.y = downSide;
	
	self.leftButton.x = self.downButton.x - self.leftButton.width - separator;
	self.leftButton.y = downSide;
	
	self.rightButton.x = self.downButton.x + self.downButton.width + separator;
	self.rightButton.y = downSide;
	
	self.upButton.x = self.downButton.x;
	self.upButton.y = downSide - self.downButton.height - separator;
	
	[self addChild:self.rightButton];
	[self addChild:self.downButton];
	[self addChild:self.leftButton];
	[self addChild:self.upButton];
}

- (void)startObjects
{
	[_serverCommunicator registerResponder:self forMessage:@"Input"];
	[_mjpegViewer play];
}

- (BOOL)messageReceived:(NSDictionary *)message
{
	DDLogVerbose(@"Received message : %@", [message debugDescription]);
	return YES;
}

@end
