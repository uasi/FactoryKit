//
//  FCTBuilder.h
//  FactoryKit
//
//  Created by Tomoki Aonuma on 12/3/13.
//  Copyright (c) 2013 exsen.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "FactoryKitDefs.h"

@class FCTDefinition;

@interface FCTBuilder : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *entityName;
@property (nonatomic, readonly) FCTDefinition *definition;

- (instancetype)initWithName:(NSString *)name entityName:(NSString *)entityName builderBlock:(FCTBuilderBlock)builderBlock;

- (NSManagedObject *)buildObjectInManagedObjectContext:(NSManagedObjectContext *)context;
- (NSManagedObject *)createObjectInManagedObjectContext:(NSManagedObjectContext *)context;

@end
