//
//  ViewController.m
//  Culminating
//
//  Created by Edwin Finch on 2015-06-12.
//  Copyright (c) 2015 Edwin Finch. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property NSURLConnection *postConnection, *getConnection;

@end

@implementation ViewController

- (void)displayError:(NSString*)string {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                    message:string
                                                   delegate:nil
                                          cancelButtonTitle:@"Alright"
                                          otherButtonTitles:nil];
    [alert show];
    self.statusLabel.text = string;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error %@", [error localizedDescription]);
    [self displayError:[error localizedDescription]];
}

- (void)getNewData {
    [self sendGetRequest:@"https://www.edwinfinch.com/culminating"];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSError *error = [[NSError alloc]init];
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"Result of %@.", jsonResult);
    if([jsonResult objectForKey:@"error"]){
        [self displayError:[jsonResult objectForKey:@"error"]];
        return;
    }
    if(connection == self.getConnection){
        self.lastSeenLabel.text = [NSString stringWithFormat:@"Last seen: %@", [jsonResult objectForKey:@"last_seen"]];
        self.temperatureLabel.text = [NSString stringWithFormat:@"Temperature: %@", [jsonResult objectForKey:@"temperature"]];
        self.lightLabel.text = [NSString stringWithFormat:@"Light: %@", [jsonResult objectForKey:@"light"]];
        self.uptimeLabel.text = [NSString stringWithFormat:@"Uptime: %@", [NSString stringWithFormat:@"%@ seconds", [jsonResult objectForKey:@"uptime"]]];
        NSNumber *leftBoolean = (NSNumber*)[jsonResult objectForKey:@"left_light"];
        NSNumber *rightBoolean = (NSNumber*)[jsonResult objectForKey:@"right_light"];
        self.rightLEDSwitch.on = [rightBoolean boolValue];
        self.leftLEDSwitch.on = [leftBoolean boolValue];
        [NSTimer scheduledTimerWithTimeInterval:0.5
                                         target:self
                                       selector:@selector(getNewData)
                                       userInfo:nil
                                        repeats:NO];
    }
    self.statusLabel.text = @"Success.";
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection{
    NSLog(@"Finished, boi");
}

- (void)sendPostRequest:(NSString*)command :(NSString*)args {
    NSLog(@"sending post request");
    NSString *post = [NSString stringWithFormat:@"args=%@", args];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.particle.io/v1/devices/53ff6c066667574830391267/%@?access_token=c2f589c281a4453e851da6c031d38f06355b0114", command]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    self.postConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self.postConnection start];
    
    if([command isEqualToString:@"LED_CONTROL"]){
        [self refreshButtonPressed:nil];
    }
    self.statusLabel.text = @"Connecting.";
}

- (void)sendGetRequest:(NSString*)url {
    NSLog(@"sending get request");
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    self.getConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self.getConnection start];
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self sendGetRequest:@"https://edwinfinch.com/culminating"];
}

- (void)updateLights{
    [self.getConnection cancel];
    int value = (self.leftLEDSwitch.on && self.rightLEDSwitch.on) ? 0 : (self.leftLEDSwitch.on && !self.rightLEDSwitch.on) ? 11 : (!self.leftLEDSwitch.on && self.rightLEDSwitch.on) ? 12 : 1;
    [self sendPostRequest:@"LED_CONTROL" :[NSString stringWithFormat:@"%d", value]];
}

- (IBAction)ledSwitchChanged:(id)sender {
    [self updateLights];
}

- (IBAction)upButtonPushed:(id)sender {
    [self sendPostRequest:@"MOVE" :@"1"];
}

- (IBAction)downButtonPushed:(id)sender {
    [self sendPostRequest:@"MOVE" :@"2"];
}

- (IBAction)leftButtonPushed:(id)sender {
    [self sendPostRequest:@"MOVE" :@"4"];
}

- (IBAction)rightButtonPushed:(id)sender {
    [self sendPostRequest:@"MOVE" :@"3"];
}

- (IBAction)stopButtonPushed:(id)sender {
    [self sendPostRequest:@"MOVE" :@"0"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self refreshButtonPressed:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
