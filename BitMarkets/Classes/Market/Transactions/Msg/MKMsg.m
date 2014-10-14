//
//  MKMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/2/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKMsg.h"
#import "MKRootNode.h"
#import "MKBuy.h"
#import "MKSell.h"

@implementation MKMsg

+ (NSString *)serviceName
{
    return @"bitmarket";
}

+ (NSString *)serviceVersion
{
    return @"0.8";
}

+ (MKMsg *)withBMMessage:(BMMessage *)bmMessage
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithJsonString:bmMessage.messageString];
    
    NSString *typeName = [dict objectForKey:@"_type"];
    if (!typeName)
    {
        NSLog(@"invalid message - has no _type");
        return nil;
    }
    
    NSString *className = [@"MK" stringByAppendingString:typeName];
    Class class = NSClassFromString(className);
    if (!class || ![class isSubclassOfClass:MKMsg.class])
    {
        NSLog(@"invalid message - no msg class");
        return nil;
    }
    
    /*
    if (![[dict objectForKey:@"_serviceName"] isEqualToString:self.class.serviceName])
    {
        NSLog(@"invalid message - serviceName doesn't match");
        return nil;
    }
    
    if (![[dict objectForKey:@"_serviceVersion"] isEqualToString:self.class.serviceVersion])
    {
        NSLog(@"invalid message - _serviceVersion doesn't match");
        return nil;
    }
    */
    
    MKMsg *msg = [[class alloc] init];
    msg.dict = dict;
    msg.bmMessage = bmMessage;
    //msg.ackData = bmMessage.ackData; // do we need this for received messages?
    
    if (!msg.isValid)
    {
        return nil;
    }
    
    [msg setDate:bmMessage.date];
    
    return msg;
}

- (id)init
{
    self = [super init];
    //NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //[dict setObject:self.classNameSansPrefix forKey:@"_type"];
    //[dict setObject:self.class.serviceName forKey:@"_serviceName"];
    //[dict setObject:self.class.serviceVersion forKey:@"_serviceVersion"];
    //[self setDict:dict];
    //[self addPropertyName:@"serviceName"];
    //[self addPropertyName:@"serviceVersion"];
    [self addPropertyName:@"ackData"];
    [self addPropertyName:@"payload"];
    [self addPropertyName:@"postUuid"];
    [self addPropertyName:@"sellerAddress"];
    [self addPropertyName:@"buyerAddress"];
    [self addPropertyName:@"dateNumber"];
    [self addDate];
    
    self.nodeViewClass = NavDescriptionView.class;
    self.debug = NO;
    
    return self;
}

- (void)setPayload:(NSDictionary *)aDict
{
    _payload = aDict;
    [self setIsDirty:YES];
}

- (BOOL)bmSenderIsBuyer // only works when first received
{
    return [self.bmMessage.fromAddress isEqualToString:self.buyerAddress];
}

- (BOOL)bmSenderIsSeller // only works when first received
{
    return [self.bmMessage.fromAddress isEqualToString:self.sellerAddress];
}

- (NSString *)classNameSansPrefix
{
    return [self.className sansPrefix:@"MK"];
}

- (id)descriptionJSONObject
{
    return self.dict;
}

/*
- (NSArray *)modelActions
{
    return @[@"resend"];
}
*/

// equality

- (NSString *)uniqueName
{
    return [NSString stringWithFormat:@"%@ %@",
            NSStringFromClass(self.class), self.postUuid];
}

- (NSUInteger)hash
{
    return self.uniqueName.hash;
}

- (BOOL)isEqual:(id)object
{
    if ([object respondsToSelector:@selector(uniqueName)])
    {
        BOOL isEqual = [self.uniqueName isEqualToString:((MKMsg *)object).uniqueName];
        return isEqual;
    }
    
    return self.class == ((NSObject *)object).class;
}

// node

- (void)addDate
{
    [self setDate:[NSDate date]];
}

- (void)setDate:(NSDate *)aDate
{
    NSNumber *d = [NSNumber numberWithDouble:[aDate timeIntervalSince1970]];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)d.doubleValue];
    assert([aDate.description isEqualToString:newDate.description]);

    self.dateNumber = d;
}


- (NSDate *)date
{
    NSNumber *d = self.dateNumber;
    
    if (d)
    {
        return [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)d.doubleValue];
    }
    
    return nil;
}

- (NSString *)dateString
{
    NSDate *date = self.date;
    
    if (date)
    {
        return [date itemDateTimeString];
    }
    
    return @"[Date missing]";
}


- (NSString *)nodeTitle
{
    return self.uniqueName;
}

- (BOOL)wasSent
{
    BMSentMessage *sentMessage = self.sentMessage;
    
    return (sentMessage && sentMessage.wasSent);
}

- (NSString *)nodeSubtitle
{
    BMSentMessage *sentMessage = self.sentMessage;
    
    if (sentMessage && !sentMessage.wasSent)
    {
        [self checkStatusUntilSent];
        return @"sending...";
        //return sentMessage.getHumanReadbleStatus;
        //return [NSString stringWithFormat:@"%@ (%@)", self.dateString, sentMessage.getStatus];
    }
    
    return [NSString stringWithFormat:@"sent %@", self.dateString];
    //return self.dateString;
}

- (void)checkStatusUntilSent
{
    if (self.sentMessage.wasSent)
    {
        [self postParentChainChanged];
    }
    else
    {
        [self performSelector:@selector(checkStatusUntilSent) withObject:nil afterDelay:2.0];
    }
}

- (BOOL)hasValidPostUuid
{
    return (self.postUuid && self.postUuid.length > 10);
}

- (BOOL)hasValidSellerAddress
{
    return [BMAddress isValidAddress:self.sellerAddress];
}

- (BOOL)isValid
{
    // subclasses should override and add validation
    // that checks appropriate bmSenderIsSeller/bmSenderIsBuyer method
    
    BOOL validUuid   = self.hasValidPostUuid;
    BOOL validSeller = self.hasValidSellerAddress;
    BOOL validBuyer  = self.hasValidSellerAddress;
    
    return validUuid && validSeller && validBuyer;
}

- (NSString *)myAddress
{
    return MKRootNode.sharedMKRootNode.bmClient.identities.firstIdentity.address;
}

- (NSString *)subject
{
    return [NSString stringWithFormat:@"%@ on %@",
            self.classNameSansPrefix,
            self.postUuid];
}

// copy

- (void)copyThreadFrom:(MKMsg *)msg
{
    self.sellerAddress = msg.sellerAddress;
    self.buyerAddress  = msg.buyerAddress;
    self.postUuid      = msg.postUuid;
}

// ------------------------

- (BOOL)send
{
    [NSException raise:@"subclasses should override send" format:nil];
    return NO;
}

- (void)resend
{
    [self send];
}

- (NSString *)channelAddress
{
    return MKRootNode.sharedMKRootNode.markets.mkChannel.channel.address;
}

- (BOOL)sendFromSellerToChannel
{
    BMMessage *m = [[BMMessage alloc] init];
    [m setToAddress:self.channelAddress];
    [m setFromAddress:self.sellerAddress];
    [m setSubject:self.subject];
    [m setMessage:self.dict.asJsonString];
    
    if (self.debug)
    {
        [m show];
    }

    //NSLog(@"sending from %@ to channel %@", m.fromAddress, m.toAddress);
    
    [m send];
    
    self.ackData = m.ackData;
    [self addDate];
    //NSLog(@"sending from %@ to channel %@ ackData %@", m.fromAddress, m.toAddress, self.ackData);
    
    
    [self addDate];
    
    return self.ackData != nil;
}

- (BOOL)sendToBuyer
{
    BMMessage *m = [[BMMessage alloc] init];
    [m setToAddress:self.buyerAddress];
    [m setFromAddress:self.sellerAddress];
    [m setSubject:self.subject];
    [m setMessage:self.dict.asJsonString];
    [m send];

    if (self.debug)
    {
        [m show];
    }
    
    self.ackData = m.ackData;
    
    [self addDate];

    if (!self.ackData)
    {
        NSLog(@"ERROR: no ack for msg send");
    }
    
    return self.ackData != nil;
}

- (BOOL)sendToSeller
{
    BMMessage *m = [[BMMessage alloc] init];
    [m setToAddress:self.sellerAddress];
    [m setFromAddress:self.buyerAddress];
    [m setSubject:self.subject];
    [m setMessage:self.dict.asJsonString];
    [m send];

    if (self.debug)
    {
        [m show];
    }
    
    self.ackData = m.ackData;

    [self addDate];

    if (!self.ackData)
    {
        NSLog(@"ERROR: no ack for msg send");
    }
    
    return self.ackData != nil;
}

- (BOOL)isInBuy
{
    return [self inParentChainHasClass:MKBuy.class];
}

- (BOOL)isInSell
{
    return [self inParentChainHasClass:MKSell.class];
}

- (BMSentMessage *)sentMessage
{
    if (self.ackData)
    {
        BMSentMessage *m = [[BMSentMessage alloc] init];
        m.ackData = self.ackData;
        return m;
    }
    
    return nil;
}

@end
