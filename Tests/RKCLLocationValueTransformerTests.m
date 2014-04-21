//
//  RKCLLocationValueTransformerTests.m
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

#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import "Expecta.h"
#import "RKCLLocationValueTransformer.h"

@interface RKCLLocationValueTransformerTests : XCTestCase
@end

@implementation RKCLLocationValueTransformerTests

- (void)testValidationFromDictionaryToLocation
{
    RKCLLocationValueTransformer *valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
    BOOL success = [valueTransformer validateTransformationFromClass:[NSDictionary class] toClass:[CLLocation class]];
    expect(success).to.beTruthy();
}

- (void)testValidationFromLocationToDictionary
{
    RKCLLocationValueTransformer *valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
    BOOL success = [valueTransformer validateTransformationFromClass:[CLLocation class] toClass:[NSDictionary class]];
    expect(success).to.beTruthy();
}

- (void)testValidationFailure
{
    RKCLLocationValueTransformer *valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
    BOOL success = [valueTransformer validateTransformationFromClass:[NSURL class] toClass:[NSString class]];
    expect(success).to.beFalsy();
}

- (void)testTransformationFromDictionaryWithNumericKeysToLocation
{
    RKCLLocationValueTransformer *valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
    id value = nil;
    NSError *error = nil;
    BOOL success = [valueTransformer transformValue:@{ @"latitude": @(40.7680), @"longitude": @(73.9819) } toValue:&value ofClass:[CLLocation class] error:&error];
    expect(success).to.beTruthy();
    expect(value).to.beKindOf([CLLocation class]);
    expect([(CLLocation *)value coordinate].latitude).to.equal(40.7680);
    expect([(CLLocation *)value coordinate].longitude).to.equal(73.9819);
}

- (void)testTransformationFromDictionaryWithStringKeysToLocation
{
    RKCLLocationValueTransformer *valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
    id value = nil;
    NSError *error = nil;
    BOOL success = [valueTransformer transformValue:@{ @"latitude": @"40.7680", @"longitude": @"73.9819" } toValue:&value ofClass:[CLLocation class] error:&error];
    expect(success).to.beTruthy();
    expect(value).to.beKindOf([CLLocation class]);
    expect([(CLLocation *)value coordinate].latitude).to.equal(40.7680);
    expect([(CLLocation *)value coordinate].longitude).to.equal(73.9819);
}

- (void)testTransformationFromStringToDAte
{
    RKCLLocationValueTransformer *valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
    id value = nil;
    NSError *error = nil;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:40.7680 longitude:73.9819];
    BOOL success = [valueTransformer transformValue:location toValue:&value ofClass:[NSDictionary class] error:&error];
    expect(success).to.beTruthy();
    expect(value).to.beKindOf([NSDictionary class]);
    expect([value valueForKey:@"latitude"]).to.equal(40.7680);
    expect([value valueForKey:@"longitude"]).to.equal(73.9819);
}

- (void)testTransformationFailureWithUntransformableInputValue
{
    RKCLLocationValueTransformer *valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
    id value = nil;
    NSError *error = nil;
    BOOL success = [valueTransformer transformValue:@[] toValue:&value ofClass:[CLLocation class] error:&error];
    expect(success).to.beFalsy();
    expect(value).to.beNil();
    expect(error).notTo.beNil();
    expect(error.domain).to.equal(RKValueTransformersErrorDomain);
    expect(error.code).to.equal(RKValueTransformationErrorUntransformableInputValue);
}

- (void)testTransformationFailureFailureWithInvalidInputValue
{
    RKCLLocationValueTransformer *valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
    id value = nil;
    NSError *error = nil;
    BOOL success = [valueTransformer transformValue:@{} toValue:&value ofClass:[CLLocation class] error:&error];
    expect(success).to.beFalsy();
    expect(value).to.beNil();
    expect(error).notTo.beNil();
    expect(error.domain).to.equal(RKValueTransformersErrorDomain);
    expect(error.code).to.equal(RKValueTransformationErrorTransformationFailed);
}

- (void)testTransformationFailureFailureWithInvalidInputValueForLatitudeKey
{
    RKCLLocationValueTransformer *valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
    id value = nil;
    NSError *error = nil;
    BOOL success = [valueTransformer transformValue:@{ @"latitude": @[], @"longitude": @"12345" } toValue:&value ofClass:[CLLocation class] error:&error];
    expect(success).to.beFalsy();
    expect(value).to.beNil();
    expect(error).notTo.beNil();
    expect(error.domain).to.equal(RKValueTransformersErrorDomain);
    expect(error.code).to.equal(RKValueTransformationErrorUntransformableInputValue);
    expect([error localizedDescription]).to.equal(@"Expected an `inputValue` of type `(\n    NSNumber,\n    NSString\n)`, but got a `__NSArrayI`.");
}

- (void)testTransformationFailureFailureWithInvalidInputValueForLongitudeKey
{
    RKCLLocationValueTransformer *valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
    id value = nil;
    NSError *error = nil;
    BOOL success = [valueTransformer transformValue:@{ @"latitude": @"12345", @"longitude": @[] } toValue:&value ofClass:[CLLocation class] error:&error];
    expect(success).to.beFalsy();
    expect(value).to.beNil();
    expect(error).notTo.beNil();
    expect(error.domain).to.equal(RKValueTransformersErrorDomain);
    expect(error.code).to.equal(RKValueTransformationErrorUntransformableInputValue);
    expect([error localizedDescription]).to.equal(@"Expected an `inputValue` of type `(\n    NSNumber,\n    NSString\n)`, but got a `__NSArrayI`.");
}

- (void)testTransformationFailureWithInvalidDestinationClass
{
    RKCLLocationValueTransformer *valueTransformer = [RKCLLocationValueTransformer locationValueTransformerWithLatitudeKey:@"latitude" longitudeKey:@"longitude"];
    id value = nil;
    NSError *error = nil;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:40.7680 longitude:73.9819];
    BOOL success = [valueTransformer transformValue:location toValue:&value ofClass:[NSData class] error:&error];
    expect(success).to.beFalsy();
    expect(value).to.beNil();
    expect(error).notTo.beNil();
    expect(error.domain).to.equal(RKValueTransformersErrorDomain);
    expect(error.code).to.equal(RKValueTransformationErrorUnsupportedOutputClass);
}

@end
