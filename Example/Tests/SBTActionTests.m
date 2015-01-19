/**
 * Copyright (C) 2015 Subito.it S.r.l (www.subito.it)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@import UIKit;

#import <SBTActionController/SBTAction.h>

SPEC_BEGIN(SBTActionTests)

describe(@"SBTAction", ^{

    context(@"When initialized with nil arguments", ^{
        
        it(@"should raise an exception if passed a nil title", ^{
            [[theBlock(^{
                __unused SBTAction *action = [[SBTAction alloc] initWithTitle:nil
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(SBTAction *action) {
                                                                          NSLog(@"User always does what we want him to do");
                                                                      }];
            }) should] raise];
        });
        
        it(@"should accept a nil handler", ^{
            [[theBlock(^{
                __unused SBTAction *action = [[SBTAction alloc] initWithTitle:@"Cancel"
                                                                        style:UIAlertActionStyleCancel
                                                                      handler:nil];
            }) shouldNot] raise];
        });
        
    });
    
    context(@"When created with nil", ^{
        
        it(@"should raise an exception if passed a nil title", ^{
            [[theBlock(^{
                __unused SBTAction *action = [SBTAction actionWithTitle:nil
                                                                  style:UIAlertActionStyleDestructive
                                                                handler:^(SBTAction *action) {
                                                                    NSLog(@"See?! Now your iPhone is ruined!");
                                                                }];
            }) should] raise];
        });
        
        it(@"should accept a nil handler", ^{
            [[theBlock(^{
                __unused SBTAction *action = [SBTAction actionWithTitle:@"Cancel"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:nil];
            }) shouldNot] raise];
        });

    });
    
    context(@"When initialized with valid arguments", ^{
        
        __block NSString *imageName;
        __block SBTAction *action;
        
        beforeEach(^{
            action = [[SBTAction alloc] initWithTitle:@"Camera"
                                                style:UIAlertActionStyleDefault
                                              handler:^(SBTAction *action) {
                                                  imageName = @"My awesome selfie";
                                              }];
        });
        
        afterEach(^{
            action = nil;
        });
        
        it(@"should hold the correct title", ^{
            [[action.title should] equal:@"Camera"];
        });
        
        it(@"should have the correct syle", ^{
            [[theValue(action.style) should] equal:@(UIAlertActionStyleDefault)];
        });
        
        it(@"should have a handler", ^{
            [[action.handler should] beNonNil];
        });
        
        it(@"should execute its handler correctly", ^{
            action.handler(action);
            [[imageName should] equal:@"My awesome selfie"];
        });
        
    });
    
    context(@"When created with valid arguments", ^{
        
        __block NSNumber *imagesCount = @2;
        __block SBTAction *action;
        
        beforeEach(^{
            action = [SBTAction actionWithTitle:@"Cancel iCloud upload"
                                          style:UIAlertActionStyleCancel
                                        handler:^(SBTAction *action) {
                                            imagesCount = @([imagesCount integerValue] - 1);
                                        }];
        });
        
        afterEach(^{
            action = nil;
        });
        
        it(@"should hold the correct title", ^{
            [[action.title should] equal:@"Cancel iCloud upload"];
        });
        
        it(@"should have the correct syle", ^{
            [[theValue(action.style) should] equal:@(UIAlertActionStyleCancel)];
        });
        
        it(@"should have a handler", ^{
            [[action.handler should] beNonNil];
        });
        
        it(@"should execute its handler correctly", ^{
            action.handler(action);
            [[imagesCount should] equal:@1];
        });
        
    });
    
});

SPEC_END
