//
//  DetailsViewController.m
//  BlueWave
//
//  Created by Rémi Hillairet on 26/11/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import "DetailsViewController.h"
#import "LocalData.h"
#import "Define.h"

@interface DetailsViewController () {
    CGFloat offset;
}

#define MARGIN 10

@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    offset = 0;
    [self.contentScrollView setScrollEnabled:YES];
    [[LocalData sharedClient] getContentWithSerial:self.item.serial completion:^(BOOL success, NSArray *content) {
        if (success) {
            for (NSDictionary *object in content) {
                NSLog(@"Object : %@", object);
                if ([[object objectForKey:@"type"] isEqualToString:@"background"]) {
                    [self setBackground:object];
                } else if ([[object objectForKey:@"type"] isEqualToString:@"text"]) {
                    [self setText:object];
                } else if ([[object objectForKey:@"type"] isEqualToString:@"image"]) {
                    [self setImage:object];
                }
            }
            self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, offset);
            self.activityView.hidden = YES;
        } else {
            self.activityView.hidden = YES;
        }
    }];
}

- (void)setBackground:(NSDictionary *)object {
    NSString *backgroundColorString = [object objectForKey:@"content"];
    NSScanner *scanner = [NSScanner scannerWithString:backgroundColorString];
    NSString *junk, *red, *green, *blue;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&red];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&green];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&blue];
    
    UIColor *backgroundColor = [UIColor colorWithRed:red.intValue/255.0 green:green.intValue/255.0 blue:blue.intValue/255.0 alpha:1.0];
    self.view.backgroundColor = backgroundColor;
}

- (void)setText:(NSDictionary*)object {
    NSString *text = [object objectForKey:@"content"];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, 10)];
    UIFont *font = [UIFont fontWithName:@"DINPro-Medium" size:18.0];
    [textView setFont:font];
    [textView setText:text];
    [textView setSelectable:NO];
    [textView setEditable:NO];
    [textView setTextAlignment:NSTextAlignmentCenter];
    [textView sizeToFit];
    [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, self.view.frame.size.width, textView.frame.size.height)];
    [textView setBackgroundColor:[UIColor clearColor]];
    [self.contentScrollView addSubview:textView];
    offset = offset + textView.frame.size.height + MARGIN;
    NSLog(@"Offset : %f", offset);
}

- (void)setImage:(NSDictionary*)object {
    NSString *url = [object objectForKey:@"content"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIImage *resizeImage = [self imageWithImage:image scaledToWidth:self.view.frame.size.width * 2];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:resizeImage];
    imageView.frame = CGRectMake(0, offset, self.view.frame.size.width, resizeImage.size.height / 2);
    [self.contentScrollView addSubview:imageView];
    offset = offset + imageView.frame.size.height + MARGIN;
}

- (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
