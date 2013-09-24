RKCLLocationValueTransformer
============================

[![Build Status](https://travis-ci.org/RestKit/RKCLLocationValueTransformer.png?branch=master)](https://travis-ci.org/RestKit/RKCLLocationValueTransformer)
![Pod Version](http://cocoapod-badges.herokuapp.com/v/RKCLLocationValueTransformer/badge.png)
![Pod Platform](http://cocoapod-badges.herokuapp.com/p/RKCLLocationValueTransformer/badge.png)

**An `RKValueTransforming` compliant class for transforming values between `NSDictionary` and `CLLocation` representations of a geographic coordinate.**

RKCLLocationValueTransformer is simple class that provides for the transformation of geographic coordiante data between `NSDictionary` and `CLLocation` representations. It is built on top of the [RKValueTransformers](https://github.com/RestKit/RKValueTransformers) and is designed for use with [RestKit](https://github.com/RestKit/RestKit). The transformer is initialized with a set of keys specifying how the latitude and longitude are stored within a dictionary. Once the transformer is registered with RestKit you can transparently object map `CLLocation` values when interacting with a web services API.

## Examples

### Usage

Basic usage is identical to all other `RKValueTransforming` classes.

```objc
#import "RKCLLocationValueTransformer.h"

RKCLLocationValueTransformer *locationValueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];

// Transforming NSDictionary -> CLLocation
CLLocation *location = nil;
NSError *error = nil;
BOOL success = [locationValueTransformer transformValue:@{ @"latitude": @"40.7680", @"longitude": @"73.9819" } toValue:&location ofClass:[CLLocation class] error:&error];

// Transforming CLLocation -> NSDictionary
NSDictionary *dictionary = nil;
CLLocation *location = [[CLLocation alloc] initWithLatitude:40.7680 longitude:73.9819];
success = [valueTransformer transformValue:location toValue:&dictionary ofClass:[NSDictionary class] error:&error];
```

### Registration as a Default Value Transformer

A location transformer can be registered with the default value transformer for global use.

```objc
#import "RKCLLocationValueTransformer.h"

RKCLLocationValueTransformer *locationValueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
[[RKValueTransformer defaultValueTransformer] addValueTransformer:locationValueTransformer];
```

### Integration with RestKit

**Requires RestKit v0.21.0 and up***

The `RKCLLocationValueTransformer` class is primarily designed for use with RestKit to enable the object mapping of coordinate data in an API. To do so you must configure
the `RKAttributeMapping` for the `CLLocation` property to use the value transformer. The examples below detail how to make this configuration.

#### Mapping from JSON to a CLLocation Property

```json
{
    "user": {
        "name": "Blake Watters",
        "location": {
            "latitude": "40.708",
            "longitude": "74.012"
        }
    }
}
```

Given the above JSON, you could configure an object mapping and request descriptor to access the data as follows:

```objc
#import "RKCLLocationValueTransformer.h"

@interface User : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) CLLocation *location;
@end

RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
[userMapping addAttributeMappingsFromArray:@[ @"name" ]];
RKAttributeMapping *attributeMapping = [RKAttributeMapping attributeMappingFromKeyPath:@"location" toKeyPath:@"location"];
attributeMapping.valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
[userMapping addPropertyMapping:attributeMapping];

RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"user" statusCodes:[NSIndexSet indexSetWithIndex:200]];
```

Upon successful completion of the request, an instance of the `User` object would be created and the `name` attribute would equal `@"Blake Watters"` and the `location` attribute would be a `CLLocation` instance
whose `latitude` and `longitude` properties are equal to `40.708` and `74.012` respectively.

#### Mapping from a CLLocation Property to HTTP Parameters

Mapping from your local domain object back into an `NSDictionary` for use with a `PUT`, `POST`, or `PATCH` operation requires slightly more configuration. Because there are no type hints availabe when mapping
from a local object into an `NSDictionary` (as there are no properties to introspect) we must explicitly tell RestKit how we want the `CLLocation` object represented so that the value transformer can handle it:

```objc
RKObjectMapping *userRequestMapping = [RKObjectMapping requestMapping];
[userRequestMapping addAttributeMappingsFromArray:@[ @"name" ]];
RKAttributeMapping *attributeMapping = [RKAttributeMapping attributeMappingFromKeyPath:@"location" toKeyPath:@"location"];
attributeMapping.propertyValueClass = [NSDictionary class];
attributeMapping.valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
[userRequestMapping addPropertyMapping:attributeMapping];

NSError *error = nil;
RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:userRequestMapping objectClass:[User class] rootKeyPath:@"user" method:RKRequestMethodAny];
```

Upon performing a `POST` or `PUT` of the `User` object you would wind up with a JSON or URL form-encoded representation that matches the original JSON example given above.

## Credits

Blake Watters

- http://github.com/blakewatters
- http://twitter.com/blakewatters
- blakewatters@gmail.com

## License

RKCLLocationValueTransformer is available under the Apache 2 License. See the LICENSE file for more info.
