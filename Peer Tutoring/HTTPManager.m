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
    
    NSURL* url = [NSURL URLWithString:[@"http://localhost:3020" stringByAppendingPathComponent:[NSString stringWithFormat:@"/comments/%ld", ID]]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *comments;
        NSMutableArray<Comment *> *finalArray = [[NSMutableArray alloc] init];
        
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSLog(@"Response Array: %@", responseArray);
            comments = responseArray;
            NSLog(@"%@", responseArray );
        }
        else {
            NSLog(@"%@", error);
        }
        
        for (NSDictionary *d in comments) {
            Comment *c = [[Comment alloc] initWithDictionary: d];
            [finalArray addObject: c];
        }
        completion(finalArray);
    }];
    
    [dataTask resume];
}

+ (void) getQuestionsWithCompletion: (void (^)(NSArray<Question *> *result)) completion {
    
    NSURL* url = [NSURL URLWithString:[@"http://localhost:3020" stringByAppendingPathComponent:@"/questions/"]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *questions;
        NSMutableArray<Question *> *finalArray = [[NSMutableArray alloc] init];
        
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

+ (void) postComment: (Comment *) c completion: (void (^)(BOOL success)) completion {
    NSError *error;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"http://localhost:3020/comment"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"text", c.commentText,
                         @"author", c.author, @"postID", c.postID,
                         nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if (!e && [str isEqualToString: @"true"]) {
            completion(YES);
        }
        else {
            completion(NO);
        }
    }];
    
    [postDataTask resume];

}

@end
