//
//  BMKAppDelegate.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/15/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKAppDelegate.h"
#import "MKRootNode.h"
#import "MKPasswordView.h"
#import <BitnashKit/BitnashKit.h>

@implementation MKAppDelegate

- (void)applicationDidFinishLaunching: (NSNotification *)aNote
{
    [super applicationDidFinishLaunching:aNote];
    
    [self setNavTitle:@"launching..."];
    [self.navWindow setSplashView:[[MKPasswordView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)]];
    [self performSelector:@selector(setup) withObject:nil afterDelay:0.0];
}

- (void)setup
{
    [self showJavaAlertIfNeeded];
}

- (void)finishSetup
{
    [self setRootNode:[MKRootNode sharedMKRootNode]];
    
    if (MKRootNode.sharedMKRootNode.wallet.usesTestNet)
    {
        [self showTestNetAlert];
    }
    
    [self showDisclaimerWarning];
}

- (void)showDisclaimerWarning
{
    NSAlert *msgBox = [[NSAlert alloc] init];
    [msgBox setMessageText: @"USER AGREEMENT\n\nThis software is experimental and provided \"as is\", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement.\n\nIn no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software."];
    
    [msgBox addButtonWithTitle:@"I Agree"];
    [msgBox addButtonWithTitle:@"Quit"];
    
    [msgBox beginSheetModalForWindow:self.navWindow
                       modalDelegate:self
                      didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                         contextInfo:nil];
}

- (void)showTestNetAlert
{
    NSAlert *msgBox = [[NSAlert alloc] init];
    [msgBox setMessageText: @"This beta uses the Bitcoin testnet.\nDo not use this for real sales.\n\nFree testnet bitcoins are available at:\n\n     http://tpfaucet.appspot.com/"];
    [msgBox addButtonWithTitle: @"OK"];
    
    [msgBox beginSheetModalForWindow:self.navWindow
                       modalDelegate:self
                      didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                         contextInfo:nil];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{    
    if (returnCode == 1001) // 2nd choice
    {
        [NSApplication.sharedApplication terminate:self];
    }
}


- (void)showJavaAlertIfNeeded
{
    BNJavaInstall *install = [[BNJavaInstall alloc] init];
    
    if (!install.isInstalled)
    {
        NSAlert *msgBox = [[NSAlert alloc] init];
        [msgBox setMessageText:@"This application requires Java to be installed in order to use the BitcoinJ  wallet."];
        [msgBox addButtonWithTitle:@"I've installed Java"];
        [msgBox addButtonWithTitle:@"Install Java"];
        [msgBox addButtonWithTitle:@"Exit"];
        
        [msgBox beginSheetModalForWindow:self.navWindow
                           modalDelegate:self
                          didEndSelector:@selector(javaAlertDidEnd:returnCode:contextInfo:)
                             contextInfo:nil];
    }
    else
    {
        [self finishSetup];
    }
}


- (void)javaAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == 1000) // 1st choice
    {
    }
    
    if (returnCode == 1001) // 2nd choice
    {
        //[[[BNJavaInstall alloc] init] openJavaInstallDmg];
        [[[BNJavaInstall alloc] init] openJavaDmg];
    }
    
    if (returnCode == 1002) // 3rd choice
    {
        [NSApplication.sharedApplication terminate:self];
    }
    
    [self showJavaAlertIfNeeded];
}



@end
