//
//  MKMessage.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKMessage.h"
#import "MKRootNode.h"


@implementation MKMessage

//@synthetize instance = _instance;

+ (NSString *)serviceName
{
    return @"bitmarket";
}

+ (NSString *)serviceVersion
{
    return @"1.0";
}

+ (NSMutableDictionary *)standardHeader
{
    /*
    {
        header:
        {
            service: "bitmarket",
            version: "1.0",
            type: "AskMessage"
        },
        ...
    }
    */
    
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setObject:self.class.serviceName forKey:@"service"];
    [header setObject:self.class.serviceVersion forKey:@"version"];
    return header;
}

+ (NSSet *)typeClassNames
{
    NSSet *names = [NSSet setWithObjects:
                    @"Sell",
                    @"Bid",
                    /*
                    @"Accept",
                    @"Delivery",
                    @"Comment",
                    @"RequestRefund",
                    @"Sent",
                    */
                    nil];
    return names;
}

- (NSString *)nodeTitle
{
    //return NSStringFromClass([self class]);
    return [self.headerDict objectForKey:@"type"];
}

- (NSString *)nodeSubtitle
{
    //return self.date.description;
    return nil;
}


/*
 {
 header:
 {
 service: "bitmarket",
 version: "1.0",
 type: "AskMessage"
 },
 
 body: { ... }
 }
 */

+ (MKMessage *)withBMMessage:(BMMessage *)bmMessage
{
    MKMessage *message = [[MKMessage alloc] init];
    message.dict = [NSMutableDictionary dictionaryWithJsonString:bmMessage.messageString];
    
    if (message.hasValidHeader)
    {
        message.bmMessage = bmMessage;
        return message;
    }
    
    return nil;
}

- (id)init
{
    self = [super init];
    self.dict = [NSMutableDictionary dictionary];
    [self setHeaderDict:self.class.standardHeader];
    //[self setBodyDict:[NSMutableDictionary dictionary]];
    return self;
}
    
- (BOOL)hasValidHeader
{
    // todo: make a MKMessageHeader class to handle this
    
    NSDictionary *header = self.headerDict;
    if (!header || ![header isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }
    
    BOOL correctService = [[header objectForKey:@"service"] isEqualToString:self.class.serviceName];
    if (!correctService)
    {
        return NO;
    }
    
    BOOL supportedVersion = [[header objectForKey:@"version"] isEqualToString:self.class.serviceVersion];
    if (!supportedVersion)
    {
        return NO;
    }
    
    if (!self.classFromHeader)
    {
        return NO;
    }

    return YES;
}

- (Class)classFromHeader
{
    NSString *type = [self.headerDict objectForKey:@"type"];
    
    if (!type || ![self.class.typeClassNames member:type])
    {
        return nil;
    }
    
    Class msgClass = NSClassFromString([@"MK" stringByAppendingString:type]);
    if (!msgClass)
    {
        return nil;
    }
    
    return msgClass;
}

// instance

- (void)setInstance:(id)anObject
{
    _object = anObject;
    
    NSString *className = NSStringFromClass(((NSObject *)anObject).class);
    NSString *typeName = [className after:@"MK"];
    
    NSMutableDictionary *header = [NSMutableDictionary dictionaryWithDictionary:self.headerDict];
    [header setObject:typeName forKey:@"type"];
    self.headerDict = header;
    self.bodyDict = [anObject messageDict];
}

- (id)instance
{
    if (!_object)
    {
        _object = [[self.classFromHeader alloc] init];
        [_object setMessageDict:self.bodyDict];
    }
    return _object;
}

// header

- (void)setHeaderDict:(NSDictionary *)aDict
{
    [self.dict setObject:aDict forKey:@"header"];
}

- (NSDictionary *)headerDict
{
    return [self.dict objectForKey:@"header"];
}

// body

- (void)setBodyDict:(NSDictionary *)aDict
{
    [self.dict setObject:aDict forKey:@"body"];
}

- (NSDictionary *)bodyDict
{
    return [self.dict objectForKey:@"body"];
}

// json

- (NSString *)jsonString
{
    return self.dict.asJsonString;
}

- (NSString *)channelAddress
{
    return MKRootNode.sharedMKRootNode.markets.mkChannel.channel.address;
}

- (NSString *)myAddress
{
    return MKRootNode.sharedMKRootNode.bmClient.identities.firstIdentity.address;
}

- (void)post
{
    BMMessage *m = [[BMMessage alloc] init];
    [m setFromAddress:self.myAddress];
    [m setToAddress:self.channelAddress];
    [m setSubject:@"bitmarkets"];
    [m setMessage:self.jsonString];
    [m send];
}

@end
