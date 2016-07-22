//
//  ViewController.m
//  Peer Tutoring
//
//  Created by Samuel Noyes on 7/19/16.
//  Copyright © 2016 Samuel Noyes. All rights reserved.
//

#import "TableViewController.h"
#import "QuestionTableViewCell.h"

@interface ViewController ()
@property (strong, nonatomic) NSArray *questions;
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
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSLog(@"Response Array: %@", responseArray);
            self.questions = responseArray;
            NSLog(@"%@", responseArray );
        }
        else {
            NSLog(@"%@", error);
        }
        
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Count = %lu", (unsigned long)[self.questions count]);
    return [self.questions count];
}

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionTableViewCell *cell = (QuestionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    NSLog(@"Getting cell");
    [cell setAuthorText:[(NSDictionary *)[self.questions objectAtIndex:indexPath.row] objectForKey:@"Author"]];
    [cell setQuestionText:[(NSDictionary *)[self.questions objectAtIndex:indexPath.row] objectForKey:@"Text"]];
    [cell setSubjectText:[(NSDictionary *)[self.questions objectAtIndex:indexPath.row] objectForKey:@"Subject"]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
