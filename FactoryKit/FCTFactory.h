//
//  FCTFactory.h
//  FactoryKit
//
//  Created by Tomoki Aonuma on 12/3/13.
//  Copyright (c) 2013 exsen.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "FactoryKitDefs.h"

@interface FCTFactory : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

- (void)defineBuilderForEntityForName:(NSString *)entityName usingBlock:(FCTBuilderBlock)builderBlock;

- (void)defineBuilderNamed:(NSString *)builderName forEntityForName:(NSString *)entityName usingBlock:(FCTBuilderBlock)builderBlock;

- (NSManagedObject *)buildManagedObjectUsingBuilderNamed:(NSString *)builderName;

- (NSManagedObject *)createManagedObjectUsingBuilderNamed:(NSString *)builderName;

@end
