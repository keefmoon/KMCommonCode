//
//  KMCore.h
//  KMCore
//
//  Created by Keith Moon on 10/11/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...) /* */
#endif

@import Foundation;
#import "KMCConcurrentOperation.h"
#import "UIView+IBInspectables.h"

@interface KMCore : NSObject

@end
