//
//  FCTFactory.m
//  FactoryKit
//
//  Created by Tomoki Aonuma on 12/3/13.
//  Copyright (c) 2013 exsen.org. All rights reserved.
//

#import "FCTFactory.h"

#import "FCTBuilder.h"

@interface FCTFactory ()

@property (nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) NSMutableDictionary *builderRegistry;

@end

@implementation FCTFactory

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
  NSParameterAssert(context != nil);

  self = [super init];
  if (!self) return nil;

  _managedObjectContext = context;
  _builderRegistry = [[NSMutableDictionary alloc] init];

  return self;
}

- (void)defineBuilderForEntityForName:(NSString *)entityName usingBlock:(FCTBuilderBlock)builderBlock
{
  [self defineBuilderNamed:entityName forEntityForName:entityName usingBlock:builderBlock];
}

- (void)defineBuilderNamed:(NSString *)builderName forEntityForName:(NSString *)entityName usingBlock:(FCTBuilderBlock)builderBlock
{
  NSParameterAssert(builderName != nil);
  NSParameterAssert(entityName != nil);
  NSParameterAssert(builderBlock != nil);

  FCTBuilder *builder = [[FCTBuilder alloc] initWithName:builderName entityName:entityName builderBlock:builderBlock];
  self.builderRegistry[builderName] = builder;
}

- (NSManagedObject *)buildManagedObjectUsingBuilderNamed:(NSString *)builderName
{
  NSParameterAssert(builderName != nil);

  FCTBuilder *builder = self.builderRegistry[builderName];
  NSManagedObject *object = [builder buildObjectInManagedObjectContext:self.managedObjectContext];

  return object;
}

- (NSManagedObject *)createManagedObjectUsingBuilderNamed:(NSString *)builderName
{
  NSParameterAssert(builderName != nil);

  FCTBuilder *builder = self.builderRegistry[builderName];
  NSManagedObject *object = [builder createObjectInManagedObjectContext:self.managedObjectContext];

  return object;
}

@end
