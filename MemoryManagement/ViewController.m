//
//  ViewController.m
//  MemoryManagement
//
//  Created by Paul Solt on 1/29/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import "ViewController.h"
#import "Car.h"
#import "Person.h"
#import "LSILog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Disable ARC in settings
    
    NSLog(@"Hi");

    NSString *name = [[NSString alloc] initWithString:@"Paul"]; // retain: 1 (alloc/init = +1)

    // Two methods for Manual Reference Counting (MRC)
    // Only exist with ARC disabled
    // retain
    // release

    [name retain]; // retain: 2 (retain = +1)
    [name retain]; // retain: 3 (retain = +1)

    [name release]; // retain: 2 (-1)
    [name release]; // retain: 1 (-1)
    [name release]; // retain: 0 -> automatically cleaned up
    name = nil; // position zero in memory
    // No longer safe to use name as a variable with what it's pointing at

    // Dangling pointer if we release to 0, and try to use (always set to nil when finished)
    // Bug to use it here: May crash, unexpected behaviors - undefined behaviors
    NSLog(@"Name: %@", name.description);

    // All Collections types will take ownership of the memory you pass them (objects)

    NSMutableArray *colors = [[NSMutableArray alloc] init]; // colors: 1

    NSLog(@"Colors: %@", colors);

    NSString *favoriteColor = [[NSString alloc] initWithString:@"Blue"]; // favoriteColor: 1
    [colors addObject:favoriteColor]; // favoriteColor: 2 (addObject + 1)
    [favoriteColor release]; // transferring object ownership to the array

    NSString *color2 = [[[NSString alloc] initWithString:@"Red"] autorelease];
    [colors addObject:color2];

    [colors release]; // colors: 0 -> automatic cleanup of memory (other variable can now use this space)
    colors = nil; // Prevents bugs with using invalid memory (Protecting my future self from making a mistake)

    // Using colors after setting it to nil is a no-op and will be predictable ... without it ... anything can happen

    Car *bmw = [[[Car alloc] initWithMake:@"i8"] autorelease]; // bmw: 1
    Person *person = [[Person alloc] initWithCar:bmw]; // person: 1

    person.car = [[[Car alloc] initWithMake:@"4 series"] autorelease]; // 2 = 1 + 1

    [person release];
    person = nil;
}

@end
