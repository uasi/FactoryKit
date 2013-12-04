//
//  FCTBuilder.m
//  FactoryKit
//
//  Created by Tomoki Aonuma on 12/3/13.
//  Copyright (c) 2013 exsen.org. All rights reserved.
//

#import "FCTBuilder.h"

#import "../External/CTBlockDescription.h"
#import "FCTDefinition.h"
#import "FCTDefinition_Private.h"

@interface FCTBuilder ()

@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *entityName;
@property (nonatomic, readwrite) FCTDefinition *definition;

@property (nonatomic) NSUInteger sequenceNumber;

@end

@implementation FCTBuilder

- (instancetype)initWithName:(NSString *)name entityName:(NSString *)entityName builderBlock:(FCTBuilderBlock)builderBlock
{
  self = [super init];
  if (!self) return nil;

  _name = name;
  _entityName = entityName;

  FCTDefinition *definition = [[FCTDefinition alloc] init];
  builderBlock(definition);
  [definition freeze];
  _definition = definition;

  return self;
}

- (NSManagedObject *)buildObjectInManagedObjectContext:(NSManagedObjectContext *)context
{
  self.sequenceNumber++;

  NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:context];
  [self setUpManagedObject:object];

  if (self.definition.afterBuild) self.definition.afterBuild(object);

  return object;
}

- (NSManagedObject *)createObjectInManagedObjectContext:(NSManagedObjectContext *)context
{
  NSManagedObject *object = [self buildObjectInManagedObjectContext:context];
  [context save:NULL];

  if (self.definition.afterCreate) self.definition.afterCreate(object);

  return object;
}

- (void)setUpManagedObject:(NSManagedObject *)object
{
  static FCTDeferredDefBlock deferredDefBlock = ^id { return nil; };
  static FCTSequentialDefBlock sequentialDefBlock = ^id(NSUInteger u) { return nil; };
  static NSMethodSignature *deferredDefBlockSig;
  static NSMethodSignature *sequentialDefBlockSig;

  if (!deferredDefBlockSig || !sequentialDefBlockSig) {
    deferredDefBlockSig = [[CTBlockDescription alloc] initWithBlock:deferredDefBlock].blockSignature;
    sequentialDefBlockSig = [[CTBlockDescription alloc] initWithBlock:sequentialDefBlock].blockSignature;
  }

  for (id key in self.definition.objectsByKey.allKeys) {
    id value = self.definition.objectsByKey[key];

    if ([value isKindOfClass:NSClassFromString(@"NSBlock")]) {
      NSMethodSignature *sig = [[CTBlockDescription alloc] initWithBlock:value].blockSignature;
      if ([sig isEqual:deferredDefBlockSig]) {
        value = ((FCTDeferredDefBlock)value)();
      }
      else if ([sig isEqual:sequentialDefBlockSig]) {
        value = ((FCTSequentialDefBlock)value)(self.sequenceNumber);
      }
      else {
        // Unknown signature.
        continue;
      }
    }

    [object setValue:value forKey:key];
  }
}

@end


