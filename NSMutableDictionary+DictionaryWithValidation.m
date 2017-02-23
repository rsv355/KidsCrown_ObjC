//
//  NSMutableDictionary+DictionaryWithValidation.m
//  Kids Crown
//
//  Created by Hardik Patel on 9/7/15.
//  Copyright (c) 2015 Rahatech. All rights reserved.
//

#import "NSMutableDictionary+DictionaryWithValidation.h"

@implementation NSMutableDictionary (DictionaryWithValidation)


-(id)objectForkeyValidation:(id)strKey
{
    id object = [self objectForKey:strKey];
    
    if (object == nil ) {
        return [NSString stringWithFormat:@""];
;
    }
    if ([object isKindOfClass:[NSString class]]) {
               return object;
    }
    
    if ([object isKindOfClass:[NSNull class]]) {
    
        return @"0";
;
    }
    
    return object;
    
}






@end
