//
//  KMNRequestCompletionHandler.h
//  KMNetworking
//
//  Created by Keith Moon on 04/11/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

typedef void (^KMNRequestCompletionHandler)(BOOL successful, NSURLResponse *response, id responseObject, NSError *error);