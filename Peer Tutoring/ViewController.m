//
//  ViewController.m
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/19/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL* url = [NSURL URLWithString:[@"http://localhost:3020" stringByAppendingPathComponent:@"/questions/"]];
    NSLog(@"%@", url);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSDictionary* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSLog(@"Response Array: %@", responseArray);
            
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    
    [dataTask resume];
}

- (void)parseAndAddLocations:(NSArray*)locations toArray:(NSMutableArray*)destinationArray //1
{
    for (id i in locations) {
        NSLog(@"Object: %@", i);
    }
    //for (NSDictionary* item in locations) {
       // Location* location = [[Location alloc] initWithDictionary:item]; //2
        //[destinationArray addObject:location];
    //}
    /*
    if (self.delegate) {
        [self.delegate modelUpdated]; //3
    }*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
