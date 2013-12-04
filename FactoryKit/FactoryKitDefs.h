//
//  FactoryKitDefs.h
//  FactoryKit
//
//  Created by Tomoki Aonuma on 12/3/13.
//  Copyright (c) 2013 exsen.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FCTDefinition;

typedef void (^FCTBuilderBlock)(FCTDefinition *def);

typedef id (^FCTSequentialDefBlock)(NSUInteger n);
typedef id (^FCTDeferredDefBlock)();

typedef void (^FCTAfterBlock)(NSManagedObject *object);
