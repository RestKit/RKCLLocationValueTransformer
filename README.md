RKCLLocationValueTransformer
====================================

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

## Credits

Blake Watters

- http://github.com/blakewatters
- http://twitter.com/blakewatters
- blakewatters@gmail.com

## License

RKCLLocationValueTransformer is available under the Apache 2 License. See the LICENSE file for more info.
