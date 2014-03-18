//
// Created by Eli Greenfeld on 3/18/14.
//

#import <objc/runtime.h>
#import "JSONModel+ArchiveProperty.h"


@implementation JSONModel (ArchiveProperty)
- (NSArray *)keysForEncoding;
{
    NSMutableArray *propList = [NSMutableArray array];
    unsigned int numProps = 0;
    unsigned int i = 0;

    objc_property_t *props = class_copyPropertyList([self class], &numProps);
    for (i = 0; i < numProps; i++) {
        NSString *prop = [NSString stringWithUTF8String:property_getName(props[i])];
        [propList addObject:prop];
    }

    return [propList copy];
}

// we are being created based on what was archived earlier
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        for (NSString *key in self.keysForEncoding)
        {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

// we are asked to be archived, encode all our data
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in self.keysForEncoding)
    {
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}
@end