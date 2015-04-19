//
//  KMMapView.m
//  KMCustomUI
//
//  Created by Keith Moon on 30/12/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "KMMapView.h"

@interface KMMapView ()

// For each annotation MKMapPoint calculate an NSIndexPath by segmenting the map by the block size to cluster 20x20, 50x50.
// Store an array of annotations in the dictionary below with the inexpath as the key.
// If there is more than the designated number in the array (1?) then add a cluster annotation to the mapview instead.

@property (nonatomic, strong) NSMutableDictionary *annotationByIndex;

@end

@implementation KMMapView

@end
