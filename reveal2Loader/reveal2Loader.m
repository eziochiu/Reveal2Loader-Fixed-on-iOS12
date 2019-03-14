//
//  reveal2Loader.m
//  reveal2Loader
//
//  Created by Ezio Chiu on 2/25/19.
//

#import "reveal2Loader.h"
#import <CaptainHook/CaptainHook.h>
#include <dlfcn.h>

CHConstructor // code block that runs immediately upon load
{
    @autoreleasepool
    {
        NSDictionary *prefs = [[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.rheard.RHRevealLoader.plist"] retain];
        NSString *libraryPath = @"/Library/Frameworks/RevealServer.framework/RevealServer";
        
        if([[prefs objectForKey:[NSString stringWithFormat:@"RHRevealEnabled-%@", [[NSBundle mainBundle] bundleIdentifier]]] boolValue]) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:libraryPath]){
                void *addr = dlopen([libraryPath UTF8String], RTLD_NOW);
                if (addr) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"IBARevealRequestStart" object:nil];
                    NSLog(@"Reveal2Loader loaded %@ successed and address %p", libraryPath,addr);
                } else {
                    NSLog(@"Reveal2Loader loaded %@ failed and address %p", libraryPath,addr);
                }
            }
        }
    }
}
