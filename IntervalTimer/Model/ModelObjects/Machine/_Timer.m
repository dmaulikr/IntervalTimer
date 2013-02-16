//
//  _Timer.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Timer.h instead.
//


#import "_Timer.h"

NSString * const kModelPropertyTimerName = @"name";
NSString * const kModelPropertyTimerRestInterval = @"restInterval";
NSString * const kModelPropertyTimerStartTime = @"startTime";
NSString * const kModelPropertyTimerWorkInterval = @"workInterval";

@interface _Timer()
@end

/** \ingroup DataModel */

NS_INLINE NSMutableSet* NonretainingNSMutableSetMake()
{
    CFSetCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual, CFHash};
    return (__bridge NSMutableSet*) CFSetCreateMutable(0, 0, &callbacks);
}

@implementation _Timer
+ (NSSet *)dictionaryRepresentationKeys
{
    NSMutableSet *set = [NSMutableSet setWithSet:[super dictionaryRepresentationKeys]];
    
	  [set addObject:kModelPropertyTimerName];
	  [set addObject:kModelPropertyTimerRestInterval];
	  [set addObject:kModelPropertyTimerStartTime];
	  [set addObject:kModelPropertyTimerWorkInterval];
    
    return [NSSet setWithSet:set];
}

- (id)init
{
    if((self = [super init]))
    {
    }
    
    return self;
}

- (id) initWithCoder: (NSCoder*) aDecoder
{
    if ([[super class] instancesRespondToSelector: @selector(initWithCoder:)]) {
        self = [super initWithCoder: aDecoder];
    } else {
        self = [super init];
    }
    if (self) {
        self.name = [aDecoder decodeObjectForKey: kModelPropertyTimerName];
        self.restInterval = [aDecoder decodeObjectForKey: kModelPropertyTimerRestInterval];
        self.startTime = [aDecoder decodeObjectForKey: kModelPropertyTimerStartTime];
        self.workInterval = [aDecoder decodeObjectForKey: kModelPropertyTimerWorkInterval];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    [aCoder encodeObject: self.name forKey: kModelPropertyTimerName];
    [aCoder encodeObject: self.restInterval forKey: kModelPropertyTimerRestInterval];
    [aCoder encodeObject: self.startTime forKey: kModelPropertyTimerStartTime];
    [aCoder encodeObject: self.workInterval forKey: kModelPropertyTimerWorkInterval];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        self.name = [dictionary objectForKey:kModelPropertyTimerName];
        self.restInterval = [dictionary objectForKey:kModelPropertyTimerRestInterval];
        self.startTime = [dictionary objectForKey:kModelPropertyTimerStartTime];
        self.workInterval = [dictionary objectForKey:kModelPropertyTimerWorkInterval];
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.name forKey:kModelPropertyTimerName];
    [dict setObjectIfNotNil:self.restInterval forKey:kModelPropertyTimerRestInterval];
    [dict setObjectIfNotNil:self.startTime forKey:kModelPropertyTimerStartTime];
    [dict setObjectIfNotNil:self.workInterval forKey:kModelPropertyTimerWorkInterval];
    return dict;
}

#pragma mark Direct access


//scalar setter and getter support
- (int32_t)restIntervalValue {
    NSNumber *result = [self restInterval];
    return [result intValue];
}

- (void)setRestIntervalValue:(int32_t)value_ {
    [self setRestInterval:[NSNumber numberWithInt:value_]];
}
- (int32_t)workIntervalValue {
    NSNumber *result = [self workInterval];
    return [result intValue];
}

- (void)setWorkIntervalValue:(int32_t)value_ {
    [self setWorkInterval:[NSNumber numberWithInt:value_]];
}

#pragma mark Synthesizes

@synthesize name;
@synthesize restInterval;
@synthesize startTime;
@synthesize workInterval;

@end