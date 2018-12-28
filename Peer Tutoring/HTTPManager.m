//
//  HTTPManager.m
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/22/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//


#import "HTTPManager.h"

#define SERVER_URL @"http://localhost:3020"

@interface HTTPManager ()
@property (strong, nonatomic) NSObject<NSURLSessionDelegate> *URLDelegate;
@end

@implementation HTTPManager

+ (void) getCommentsWithPostID: (NSInteger) ID completion: (void (^)(NSArray<Comment *> *result)) completion {
    
    NSURL* url = [NSURL URLWithString:[SERVER_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"/comments/%ld", (long)ID]]];
    NSLog(@"%@",url);
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
            
            comments = responseArray;
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

+ (void) getQuestionBatchWithSubjects: (NSArray *) subjects offset: (NSInteger) offset completion: (void (^)(NSArray<Question *> *result)) completion {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/filtered_questions/%lu", SERVER_URL, (long)offset]];
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:subjects
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
        NSArray *questions;
        NSMutableArray<Question *> *finalArray = [[NSMutableArray alloc] init];
        
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            questions = responseArray;
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
    
    [postDataTask resume];
}

+ (void) getQuestionBatchWithOffset: (NSInteger) offset completion: (void (^)(NSArray<Question *> *result)) completion {
    
    NSURL* url = [NSURL URLWithString:[SERVER_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"/questions/%lu", (long)offset]]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *questions;
        NSMutableArray<Question *> *finalArray = [[NSMutableArray alloc] init];
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            questions = responseArray;
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/comment", SERVER_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:  c.commentText, @"text", c.author, @"author", [NSString stringWithFormat:@"%ld", (long)c.postID], @"postID", nil];

    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData
                                    options:NSJSONWritingPrettyPrinted
                                      error:&error];
    
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if (!e && [str isEqualToString: @"true"]) {
            completion(YES);
        }
        else {
            NSLog(@"Error: %@\nResponse String: %@", e, str);
            completion(NO);
        }
    }];
    
    [postDataTask resume];

}

+ (void) postQuestion: (Question *) q completion: (void (^)(BOOL success)) completion {//Submit question to server
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/question", SERVER_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:  q.questionTitle, @"title", q.questionDetails, @"details", q.author, @"author", q.subject, @"subject", nil];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if (!e && [str isEqualToString: @"true"]) {
            completion(YES);
        }
        else {
            NSLog(@"Error: %@\nResponse String: %@", e, str);
            completion(NO);
        }
    }];
    
    [postDataTask resume];
}

+ (void) deleteQuestion: (Question *) q completion: (void (^)(BOOL success)) completion {
    NSURL* url = [NSURL URLWithString:[SERVER_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"/question/%ld",(long)q.ID]]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"DELETE";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if (!error && [str isEqualToString: @"true"]) {
            if (completion)
                completion(YES);
        }
        else {
            NSLog(@"Error: %@\nResponse String: %@", error, str);
            if (completion)
                completion(NO);
        }
    }];
    
    [dataTask resume];
}

+ (void) deleteComment: (Comment *) c completion: (void (^)(BOOL success)) completion {
    NSURL* url = [NSURL URLWithString:[SERVER_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"/comment/%ld",(long)c.commentID]]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"DELETE";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSLog(@"deleting");
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if (!error && [str isEqualToString: @"true"]) {
            if (completion)
                completion(YES);
        }
        else {
            NSLog(@"Error: %@\nResponse String: %@", error, str);
            if (completion)
                completion(NO);
        }
    }];
    
    [dataTask resume];
}

@end
