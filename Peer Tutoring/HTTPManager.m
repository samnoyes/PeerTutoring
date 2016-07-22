//
//  HTTPManager.m
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/22/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import "HTTPManager.h"

@implementation HTTPManager

+ (void) getCommentsWithPostID: (NSInteger) ID completion: (void (^)(NSArray<Comment *> *result)) completion {
    
}

+ (void) getQuestionsWithCompletion: (void (^)(NSArray<Question *> *result)) completion {
    NSArray *questions;
    NSArray<Question *> *finalArray = [[NSArray alloc] init];
    
    NSURL* url = [NSURL URLWithString:[@"http://localhost:3020" stringByAppendingPathComponent:@"/questions/"]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSLog(@"Response Array: %@", responseArray);
            questions = responseArray;
            NSLog(@"%@", responseArray );
        }
        else {
            NSLog(@"%@", error);
        }
        
        for (NSDictionary *d in questions) {
            Question *q = [[Question alloc] initWithDictionary: d];
            [finalArray addObject: q];
        }
        completion(finalArray);
    }];
    
    [dataTask resume];
}

@end
