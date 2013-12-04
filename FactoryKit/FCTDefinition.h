//
//  FCTDefinition.h
//  FactoryKit
//
//  Created by Tomoki Aonuma on 12/3/13.
//  Copyright (c) 2013 exsen.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "FactoryKitDefs.h"

@interface FCTDefinition : NSObject

- (void)afterBuild:(FCTAfterBlock)afterBuild;
- (void)afterCreate:(FCTAfterBlock)afterCreate;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key;

@end
