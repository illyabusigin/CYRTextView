//
//  QEDTextView.m
//  CYRTextViewExample
//
//  Created by Illya Busigin on 1/10/14.
//  Copyright (c) 2014 Cyrillian, Inc. All rights reserved.
//

#import "QEDTextView.h"

#import <CoreText/CoreText.h>

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@implementation QEDTextView

#pragma mark - Initialization & Setup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonSetup];
    }
    
    return self;
}

- (void)commonSetup
{
    _defaultFont = [UIFont systemFontOfSize:14.0f];
    _boldFont = [UIFont boldSystemFontOfSize:14.0f];
    _italicFont = [UIFont fontWithName:@"HelveticaNeue-Oblique" size:14.0f];
    
    self.font = _defaultFont;
    
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(defaultFont)) options:NSKeyValueObservingOptionNew context:0];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(boldFont)) options:NSKeyValueObservingOptionNew context:0];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(italicFont)) options:NSKeyValueObservingOptionNew context:0];
    
    if (_italicFont == nil && ([UIFontDescriptor class] != nil))
    {
        // This works around a bug in 7.0.3 where HelveticaNeue-Italic is not present as a UIFont option
        _italicFont = (__bridge_transfer UIFont*)CTFontCreateWithName(CFSTR("HelveticaNeue-Italic"), 14.0f, NULL);
    }
    
    self.tokens = [self solverTokens];
}


- (NSArray *)solverTokens
{
    NSArray *solverTokens =  @[
                               [CYRToken tokenWithName:@"special_numbers"
                                                expression:@"[ʝ]"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(0, 0, 255)
                                                             }],
                               [CYRToken tokenWithName:@"mod"
                                                expression:@"\bmod\b"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(245, 0, 110)
                                                             }],
                               [CYRToken tokenWithName:@"string"
                                                expression:@"\".*?(\"|$)"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(24, 110, 109)
                                                             }],
                               [CYRToken tokenWithName:@"hex_1"
                                                expression:@"\\$[\\d a-f]+"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(0, 0, 255)
                                                             }],
                               [CYRToken tokenWithName:@"octal_1"
                                                expression:@"&[0-7]+"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(0, 0, 255)
                                                             }],
                               [CYRToken tokenWithName:@"binary_1"
                                                expression:@"%[01]+"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(0, 0, 255)
                                                             }],
                               [CYRToken tokenWithName:@"hex_2"
                                                expression:@"0x[0-9 a-f]+"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(0, 0, 255)
                                                             }],
                               [CYRToken tokenWithName:@"octal_2"
                                                expression:@"0o[0-7]+"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(0, 0, 255)
                                                             }],
                               [CYRToken tokenWithName:@"binary_2"
                                                expression:@"0b[01]+"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(0, 0, 255)
                                                             }],
                               [CYRToken tokenWithName:@"float"
                                                expression:@"\\d+\\.?\\d+e[\\+\\-]?\\d+|\\d+\\.\\d+|∞"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(0, 0, 255)
                                                             }],
                               [CYRToken tokenWithName:@"integer"
                                                expression:@"\\d+"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(0, 0, 255)
                                                             }],
                               [CYRToken tokenWithName:@"operator"
                                                expression:@"[/\\*,\\;:=<>\\+\\-\\^!·≤≥]"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(245, 0, 110)
                                                             }],
                               [CYRToken tokenWithName:@"round_brackets"
                                                expression:@"[\\(\\)]"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(161, 75, 0)
                                                             }],
                               [CYRToken tokenWithName:@"square_brackets"
                                                expression:@"[\\[\\]]"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(105, 0, 0),
                                                             NSFontAttributeName : self.boldFont
                                                             }],
                               [CYRToken tokenWithName:@"absolute_brackets"
                                                expression:@"[|]"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(104, 0, 111)
                                                             }],
                               [CYRToken tokenWithName:@"reserved_words"
                                                expression:@"(abs|acos|acosh|asin|asinh|atan|atanh|atomicweight|ceil|complex|cos|cosh|crandom|deriv|erf|erfc|exp|eye|floor|frac|gamma|gaussel|getconst|imag|inf|integ|integhq|inv|ln|log10|log2|machineprecision|max|maximize|min|minimize|molecularweight|ncum|ones|pi|plot|random|real|round|sgn|sin|sqr|sinh|sqrt|tan|tanh|transpose|trunc|var|zeros)"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(104, 0, 111),
                                                             NSFontAttributeName : self.boldFont
                                                             }],
                               [CYRToken tokenWithName:@"chart_parameters"
                                                expression:@"(chartheight|charttitle|chartwidth|color|seriesname|showlegend|showxmajorgrid|showxminorgrid|showymajorgrid|showyminorgrid|transparency|thickness|xautoscale|xaxisrange|xlabel|xlogscale|xrange|yautoscale|yaxisrange|ylabel|ylogscale|yrange)"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(11, 81, 195),
                                                             }],
                               [CYRToken tokenWithName:@"comment"
                                                expression:@"//.*"
                                                attributes:@{
                                                             NSForegroundColorAttributeName : RGB(31, 131, 0),
                                                             NSFontAttributeName : self.italicFont
                                                             }]
                               ];
    
    return solverTokens;
}


#pragma mark - Cleanup

- (void)dealloc
{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(defaultFont))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(boldFont))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(italicFont))];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(defaultFont))] ||
        [keyPath isEqualToString:NSStringFromSelector(@selector(boldFont))] ||
        [keyPath isEqualToString:NSStringFromSelector(@selector(italicFont))])
    {
        // Reset the tokens, this will clear any existing formatting
        self.tokens = [self solverTokens];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - Overrides

- (void)setDefaultFont:(UIFont *)defaultFont
{
    _defaultFont = defaultFont;
    self.font = defaultFont;
}

@end
