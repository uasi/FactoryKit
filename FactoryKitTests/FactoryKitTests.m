//
//  FactoryKitTests.m
//  FactoryKitTests
//
//  Created by Tomoki Aonuma on 12/3/13.
//  Copyright (c) 2013 exsen.org. All rights reserved.
//

#define EXP_SHORTHAND

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import "FactoryKit.h"

SpecBegin(FactoryKit)

__block NSBundle *bundle;
__block NSManagedObjectContext *context;
__block NSManagedObjectModel *model;

beforeAll(^{
  bundle = [NSBundle bundleForClass:[self class]];

  NSURL *modelURL = [bundle URLForResource:@"FactoryKitTests" withExtension:@"momd"];
  model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
});

beforeEach(^{
  NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
  [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL];

  context = [[NSManagedObjectContext alloc] init];
  context.persistentStoreCoordinator = coordinator;
});

describe(@"FCTFactory", ^{
  __block FCTFactory *factory;

  beforeEach(^{
    factory = [[FCTFactory alloc] initWithManagedObjectContext:context];
    [factory defineBuilderForEntityForName:@"Person" usingBlock:^(FCTDefinition *def) {
      def[@"name"] = @"Bob";
    }];
  });

  it(@"builds unsaved object", ^{
    NSManagedObject *person = [factory buildManagedObjectUsingBuilderNamed:@"Person"];

    expect(person).notTo.beNil();
    expect([person valueForKey:@"name"]).to.equal(@"Bob");
    expect(@([person hasChanges])).to.beTruthy();
  });

  it(@"creates saved object", ^{
    NSManagedObject *person = [factory createManagedObjectUsingBuilderNamed:@"Person"];

    expect(person).notTo.beNil();
    expect([person valueForKey:@"name"]).to.equal(@"Bob");
    expect(@([person hasChanges])).to.beFalsy();
  });

  it(@"instantiates unique object for each build", ^{
    NSManagedObject *person1 = [factory buildManagedObjectUsingBuilderNamed:@"Person"];
    NSManagedObject *person2 = [factory buildManagedObjectUsingBuilderNamed:@"Person"];

    expect(person1).notTo.beNil();
    expect(person2).notTo.beNil();
    expect([person1 valueForKey:@"name"]).to.equal(@"Bob");
    expect([person2 valueForKey:@"name"]).to.equal(@"Bob");
    expect(person1).notTo.equal(person2);
  });

  it(@"defers evaluation of deferred def block until building", ^{
    __block BOOL evaluated = NO;

    FCTFactory *factory = [[FCTFactory alloc] initWithManagedObjectContext:context];
    [factory defineBuilderForEntityForName:@"Person" usingBlock:^(FCTDefinition *def) {
      def[@"name"] = ^{
        evaluated = YES;
        return @"Bob";
      };
    }];

    expect(@(evaluated)).to.beFalsy();

    NSManagedObject *person = [factory buildManagedObjectUsingBuilderNamed:@"Person"];

    expect(@(evaluated)).to.beTruthy();
    expect(person).notTo.beNil();
    expect([person valueForKey:@"name"]).to.equal(@"Bob");
  });

  it(@"passes sequence number to sequential def block", ^{
    FCTFactory *factory = [[FCTFactory alloc] initWithManagedObjectContext:context];
    [factory defineBuilderForEntityForName:@"Person" usingBlock:^(FCTDefinition *def) {
      def[@"name"] = ^id(NSUInteger n) {
        return [NSString stringWithFormat:@"Bob %lu", (unsigned long)n];
      };
    }];

    NSManagedObject *person1 = [factory buildManagedObjectUsingBuilderNamed:@"Person"];
    NSManagedObject *person2 = [factory buildManagedObjectUsingBuilderNamed:@"Person"];

    expect(person1).notTo.beNil();
    expect(person2).notTo.beNil();
    expect([person1 valueForKey:@"name"]).to.equal(@"Bob 1");
    expect([person2 valueForKey:@"name"]).to.equal(@"Bob 2");
  });
});

SpecEnd
