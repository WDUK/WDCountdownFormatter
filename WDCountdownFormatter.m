//
//  WDCountdownFormatter.m
//  StackOverflow - http://bit.ly/VeO7GB
//
//  Created by David Stockley on 28/11/2012.
//  Copyright (c) 2012 David Stockley. All rights reserved.
//

#import "WDCountdownFormatter.h"

@implementation WDCountdownFormatter

- (NSString *)stringForObjectValue:(id)anObject
{
    // We require a number
    if (![anObject isKindOfClass:[NSNumber class]]) {
        return nil;
    }

    NSNumber* intervalNumber = anObject;
    NSTimeInterval interval = [intervalNumber doubleValue];

    if (interval < 0) {
        return nil;
    }

    // For brevity, floor it
    NSInteger intervalInt = interval;

    // Calculate the components
    NSInteger hours = intervalInt / (60 * 60);
    NSInteger minutes = (intervalInt / 60) - (hours * 60);
    NSInteger seconds = intervalInt - (minutes * 60) - (hours * 60 * 60);

    // Construct the string
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumIntegerDigits:2];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    
    NSString* hoursString = [formatter stringFromNumber:@(hours)];
    NSString* minutesString = [formatter stringFromNumber:@(minutes)];
    NSString* secondsString = [formatter stringFromNumber:@(seconds)];

    return [NSString stringWithFormat:@"%@:%@:%@", hoursString, minutesString, secondsString];
}

- (BOOL)getObjectValue:(id *)anObject
             forString:(NSString *)string
      errorDescription:(NSString **)error {

    // Initilize scanner
    NSScanner* scanner = [NSScanner localizedScannerWithString:string];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@":." ]];

    // Gather our data
    NSInteger hour, minute, second;
    BOOL hourFound = [scanner scanInteger:&hour];
    BOOL minuteFound = [scanner scanInteger:&minute];
    BOOL secondFound = [scanner scanInteger:&second];

    // Validity checking
    if (!hourFound || hour < 0) {
        if (error) {
            if (!hourFound) {
                *error = [NSString stringWithFormat:@"No hour value found"];
            }
            else {
                *error = [NSString stringWithFormat:@"Hour evaluates to an incorrect value of %d", hour];
            }
        }
        return NO;
    }
    else if (!minuteFound || minute < 0 || minute > 59) {
        if (error) {
            if (!minuteFound) {
                *error = [NSString stringWithFormat:@"No minute value found"];
            }
            else {
                *error = [NSString stringWithFormat:@"Minute evaluates to an incorrect value of %d", minute];
            }
        }
        return NO;
    }
    else if (!secondFound || second < 0 || second > 59) {
        if (error) {
            if (!secondFound) {
                *error = [NSString stringWithFormat:@"No second value found"];
            }
            else {
                *error = [NSString stringWithFormat:@"Second evaluates to an incorrect value of %d", second];
            }
        }
        return NO;
    }

    // We have valid values, construct our NSTimeInterval, and return an NSNumber
    NSTimeInterval interval = (hour * 60 * 60) + (minute * 60) + second;
    *anObject = @(interval);
    
    return YES;
}

@end
