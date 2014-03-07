//
//  RITViewController.m
//  2200TouchesTest
//
//  Created by Pronin Alexander on 06.03.14.
//  Copyright (c) 2014 Pronin Alexander. All rights reserved.
//

#import "RITViewController.h"

@interface RITViewController ()

@property (weak, nonatomic) UIView* testView;
@property (weak, nonatomic) UIView* draggingView;
@property (assign, nonatomic) CGPoint touchOffset;

@end

@implementation RITViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    for (int i = 0; i < 8; i++) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(10 + 110*i, 100, 100, 100)];
        view.backgroundColor = [self randomColor];
        [self.view addSubview:view];
    }
    
    /*
    UIView* view;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view];
    self.testView = view;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(500, 100, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    self.draggingView = view;
     
     //self.view.multipleTouchEnabled = YES;
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void) logTouches:(NSSet*) touches WithMethod:(NSString*) methodName {
    
    NSMutableString* string = [NSMutableString stringWithString:methodName];
    
    for (UITouch* touch in touches) {
        
        CGPoint point = [touch locationInView:self.view];
        [string appendFormat:@" %@", NSStringFromCGPoint(point)];
    }
    
    NSLog(@"%@", string);
}

- (UIColor*) randomColor {
    CGFloat r = (float)(arc4random() % 256) / 255;
    CGFloat g = (float)(arc4random() % 256) / 255;
    CGFloat b = (float)(arc4random() % 256) / 255;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /*
    [self logTouches:touches WithMethod:@"touchesBegan"];
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.testView];
    NSLog(@"inside = %d", [self.testView pointInside:point withEvent:event]);
    */
    
    [self logTouches:touches WithMethod:@"touchesBegan"];
    UITouch* touch = [touches anyObject];
    CGPoint pointOnMainView = [touch locationInView:self.view];
    UIView* view = [self.view hitTest:pointOnMainView withEvent:event];
    
    if (![view isEqual:self.view]) {
        
        self.draggingView = view;
        
        [self.view bringSubviewToFront:self.draggingView];
        
        CGPoint touchPoint = [touch locationInView:self.draggingView];
        
        NSLog(@"bounds = %@", NSStringFromCGRect(self.draggingView.bounds));
        NSLog(@"MidX = %f, MidY = %f", CGRectGetMidX(self.draggingView.bounds), CGRectGetMidY(self.draggingView.bounds));
        NSLog(@"Touch point = %@", NSStringFromCGPoint(touchPoint));
        
        self.touchOffset = CGPointMake(
                                       CGRectGetMidX(self.draggingView.bounds) - touchPoint.x,
                                       CGRectGetMidY(self.draggingView.bounds) - touchPoint.y);
        
        NSLog(@"Touch offset = %@", NSStringFromCGPoint(self.touchOffset));
        
        //[self.draggingView.layer removeAllAnimations];
        [UIView animateWithDuration:0.3f animations:^{
            self.draggingView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
            self.draggingView.alpha = 0.3f;
        }];
        
    } else {
        
        self.draggingView = nil;
        
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self logTouches:touches WithMethod:@"touchesMoved"];
    
    if (self.draggingView) {
        UITouch* touch = [touches anyObject];
        CGPoint pointOnMainView = [touch locationInView:self.view];
        
        CGPoint correction = CGPointMake(
                                         pointOnMainView.x + self.touchOffset.x,
                                         pointOnMainView.y + self.touchOffset.y);
        
        self.draggingView.center = correction;
    }
    
}

- (void) onTouchesEnded {
    [UIView animateWithDuration:0.3f animations:^{
        self.draggingView.transform = CGAffineTransformIdentity;
        self.draggingView.alpha = 1.f;
    }];
    self.draggingView = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self logTouches:touches WithMethod:@"touchesEnded"];
    [self onTouchesEnded];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self logTouches:touches WithMethod:@"touchesCancelled"];
    [self onTouchesEnded];
    
}

@end
