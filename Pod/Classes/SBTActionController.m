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

#import <objc/runtime.h>
#import "SBTActionController.h"

#pragma mark - UIActionSheet SBTActions category

@interface UIActionSheet (SBTActions)

@property (nonatomic, strong) SBTActionController *sbt_actionController;

@end

@implementation UIActionSheet (SBTActions)

- (void)setSbt_actionController:(SBTActionController *)actionController
{
    objc_setAssociatedObject(self, @selector(sbt_actionController), actionController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SBTActionController *)sbt_actionController
{
    return (SBTActionController *)objc_getAssociatedObject(self, @selector(sbt_actionController));
}

@end

#pragma mark - SBTActionController class extension

@interface SBTActionController () <UIActionSheetDelegate>

@property (nonatomic, assign, getter=hasRegisteredDestructiveAction) BOOL registeredDestructiveAction;
@property (nonatomic, assign, getter=hasRegisteredCancelAction) BOOL registeredCancelAction;

#pragma mark - Action sheet related properties

@property (nonatomic, strong, readonly) UIActionSheet *actionSheet;

@property (nonatomic, copy) void(^actionSheetPresentationCompletionBlock)(void);
@property (nonatomic, copy) void(^actionSheetDismissalCompletionBlock)(void);

@property (nonatomic, strong) NSMutableArray *actions;

#pragma mark - Alert controller related properties

@property (nonatomic, strong, readonly) UIAlertController *alertController;

@property (nonatomic, weak) UIViewController *alertControllerPresentingViewController;

@end

#pragma mark - SBTActionController implementation

@implementation SBTActionController

@dynamic title, message, visible;

#pragma mark - Initializers

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    self = [super init];
    if (self) {
        if ([UIAlertController class]) {
            _alertController = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
        } else {
            _actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
            _actions = [NSMutableArray array];
        }
    }
    return self;
}

- (instancetype)init
{
    return [self initWithTitle:nil message:nil];
}

+ (instancetype)actionControllerWithTitle:(NSString *)title message:(NSString *)message
{
    return [[self alloc] initWithTitle:title message:message];
}

#pragma mark - Accessors

- (NSString *)title
{
    return self.alertController ? self.alertController.title : self.actionSheet.title;
}

- (void)setTitle:(NSString *)title
{
    if (self.alertController) {
        self.alertController.title = title;
        return;
    }
    self.actionSheet.title = title;
}

- (NSString *)message
{
    return self.alertController.message;
}

- (void)setMessage:(NSString *)message
{
    self.alertController.message = message;
}

- (BOOL)isVisible
{
    return self.actionSheet ? self.actionSheet.isVisible : ([self.alertController isViewLoaded] && self.alertController.view.window);
}

#pragma mark - Actions

- (void)addAction:(SBTAction *)action
{
    NSCParameterAssert(action);
    
    [self registerActionStyle:action.style];
    
    if (self.alertController) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:action.title
                                                              style:action.style
                                                            handler:^(UIAlertAction *selectedAction) {
                                                                if (action.handler) {
                                                                    action.handler(action);
                                                                }
                                                            }];
        [self.alertController addAction:alertAction];
        return;
    }
    
    NSUInteger actionIndex = self.actions.count;
    [self.actions addObject:action];
    [self.actionSheet addButtonWithTitle:action.title];
    
    if (action.style == UIAlertActionStyleCancel) {
        self.actionSheet.cancelButtonIndex = actionIndex;
    } else if (action.style == UIAlertActionStyleDestructive) {
        self.actionSheet.destructiveButtonIndex = actionIndex;
    }
}

- (void)registerActionStyle:(UIAlertActionStyle)style
{
    if (style == UIAlertActionStyleDefault) {
        return;
    }
    
    if (self.hasRegisteredDestructiveAction && style == UIAlertActionStyleDestructive) {
        [[[self class] doubleDestructiveActionInConsistencyException] raise];
        return;
    }
    
    if (self.hasRegisteredCancelAction && style == UIAlertActionStyleCancel) {
        [[[self class] doubleCancelActionInConsistencyException] raise];
        return;
    }
    
    self.registeredDestructiveAction = (style == UIAlertActionStyleDestructive);
    self.registeredCancelAction = (style == UIAlertActionStyleCancel);
}

#pragma mark - Presentation

- (void)presentActionsFromBarButtonItem:(UIBarButtonItem *)barButtonItem
                       inViewController:(UIViewController *)viewController
                               animated:(BOOL)animated
                             completion:(void (^)(void))completion
{
    NSCParameterAssert(barButtonItem);
    NSCParameterAssert(viewController);
    
    [self presentActionsFromBarButtonItem:barButtonItem
                                   orView:nil
                                   orRect:CGRectZero
                         inViewController:viewController
                                 animated:animated
                               completion:completion];
}

- (void)presentActionsFromView:(UIView *)view
              inViewController:(UIViewController *)viewController
                      animated:(BOOL)animated
                    completion:(void (^)(void))completion
{
    NSCParameterAssert(view);
    NSCParameterAssert(viewController);
    
    [self presentActionsFromBarButtonItem:nil
                                   orView:view
                                   orRect:CGRectZero
                         inViewController:viewController
                                 animated:animated
                               completion:completion];
}

- (void)presentActionsFromRect:(CGRect)rect
              inViewController:(UIViewController *)viewController
                      animated:(BOOL)animated
                    completion:(void (^)(void))completion
{
    NSCParameterAssert(viewController);
    
    [self presentActionsFromBarButtonItem:nil
                                   orView:nil
                                   orRect:rect
                         inViewController:viewController
                                 animated:animated
                               completion:completion];
}

- (void)presentActionsFromBarButtonItem:(UIBarButtonItem *)barButtonItem
                                 orView:(UIView *)view
                                 orRect:(CGRect)rect
                       inViewController:(UIViewController *)viewController
                               animated:(BOOL)animated
                             completion:(void (^)(void))completion
{
    if (self.alertController) {
        [self presentAlertControllerFromBarButtonItem:barButtonItem
                                               orView:view
                                               orRect:rect
                                     inViewController:viewController
                                             animated:animated
                                           completion:completion];
        return;
    }
    [self presentActionSheetFromBarButtonItem:barButtonItem
                                       orView:view
                                       orRect:rect
                             inViewController:viewController
                                     animated:animated
                                   completion:completion];
}

- (void)presentAlertControllerFromBarButtonItem:(UIBarButtonItem *)barButtonItem
                                         orView:(UIView *)view
                                         orRect:(CGRect)rect
                               inViewController:(UIViewController *)viewController
                                       animated:(BOOL)animated
                                     completion:(void (^)(void))completion
{
    UIAlertController *alertController = self.alertController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        alertController.modalPresentationStyle = UIModalPresentationPopover;
        if (barButtonItem) {
            alertController.popoverPresentationController.barButtonItem = barButtonItem;
        } else {
            alertController.popoverPresentationController.sourceView = viewController.view;
            alertController.popoverPresentationController.sourceRect = view ? view.frame : rect;
        }
    }
    self.alertControllerPresentingViewController = viewController;
    [viewController presentViewController:alertController animated:animated completion:completion];
}

- (void)presentActionSheetFromBarButtonItem:(UIBarButtonItem *)barButtonItem
                                     orView:(UIView *)view
                                     orRect:(CGRect)rect
                           inViewController:(UIViewController *)viewController
                                   animated:(BOOL)animated
                                 completion:(void (^)(void))completion
{
    UIActionSheet *actionSheet = self.actionSheet;
    actionSheet.sbt_actionController = self;
    self.actionSheetPresentationCompletionBlock = [completion copy];
    if (barButtonItem) {
        [actionSheet showFromBarButtonItem:barButtonItem animated:animated];
        return;
    }
    CGRect frame = view ? [viewController.view convertRect:view.frame fromView:view.superview] : rect;
    [actionSheet showFromRect:frame inView:viewController.view animated:animated];
}

#pragma mark - Dismissal

- (void)dismissActionsAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (self.alertController) {
        [self.alertControllerPresentingViewController dismissViewControllerAnimated:animated completion:completion];
        return;
    }
    self.actionSheetDismissalCompletionBlock = [completion copy];
    [self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:animated];
}

#pragma mark - UIActionSheetDelegate

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    void(^presentationCompletionBlock)(void) = actionSheet.sbt_actionController.actionSheetPresentationCompletionBlock;
    if (presentationCompletionBlock) {
        presentationCompletionBlock();
        actionSheet.sbt_actionController.actionSheetPresentationCompletionBlock = nil;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    SBTActionController *actionController = actionSheet.sbt_actionController;
    SBTAction *action = actionController.actions[buttonIndex];
    if (action.handler) {
        action.handler(action);
    }
    if (actionController.actionSheetDismissalCompletionBlock) {
        actionController.actionSheetDismissalCompletionBlock();
        actionController.actionSheetDismissalCompletionBlock = nil;
    }
    actionSheet.sbt_actionController = nil;
}

#pragma mark - Inconsistency exception

+ (NSException *)doubleDestructiveActionInConsistencyException
{
    return [self internalInconsistencyExceptionWithReason:@"SBTAlertController can only have one action with a style of UIAlertActionStyleDestructive"];
}

+ (NSException *)doubleCancelActionInConsistencyException
{
    return [self internalInconsistencyExceptionWithReason:@"SBTAlertController can only have one action with a style of UIAlertActionStyleCancel"];
}

+ (NSException *)internalInconsistencyExceptionWithReason:(NSString *)reason
{
    return [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

@end
