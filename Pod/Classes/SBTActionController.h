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

#import "SBTAction.h"

/**
 *  SBTActionController acts as a Façade for UIActionSheet and UIAlertController avoiding presentation related issues when using 
 *  the deprecated UIActionSheet class to support pre iOS 8 versions.
 */
@interface SBTActionController : NSObject

/**
 *  The action controller's title.
 */
@property (nonatomic, copy) NSString *title;

/**
 *  The action controller's message.
 *
 *  @discussion Does nothing when running on versions of iOS lower than 8.0 as UIActionSheet doesn't support a message string.
 */
@property (nonatomic, copy) NSString *message;

/**
 *  A Boolean value that indicates whether the backing UIActionSheet or UIAlertController is displayed.
 */
@property (nonatomic, readonly, getter=isVisible) BOOL visible;

/**
 *  The designated initializer. Initializes an SBTAlertController object with a title and a message.
 *
 *  @param title   A string to display in the title area of the action sheet or the alert controller.
 *                 Pass nil if you do not want to display any text in the title area.
 *  @param message Descriptive text that provides additional details about the reason for the actions.
 *
 *  @return A newly initialized action controller or nil.
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message __attribute__((objc_designated_initializer));

/**
 *  Creates and returns an SBTAlertController object with a title and a message.
 *
 *  @param title   A string to display in the title area of the action sheet or the alert controller.
 *                 Pass nil if you do not want to display any text in the title area.
 *  @param message Descriptive text that provides additional details about the reason for the actions.
 *
 *  @return A newly initialized action controller or nil.
 */
+ (instancetype)actionControllerWithTitle:(NSString *)title
                                  message:(NSString *)message;

/**
 *  Attaches an action object to the action sheet.
 *
 *  @param action The action object to display as part of the action sheet. It must not be nil.
 *
 *  @discussion Adding two action with UIAlertActionStyleDestructive or two actions with UIAlertActionStyleCancel will raise an exception.
 */
- (void)addAction:(SBTAction *)action;

/**
 *  Presents an action sheet that originates from the specified bar button item.
 *
 *  @param barButtonItem  The bar button item from which the action sheet originates. It must not be nil.
 *  @param viewController The view controller on which the action sheet is presented. It must not be nil.
 *  @param animated       Pass YES to animate the presentation; otherwise, pass NO.
 *  @param completion     The block to execute after the presentation finishes.
 */
- (void)presentActionsFromBarButtonItem:(UIBarButtonItem *)barButtonItem
                       inViewController:(UIViewController *)viewController
                               animated:(BOOL)animated
                             completion:(void (^)(void))completion;

/**
 *  Presents an action sheet that originates from the specified view.
 *
 *  @param view           The view from which the action sheet originates. It must not be nil.
 *  @param viewController The view controller on which the action sheet is presented. It must not be nil.
 *  @param animated       Pass YES to animate the presentation; otherwise, pass NO.
 *  @param completion     The block to execute after the presentation finishes.
 */
- (void)presentActionsFromView:(UIView *)view
              inViewController:(UIViewController *)viewController
                      animated:(BOOL)animated
                    completion:(void (^)(void))completion;

/**
 *  Presents an action sheet that originates from the specified frame.
 *
 *  @param rect           The frame from which the action sheet originates.
 *  @param viewController The view controller on which the action sheet is presented. It must not be nil.
 *  @param animated       Pass YES to animate the presentation; otherwise, pass NO.
 *  @param completion     The block to execute after the presentation finishes.
 */
- (void)presentActionsFromRect:(CGRect)rect
              inViewController:(UIViewController *)viewController
                      animated:(BOOL)animated
                    completion:(void (^)(void))completion;

/**
 *  Dismisses the action sheet that was presented.
 *
 *  @param animated   Pass YES to animate the presentation; otherwise, pass NO.
 *  @param completion The block to execute after the dismissal finishes.
 */
- (void)dismissActionsAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
