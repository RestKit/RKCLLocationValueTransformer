//
//  RKCLLocationValueTransformer.m
//  RestKit
//
//  Created by Blake Watters on 9/11/13.
//  Copyright (c) 2013 RestKit. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "RKCLLocationValueTransformer.h"

@interface RKCLLocationValueTransformer ()

@property (nonatomic, copy) NSString *latitudeKey;
@property (nonatomic, copy) NSString *longitudeKey;

@end

@implementation RKCLLocationValueTransformer

+ (instancetype)locationValueTransformerWithLatitudeKey:(NSString *)latitudeKey longitudeKey:(NSString *)longitudeKey
{
    RKCLLocationValueTransformer *locationValueTransformer = [self new];
    locationValueTransformer.latitudeKey = latitudeKey;
    locationValueTransformer.longitudeKey = longitudeKey;
    return locationValueTransformer;
}

- (BOOL)validateTransformationFromClass:(Class)inputValueClass toClass:(Class)outputValueClass
{
    return ([inputValueClass isSubclassOfClass:[NSDictionary class]] && [outputValueClass isSubclassOfClass:[CLLocation class]])
    || ([inputValueClass isSubclassOfClass:[CLLocation class]] && [outputValueClass isSubclassOfClass:[NSDictionary class]]);
}

- (BOOL)transformValue:(id)inputValue toValue:(id *)outputValue ofClass:(Class)outputValueClass error:(NSError **)error
{
    RKValueTransformerTestInputValueIsKindOfClass(inputValue, (@[ [NSDictionary class], [CLLocation class] ]), error);
    RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputValueClass, (@[ [NSDictionary class], [CLLocation class] ]), error);
    if ([outputValueClass isSubclassOfClass:[CLLocation class]]) {
        NSNumber *latitudeNumber = [inputValue valueForKey:self.latitudeKey];
        RKValueTransformerTestTransformation(latitudeNumber, error, @"Failed to find a latitude value for key '%@'", latitudeNumber);
        RKValueTransformerTestInputValueIsKindOfClass(latitudeNumber, (@[ [NSNumber class], [NSString class] ]), error);
        NSNumber *longitudeNumber = [inputValue valueForKey:self.longitudeKey];
        RKValueTransformerTestTransformation(longitudeNumber, error, @"Failed to find a longitude value for key '%@'", longitudeNumber);
        RKValueTransformerTestInputValueIsKindOfClass(longitudeNumber, (@[ [NSNumber class], [NSString class] ]), error);
        *outputValue = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[latitudeNumber doubleValue]
                                                  longitude:(CLLocationDegrees)[longitudeNumber doubleValue]];
    } else if ([outputValueClass isSubclassOfClass:[NSDictionary class]]) {
        *outputValue = @{ self.latitudeKey : @([inputValue coordinate].latitude),
                          self.longitudeKey: @([inputValue coordinate].longitude) };
    }
    return YES;
}

@end
