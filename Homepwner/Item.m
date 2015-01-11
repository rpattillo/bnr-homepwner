//
//  Item.m
//  RandomItems
//
//  Created by Ricky Pattillo on 12/11/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import "Item.h"

@implementation Item

#pragma mark - Class methods

+ (instancetype)randomItem
{
   NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
   NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
   NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
   NSInteger nounIndex = arc4random() % [randomNounList count];
   NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                           randomAdjectiveList[adjectiveIndex],
                           randomNounList[nounIndex]];
   
   int randomValue = arc4random() % 100;
   
   NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                   '0' + arc4random() % 10,
                                   'A' + arc4random() % 26,
                                   '0' + arc4random() % 10,
                                   'A' + arc4random() % 26,
                                   '0' + arc4random() % 10];
   
   Item *newItem = [[self alloc] initWithItemName:randomName
                                   valueInDollars:randomValue
                                     serialNumber:randomSerialNumber];
   return newItem;
   
}


#pragma mark - Initializers

// Designated Initializer
- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
   self = [super init];
   if ( self ) {
      _itemName = name;
      _serialNumber = sNumber;
      _valueInDollars = value;
      _dateCreated = [[NSDate alloc] init];
      
      NSUUID *uuid = [[NSUUID alloc] init];
      NSString *key = [uuid UUIDString];
      _itemKey = key;
   }
   
   return self;
}


- (instancetype)initWithItemName:(NSString *)name
{
   return [self initWithItemName:(NSString *)name valueInDollars:0 serialNumber:@""];
}


- (instancetype)init
{
   return [self initWithItemName:@"Item"];
}


#pragma mark - Overrides

- (NSString *)description
{
   NSString *description = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
                            self.itemName,
                            self.serialNumber,
                            self.valueInDollars,
                            self.dateCreated];
   return description;
}


- (void)dealloc
{
   NSLog(@"Destroying: %@", self);
}


#pragma mark - NSCoding protocol

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
   self = [super init];
   if (self) {
      _itemName = [aDecoder decodeObjectForKey:@"itemName"];
      _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
      _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
      _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];

      _valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
   }

   return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
   [aCoder encodeObject:self.itemName forKey:@"itemName"];
   [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
   [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
   [aCoder encodeObject:self.itemKey forKey:@"itemKey"];

   [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
}

@end
