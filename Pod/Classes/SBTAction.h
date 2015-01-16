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

@import Foundation;

@class SBTAction;

/**
 *  A block to execute when the user selects the action. 
 *
 *  @param action The selected action.
 */
typedef void(^SBTActionHandler)(SBTAction *action);

/**
 *  An SBTAction is a custom alternative implementation of UIAlertAction. An action object represents 
 *  an action that can be taken by the user when tapping a button in an action sheet for instance.
 */
@interface SBTAction : NSObject

/**
 *  The action's title.
 */
@property(nonatomic, copy, readonly) NSString *title;

/**
 *  The style that is applied to the action’s button.
 */
@property(nonatomic, assign, readonly) UIAlertActionStyle style;

/**
 *  The action's handler block.
 */
@property (nonatomic, copy, readonly) SBTActionHandler handler;

/**
 *  The designated initializer. Initializes an SBTAction with the given title, style and handler.
 *
 *  @param title   The action's title. It must not be nil.
 *  @param style   The style that is applied to the action’s button.
 *  @param handler A block to execute when the user selects the action.
 *
 *  @return An initialized SBTAction or nil.
 */
- (instancetype)initWithTitle:(NSString *)title
                        style:(UIAlertActionStyle)style
                      handler:(SBTActionHandler)handler __attribute__((objc_designated_initializer));

/**
 *  Use the designated initializer -initWithTitle:style:handler:
 */
- (instancetype)init __attribute__((unavailable("Use the designated initializer -initWithTitle:style:handler:")));

/**
 *  Creates and returns an SBTAction with the given title, style and handler.
 *
 *  @param title   The action's title. It must not be nil.
 *  @param style   The style that is applied to the action’s button.
 *  @param handler A block to execute when the user selects the action.
 *
 *  @return An initialized SBTAction or nil.
 */
+ (instancetype)actionWithTitle:(NSString *)title
                          style:(UIAlertActionStyle)style
                        handler:(SBTActionHandler)handler;

@end
