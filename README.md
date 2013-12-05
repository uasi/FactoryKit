# FactoryKit

## Installation

FactoryKit is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "FactoryKit"

## Usage

```objc
#import <FactoryKit/FactoryKit.h>

...

- (void)setUpObjects {
  NSManagedObjectContext *context = ...;
  FCTFactory *factory = [[FCTFactory alloc] initWithManagedObjectContext:context];

  // Define a builder for an entity.
  [factory defineBuilderForEntityForName:@"Person" usingBlock:^(FCTDefinition *def) {
    def[@"name"] = @"Bob";
  }];

  // Generate a saved object.
  NSManagedObject *person1 = [factory createManagedObjectUsingBuilderNamed:@"Person"];
  NSAssert([[person1 valueForKey:@"name"] isEqualToString:@"Bob"], @"");
  NSAssert(![person1 hasChanges], @"");

  // Or unsaved.
  NSManagedObject *person2 = [factory buildManagedObjectUsingBuilderNamed:@"Person"];
  NSAssert([[person2 valueForKey:@"name"] isEqualToString:@"Bob"], @"");
  NSAssert( [person2 hasChanges], @"");

  // Give a builder a name.
  [factory defineBuilderNamed:@"Mac" forEntityForName:@"Product" usingBlock:^(FCTDefinition *def) {
    // Deferred definition.
    def[@"builtAt"] = ^{ return [NSDate date]; };

    // Sequential definition (n = 1, 2, ...).
    def[@"serialNo"] = ^id(NSUInteger n) { return @(n); };

    // And callbacks.
    [def afterBuild:^(NSManagedObject *builtObject) {
      doSomething(builtObject);
    }];

    [def afterCreate:^(NSManagedObject *createdObject) {
      oneMoreThing(createdObject);
    }];
  }];

  NSDate *beforeCreation = [NSDate date];
  NSManagedObject *mac1 = [factory createManagedObjectUsingBuilderNamed:@"Mac"];
  NSManagedObject *mac2 = [factory createManagedObjectUsingBuilderNamed:@"Mac"];

  // Deferred definitions are evaluated every time you create an object.
  NSAssert([beforeCreation compare:[mac1 valueForKey:@"builtAt"]] == NSOrderedAscending, @"");
  NSAssert([[mac1 valueForKey:@"builtAt"] compare:[mac2 valueForKey:@"builtAt"]] == NSOrderedAscending, @"");

  // Same, with sequence number.
  NSAssert([[mac1 valueForKey:@"serialNo"] isEqualToNumber:@1], @"");
  NSAssert([[mac2 valueForKey:@"serialNo"] isEqualToNumber:@2], @"");
}
```

## Author

Tomoki Aonuma ([@uasi](https://twitter.com/uasi))

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Feature requests and bug reports are welcome. Feel free to submit an issue or
contact the author on Twitter.

## License

FactoryKit is available under the MIT license. See the LICENSE file for more info.
