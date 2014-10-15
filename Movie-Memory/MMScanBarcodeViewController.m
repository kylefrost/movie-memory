//
//  MMScanBarcodeViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 5/27/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMScanBarcodeViewController.h"

@interface MMScanBarcodeViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    // Objects for scanning the barcode and the output of the barcode
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    // View that highlights barcode and label to show UPC/EAN number
    UIView *_highlightView;
    UILabel *_label;
    
    // String of barcode found
    NSString *detectionString;
    
    // int for while loop to make beep sound play once
    int i;
}

@end

@implementation MMScanBarcodeViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    // Initialize to 0
    i = 0;
    
    // Initialize and set properties for highlight view to show over barcode when found.
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor colorWithRed:0.922 green:0.196 blue:0.192 alpha:1.000].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
    
    // Add the label and set its properties
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"Searching...";
    [self.view addSubview:_label];
    
    // Beging the session on the device in order to start scanning for barcode
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    // Set input as the current device input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    // Set the output to the metadata found on the barcode
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    // Show the camera view so the user can see what they are scanning for
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    // Start the AV capture session
    [_session startRunning];
    
    // Put all the views on top
    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];
    [self.view bringSubviewToFront:self.cancel];
    
    // Hide the indicator and its background
    self.findingBarcode.hidden = YES;
    self.indicatorBackground.hidden = YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // Initialize variables
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    // Search for the barcode metadata and assign the barcode metadata to the detectionString
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type]) {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil) {
            // When a string for the barcode has been found, begin finding the title and play beep for user feedback
            while (i < 1) {
                NSString *beepPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
                NSURL *pewPewURL = [NSURL fileURLWithPath:beepPath];
                AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &_beepSound);
                AudioServicesPlaySystemSound(_beepSound);
                i++;
            }
            // Set the label as the UPC/EAN and send string to find title
            _label.text = detectionString;
            [self findTitle:detectionString];
            break;
        }
        else {
            _label.text = @"Searching...";
        }
    }
    _highlightView.frame = highlightViewRect;
}

-(void)findTitle:(NSString *)barcode {
    // Show the indicator and its background as searcing begins
    [self.view bringSubviewToFront:self.indicatorBackground];
    [self.view bringSubviewToFront:self.findingBarcode];
    [self.findingBarcode startAnimating];
    self.findingBarcode.hidden = NO;
    self.indicatorBackground.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.indicatorBackground.layer.opacity = 0.5f;
    self.indicatorBackground.layer.cornerRadius = self.indicatorBackground.bounds.size.width/2;
    self.indicatorBackground.hidden = NO;
    
    // Set the URL for the JSON information that needs to be found
    static NSString *apiKey = @"ZMDYiccLpvczRrPNlTTA1iAY6Y5-XPXwX3v3ipx25r9";
    NSString *string = [NSString stringWithFormat:@"https://api.scandit.com/v2/products/%@?key=%@", barcode, apiKey];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Initialize the request operation for JSON
    self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    self.operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // Create weak self for use in Block
    __weak typeof(self) weakSelf = self;
    
    // If the operation was a success
    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Get the name of the movie from the JSON data
        NSDictionary *allBasic = [responseObject objectForKey:@"basic"];
        NSString *myMovieTitle = [NSString stringWithFormat:@"%@", [allBasic objectForKey:@"name"]];
        
        // Dismiss the view and send the notification that a title was found (NULL data is handled in Tab Controller)
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scannedBarcode" object:myMovieTitle];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Operation failed (TBD)
    }];
    
    // Start the operation and add to operation queue
    [self.operation start];
    [self.queue addOperation:self.operation];
}

-(IBAction)pressCancel:(id)sender {
    // Dismiss if user cancels
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
