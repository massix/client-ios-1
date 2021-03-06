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

#import "OREventOrientation.h"

@implementation OREventOrientation

@synthesize orientation = _orientation;
@synthesize fromOrientation = _fromOrientation;

+ (id)eventWithType:(NSString *)type toOrientation:(UIInterfaceOrientation)toOrientation
{
	OREventOrientation *event = [SPEvent eventWithType:type bubbles:NO];
	event->_orientation = toOrientation;
	return event;
}

- (id)initWithType:(NSString *)type bubbles:(BOOL)bubbles toOrientation:(UIInterfaceOrientation)toOrientation
{
	if (self = [super initWithType:type bubbles:NO]) {
		_orientation = toOrientation;
	}

	return self;
}

- (id)initWithType:(NSString *)type bubbles:(BOOL)bubbles fromOrientation:(UIInterfaceOrientation)fromOrientation
{
	if (self = [super initWithType:type bubbles:NO]) {
		_fromOrientation = fromOrientation;
	}

	return self;
}

@end
