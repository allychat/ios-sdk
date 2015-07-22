//
//  ACOperatorModel.m
//
//  Created by Александр Турьев on 18/07/15
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import "ACOperatorModel.h"


NSString *const kACOperatorModelName = @"name";
NSString *const kACOperatorModelTags = @"tags";
NSString *const kACOperatorModelId = @"id";
NSString *const kACOperatorModelIsAdmin = @"is_admin";
NSString *const kACOperatorModelIsOperator = @"is_operator";
NSString *const kACOperatorModelIsObserver = @"is_observer";
NSString *const kACOperatorModelAvatarUrl = @"avatar_url";
NSString *const kACOperatorModelLogin = @"login";


@interface ACOperatorModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ACOperatorModel

@synthesize name = _name;
@synthesize tags = _tags;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize isAdmin = _isAdmin;
@synthesize isOperator = _isOperator;
@synthesize isObserver = _isObserver;
@synthesize avatarUrl = _avatarUrl;
@synthesize login = _login;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.name = [self objectOrNilForKey:kACOperatorModelName fromDictionary:dict];
            self.tags = [self objectOrNilForKey:kACOperatorModelTags fromDictionary:dict];
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kACOperatorModelId fromDictionary:dict];
            self.isAdmin = [[self objectOrNilForKey:kACOperatorModelIsAdmin fromDictionary:dict] doubleValue];
            self.isOperator = [[self objectOrNilForKey:kACOperatorModelIsOperator fromDictionary:dict] doubleValue];
            self.isObserver = [[self objectOrNilForKey:kACOperatorModelIsObserver fromDictionary:dict] doubleValue];
            self.avatarUrl = [self objectOrNilForKey:kACOperatorModelAvatarUrl fromDictionary:dict];
            self.login = [self objectOrNilForKey:kACOperatorModelLogin fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kACOperatorModelName];
    NSMutableArray *tempArrayForTags = [NSMutableArray array];
    for (NSObject *subArrayObject in self.tags) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTags addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTags addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTags] forKey:kACOperatorModelTags];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kACOperatorModelId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isAdmin] forKey:kACOperatorModelIsAdmin];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isOperator] forKey:kACOperatorModelIsOperator];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isObserver] forKey:kACOperatorModelIsObserver];
    [mutableDict setValue:self.avatarUrl forKey:kACOperatorModelAvatarUrl];
    [mutableDict setValue:self.login forKey:kACOperatorModelLogin];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.name = [aDecoder decodeObjectForKey:kACOperatorModelName];
    self.tags = [aDecoder decodeObjectForKey:kACOperatorModelTags];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kACOperatorModelId];
    self.isAdmin = [aDecoder decodeDoubleForKey:kACOperatorModelIsAdmin];
    self.isOperator = [aDecoder decodeDoubleForKey:kACOperatorModelIsOperator];
    self.isObserver = [aDecoder decodeDoubleForKey:kACOperatorModelIsObserver];
    self.avatarUrl = [aDecoder decodeObjectForKey:kACOperatorModelAvatarUrl];
    self.login = [aDecoder decodeObjectForKey:kACOperatorModelLogin];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kACOperatorModelName];
    [aCoder encodeObject:_tags forKey:kACOperatorModelTags];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kACOperatorModelId];
    [aCoder encodeDouble:_isAdmin forKey:kACOperatorModelIsAdmin];
    [aCoder encodeDouble:_isOperator forKey:kACOperatorModelIsOperator];
    [aCoder encodeDouble:_isObserver forKey:kACOperatorModelIsObserver];
    [aCoder encodeObject:_avatarUrl forKey:kACOperatorModelAvatarUrl];
    [aCoder encodeObject:_login forKey:kACOperatorModelLogin];
}

- (id)copyWithZone:(NSZone *)zone
{
    ACOperatorModel *copy = [[ACOperatorModel alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.tags = [self.tags copyWithZone:zone];
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.isAdmin = self.isAdmin;
        copy.isOperator = self.isOperator;
        copy.isObserver = self.isObserver;
        copy.avatarUrl = [self.avatarUrl copyWithZone:zone];
        copy.login = [self.login copyWithZone:zone];
    }
    
    return copy;
}


@end
