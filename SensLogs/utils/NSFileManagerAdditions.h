//
//  NSFileManagerAdditions.h
//  libutil
//
//  Created by Mathieu Razafimahazo on 22/09/10.
//  Copyright 2011 INRIA, Team WAM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileManager (NDNSFileManagerAdditions) 

+ (unsigned long long)fileSystemSize;		// get the total file system size in bytes
+ (unsigned long long)fileSystemFreeSize;	// get the available file system size in bytes
+ (NSString *)appDocumentPath;				// path of the document folder of the application
+ (NSString *)appCachePath;					// path of the cache folder of the application
- (BOOL)copyItemAtURLSafely:(NSURL*) url toURL:(NSURL *)dstURL error:(NSError **)error;

+ (NSString *)app_document_path;
+ (NSString *)app_cache_path;
+ (NSString *)app_resource_path ;
+ (NSString *)app_bundle:(NSString *)path;
+ (NSString *)app_resource:(NSString *)path;
+ (NSString *)app_cache:(NSString *)path;
+ (NSString *)app_document:(NSString *)path;
@end
