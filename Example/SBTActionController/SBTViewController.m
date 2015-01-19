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

#import "SBTViewController.h"
#import <SBTActionController/SBTActionController.h>

@interface SBTViewController () <UIPopoverPresentationControllerDelegate>

@property (nonatomic, weak) UIView *sender;

@end

@implementation SBTViewController

- (IBAction)actionOpenActionSheet:(UIBarButtonItem *)sender
{
    SBTActionController *actionController = [self fakeActionController];
    [actionController presentActionsFromBarButtonItem:sender
                                     inViewController:self
                                             animated:YES
                                           completion:^{
                                               NSLog(@"Action sheet opened succefully");
                                           }];
}

- (IBAction)actionOpenActionSheetFromRect:(UIButton *)sender
{
    self.sender = sender;
    SBTActionController *actionController = [self fakeActionController];
    [actionController presentActionsFromRect:sender.frame
                            inViewController:self
                                    animated:YES
                                  completion:^{
                                      NSLog(@"Action sheet opened succefully");
                                  }];
}

- (IBAction)actionOpenActionSheetFromView:(UIButton *)sender
{
    self.sender = sender;
    SBTActionController *actionController = [self fakeActionController];
    [actionController presentActionsFromView:sender
                            inViewController:self
                                    animated:YES
                                  completion:^{
                                      NSLog(@"Action sheet opened succefully");
                                  }];
}

- (SBTActionController *)fakeActionController
{
    SBTActionController *actionController = [SBTActionController actionControllerWithTitle:@"Take a picture"
                                                                                   message:@"Fake it til you make it"];
    actionController.popoverPresentationControllerDelegate = self;
    
    SBTAction *action = [SBTAction actionWithTitle:@"Fake action"
                                             style:UIAlertActionStyleDefault
                                           handler:^(SBTAction *action) {
                                               NSLog(@"%@", action.title);
                                           }];
    
    SBTAction *cancelAction = [SBTAction actionWithTitle:@"Fake cancel"
                                                   style:UIAlertActionStyleCancel
                                                 handler:^(SBTAction *action) {
                                                     NSLog(@"%@", action.title);
                                                 }];
    
    SBTAction *destructiveAction = [SBTAction actionWithTitle:@"Fake destructive"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(SBTAction *action) {
                                                          NSLog(@"%@", action.title);
                                                      }];
    
    [actionController addAction:action];
    [actionController addAction:cancelAction];
    [actionController addAction:destructiveAction];

    return actionController;
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view
{
    *rect = self.sender.frame;
}

@end
