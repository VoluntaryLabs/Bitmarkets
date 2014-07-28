//
//  BMKAppDelegate.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/15/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//<#(id)#>

#import "MKAppDelegate.h"
#import "MKRootNode.h"
#import "MKPasswordView.h"

@implementation MKAppDelegate

- (void)applicationDidFinishLaunching: (NSNotification *)aNote
{
    [super applicationDidFinishLaunching:aNote];
    
    [self setNavTitle:@"launching..."];
    [self.navWindow setSplashView:[[MKPasswordView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)]];
    [self performSelector:@selector(setup) withObject:nil afterDelay:0.0];
    [self showOpeningAlert];
}

- (void)setup
{
    [self setRootNode:[MKRootNode sharedMKRootNode]];
}

- (void)showOpeningAlert
{
    return;
    
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
    
}

@end
