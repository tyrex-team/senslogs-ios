//
//  NSFileManagerAdditions.m
//  libutil
//
//  Created by Mathieu Razafimahazo on 22/09/10.
//  Copyright 2011 INRIA, Team WAM. All rights reserved.
//

#import "NSFileManagerAdditions.h"


@implementation NSFileManager (NDNSFileManagerAdditions)

+ (unsigned long long)fileSystemSize {
    
    unsigned long long size = 0;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[path lastObject] error:nil];
    
    if (dictionary)
        size = (unsigned long long)[[dictionary objectForKey:NSFileSystemSize] unsignedLongLongValue];
    
    return size;
}

+ (unsigned long long)fileSystemFreeSize {
    
    unsigned long long size = 0;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[path lastObject] error:nil];
    
    if (dictionary)
        size = (unsigned long long)[[dictionary objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    
    return size;
}

- (BOOL)copyItemAtURLSafely:(NSURL*) url toURL:(NSURL *)dstURL error:(NSError **)error {
    
    // Create all tree hierarchy for the given destination url
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *parentPath = [dstURL.path stringByDeletingLastPathComponent];
    
    if (![fm fileExistsAtPath: parentPath]) {
        
        [fm createDirectoryAtPath:parentPath withIntermediateDirectories:YES attributes:nil error: nil];
    }
    
    return [self copyItemAtURL:url toURL:dstURL error:error];
}

+ (NSString *)appDocumentPath {
    
    
    NSURL *appDocumentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        
    return appDocumentURL.path;
}

+ (NSString *)appCachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)app_document_path {
    
    return [NSFileManager appDocumentPath];
}

+ (NSString *)app_cache_path {
    
    return [NSFileManager appCachePath];
}

+ (NSString *)app_resource_path {
    
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSString *)app_bundle:(NSString *)path {
    
    return [[self app_resource_path] stringByAppendingPathComponent:path];
}

+ (NSString *)app_resource:(NSString *)path {
    
    return [[self app_resource_path] stringByAppendingPathComponent:path];
}

+ (NSString *)app_cache:(NSString *)path {
    
    return [[self app_cache_path] stringByAppendingPathComponent:path];
}

+ (NSString *)app_document:(NSString *)path {
    
    return [[self app_document_path] stringByAppendingPathComponent:path];
}

@end
