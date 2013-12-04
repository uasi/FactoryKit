//
//  FCTDefinition_Private.h
//  FactoryKit
//
//  Created by Tomoki Aonuma on 12/3/13.
//  Copyright (c) 2013 exsen.org. All rights reserved.
//

#import "FCTDefinition.h"

@interface FCTDefinition ()
{
@private
  BOOL _frozen;
}

@property (nonatomic) NSMutableDictionary *objectsByKey;

@property (nonatomic, copy) FCTAfterBlock afterBuild;
@property (nonatomic, copy) FCTAfterBlock afterCreate;

- (void)freeze;

@end
