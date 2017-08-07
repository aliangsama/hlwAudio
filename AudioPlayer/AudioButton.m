//
//  AudioButton.m
//  HLWAudio
//
//  Created by 黄黎雯 on 2017/8/7.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "AudioButton.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>

static inline double radians (double degrees) {return degrees * M_PI/180;}

NSString *playImage = @"dtPlayIcon";
NSString *stopImage = @"dtStopIcon";

@implementation AudioButton

@synthesize image;


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    
    if (self) 
    {
        self.opaque = NO;
		self.hidden = NO;
		self.alpha = 1.0;
		self.backgroundColor = [UIColor clearColor];        
        self.contentMode=UIViewContentModeCenter;
        _r = 0.1;
        _g = 1.0;
        _b = 0.1;
        _a = 1.0;
		
		_progress = 10;
        
        self.image = [UIImage imageNamed:@""];
        [self startSpin];
    }
    
    return self;
}

#pragma mark -
#pragma mark Setter & Getters:

// returns the component's value.
-(CGFloat) progress
{
	return _progress;
}

// set the component's value
-(void) setProgress:(CGFloat) newProgress
{
	_progress = newProgress;
    
	[self setNeedsDisplay];
}

// set component colour, set using RGBA system, each value should be between 0 and 1.
-(void) setColourR:(CGFloat) r G:(CGFloat) g B:(CGFloat) b A:(CGFloat) a 
{
	_r = r;
	_g = g;
	_b = b;
	_a = a;
    
	[self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect 
{    
    [super drawRect:rect];
    
    CGRect framere=rect;
    framere.size.width=50;
    framere.size.height=50;
    framere.origin.x=61;
    framere.origin.y=61;
    [image drawInRect:framere];
    
    // find the radius and position for the largest circle that fits in the UIView's frame.
    int radius, x, y;
    int offset = 6;
    
    // in case the given frame is not square (oblong) we need to check and use the shortest side as our radius.			
    CGRect frame = self.frame;
    if (frame.size.width > frame.size.height) {
        radius = frame.size.height;
        // we want our circle to be in the center of the frame.
        int delta = frame.size.width - radius;
        x = delta/2;
        y = 0;
    } else {
        radius = frame.size.width;
        int delta = frame.size.height - radius;
        y = delta/2;
        x = 0;
    }
    
    // store the largest circle's position and radius in class variable.
    _outerCircleRect = CGRectMake(x, y, radius, radius);
    // store the inner circles rect, this inner circle will have a radius 10pixels smaller than the outer circle.
    // we want to the inner circle to be in the middle of the outer circle.
    _innerCircleRect = CGRectMake(x+offset, y+offset, radius-2*offset , radius-2*offset);

    
    // get the drawing canvas (CGContext):
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // save the context's previous state:
    CGContextSaveGState(context);
    
    // our custom drawing code will go here:
    
    // Draw the gray background for our progress view:
    
    // gradient properties:
    CGGradientRef myGradient;
    // You need tell Quartz your colour space (how you define colours), there are many colour spaces: RGBA, black&white...
    CGColorSpaceRef myColorspace; 
    // the number of different colours
    size_t num_locations = 3;
    // the location of each colour change, these are between 0 and 1, zero is the first circle and 1 is the end circle, so 0.5 is in the middle.
    CGFloat locations[3] = { 0.0, 0.5 ,1.0 }; 
    // this is the colour components array, because we are using an RGBA system each colour has four components (four numbers associated with it).
    CGFloat components[12] = {
        0.4, 0.4, 0.4, 0.9,    // Start colour
        0.9, 0.9, 0.9, 1.0,	// middle colour
        0.4, 0.4, 0.4, 0.9
    }; // End colour
    
    myColorspace = CGColorSpaceCreateDeviceRGB(); 
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components,locations, num_locations);
    
    // gradient start and end points
    CGPoint myStartPoint, myEndPoint; 
    CGFloat myStartRadius, myEndRadius; 
    myStartPoint.x = _innerCircleRect.origin.x + _innerCircleRect.size.width/2; 
    myStartPoint.y = _innerCircleRect.origin.y + _innerCircleRect.size.width/2;
    myEndPoint.x = _innerCircleRect.origin.x + _innerCircleRect.size.width/2;
    myEndPoint.y = _innerCircleRect.origin.y + _innerCircleRect.size.width/2;
    myStartRadius = _innerCircleRect.size.width/2 ; 
    myEndRadius = _outerCircleRect.size.width/2; 
    
    
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, 
                         _outerCircleRect.origin.x + _outerCircleRect.size.width/2, // move to the top center of the outer circle
                         _outerCircleRect.origin.y +1); // the Y is one more because we want to draw inside the bigger circles.
    // add an arc relative to _progress
    CGContextAddArc(context, 
                    _outerCircleRect.origin.x + _outerCircleRect.size.width/2,
                    _outerCircleRect.origin.y + _outerCircleRect.size.width/2,
                    _outerCircleRect.size.width/2,
                    -M_PI/2,
                    (-M_PI/2 + _progress*2*M_PI), 0);
    CGContextAddArc(context, 
                    _outerCircleRect.origin.x + _outerCircleRect.size.width/2,
                    _outerCircleRect.origin.y + _outerCircleRect.size.width/2,
                    _outerCircleRect.size.width/2 - 9,
                    (-M_PI/2 + _progress*2*M_PI),
                    -M_PI/2, 1);
    // use clode path to connect the last point in the path with the first point (to create a closed path)
    CGContextClosePath(context);
    // clip to the path stored in context
    CGContextClip(context);
    
    // Progress drawing code comes here:
    
    // set the gradient colours based on class variables.
    CGFloat components2[12] = {  _r, _g, _b, _a, // Start color
        ((_r + 0.5 > 1) ? 1 : (_r+0.5) ) , ((_g + 0.5 > 1) ? 1 : (_g+0.5) ), ((_b + 0.5 > 1) ? 1 : (_b+0.5) ), ((_a + 0.5 > 1) ? 1 : (_a+0.5) ),
        _r, _g, _b, _a }; // End color
    
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components2,locations, num_locations);
    
    myStartPoint.x = _innerCircleRect.origin.x + _innerCircleRect.size.width/2; 
    myStartPoint.y = _innerCircleRect.origin.y + _innerCircleRect.size.width/2;
    myEndPoint.x = _innerCircleRect.origin.x + _innerCircleRect.size.width/2;
    myEndPoint.y = _innerCircleRect.origin.y + _innerCircleRect.size.width/2;
    // set the radias for start and endpoints a bit smaller, because we want to draw inside the outer circles.
    myStartRadius = _innerCircleRect.size.width/2; 
    myEndRadius = _outerCircleRect.size.width/2; 
    
    CGContextDrawRadialGradient(context, 
                                myGradient, 
                                myStartPoint, myStartRadius, myEndPoint, myEndRadius, 0);
	
    // release myGradient and myColorSpace
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorspace);
    
    
    // draw circle on the outline to smooth it out.
    
    CGContextSetRGBStrokeColor(context, _r,_g,_b,_a);
    
    // draw an ellipse in the provided rectangle
    CGContextAddEllipseInRect(context, _outerCircleRect);
    CGContextStrokePath(context);
    
    CGContextAddEllipseInRect(context, _innerCircleRect);
    CGContextStrokePath(context);
    
    
    //restore the context and remove the clipping area.
    CGContextRestoreGState(context);
    
    // restore the context's state when we are done with it:
    CGContextRestoreGState(context);
    
    
    /*CGPathRef circlePath = CGPathCreateMutable();
     CGPathAddEllipseInRect(circlePath , NULL , rect);
     CAShapeLayer *circle = [[CAShapeLayer alloc] init];
     circle.path = circlePath;
     circle.opacity = 0.5;
     [self.imageView.layer addSublayer:circle];
     CGPathRelease( circlePath );
     [circle release];*/
}


#pragma 
#pragma mark Spin Button

- (void)startSpin
{
    if (!loadingView) {
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(67, 67, 38, 38)];
        loadingView = MB_AUTORELEASE([[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]);
    }
    CGRect frame=[loadingView frame];
    frame.origin.x=67;
    frame.origin.y=67;
    loadingView.frame=frame;
    [self addSubview:loadingView];
    [self setColourR:0.0 G:0.0 B:0.0 A:0.0];
    [(UIActivityIndicatorView *)loadingView startAnimating];
}

- (void)stopSpin
{
    [loadingView removeFromSuperview];
    
    [self setColourR:0.1 G:1.0 B:0.1 A:1.0];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (finished)
	{
		[self startSpin];
	}
}

- (void)dealloc 
{
    [super dealloc];
    [image release];
}


@end
