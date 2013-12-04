//
//  FCTDefinition.m
//  FactoryKit
//
//  Created by Tomoki Aonuma on 12/3/13.
//  Copyright (c) 2013 exsen.org. All rights reserved.
//

#import "FCTDefinition.h"
#import "FCTDefinition_Private.h"

@implementation FCTDefinition

- (instancetype)init
{
  self = [super init];
  if (!self) return nil;
  _objectsByKey = [NSMutableDictionary dictionary];
  return self;
}

- (void)afterBuild:(FCTAfterBlock)afterBuild
{
  self.afterBuild = afterBuild;
}

- (void)afterCreate:(FCTAfterBlock)afterCreate
{
  self.afterCreate = afterCreate;
}

- (id)objectForKeyedSubscript:(id)key
{
  return self.objectsByKey[key];
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key
{
  if (_frozen) [self doesNotRecognizeSelector:_cmd];

  self.objectsByKey[key] = object;
}

- (void)freeze
{
  _frozen = YES;
}

@end
