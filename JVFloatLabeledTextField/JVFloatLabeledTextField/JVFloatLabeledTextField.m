//
//  JVFloatLabeledTextField.m
//  JVFloatLabeledTextField
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Jared Verdi
//  Original Concept by Matt D. Smith
//  http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?list=users
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "JVFloatLabeledTextField.h"

@interface JVFloatLabeledTextField ()
@end

@implementation JVFloatLabeledTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	    [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];

        // force setter to be called on a placeholder defined in a NIB/Storyboard
    	if (self.placeholder) {
        	self.placeholder = self.placeholder;
    	}
    }
    return self;
}

- (void)commonInit
{
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;

    _floatingLabel = [UILabel new];
    _floatingLabel.alpha = 0.0f;
    [self addSubview:_floatingLabel];

    // some basic default fonts/colors
    _floatingLabel.font = [UIFont systemFontOfSize:12.0f];
    _floatingLabelTextColor = [UIColor grayColor];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];

    _floatingLabel.text = placeholder;
    if (self.floatingLabelFont)
    {
        _floatingLabel.font = self.floatingLabelFont;
    }

    [_floatingLabel sizeToFit];

    CGFloat originX = 0.f;

    if (self.textAlignment == NSTextAlignmentCenter) {
        originX = (self.frame.size.width/2) - (_floatingLabel.frame.size.width/2);
    }
    else if (self.textAlignment == NSTextAlignmentRight) {
        originX = self.frame.size.width - _floatingLabel.frame.size.width;
    }

    _floatingLabel.frame = CGRectMake(originX, _floatingLabel.font.lineHeight,
                                      _floatingLabel.frame.size.width, _floatingLabel.frame.size.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect origTextRect = [super textRectForBounds:bounds];

    if ([self.text length] > 0)
    {
        return CGRectMake(0, 7.0f + _floatingLabel.font.lineHeight - 2, origTextRect.size.width, self.font.lineHeight + 2);
    }
    else
    {
        return CGRectMake(0, (bounds.size.height - self.font.lineHeight) / 2, origTextRect.size.width, self.font.lineHeight + 2);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}


- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect rect = [super clearButtonRectForBounds:bounds];
    rect = CGRectMake(rect.origin.x, rect.origin.y + (_floatingLabel.font.lineHeight / 2.0) + (_floatingLabelYPadding.floatValue / 2.0f), rect.size.width, rect.size.height);
    return rect;
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.isFirstResponder)
    {
        if (!self.text || 0 == [self.text length])
        {
            [self hideFloatingLabelAnimated:YES];
        }
        else
        {
            if (self.floatingLabelFont)
            {
                _floatingLabel.font = self.floatingLabelFont;
            }
            [self setLabelActiveColor];
            [self showFloatingLabelAnimated:YES];
        }
    }
    else
    {
        _floatingLabel.textColor = self.floatingLabelTextColor;
        if (!self.text || 0 == [self.text length])
        {
            [self hideFloatingLabelAnimated:NO];
        }
        else
        {
            [self showFloatingLabelAnimated:NO];
        }
    }
}

- (void)setLabelActiveColor
{
    if (self.floatingLabelActiveTextColor) {
        _floatingLabel.textColor = self.floatingLabelActiveTextColor;
    }
    else {
        _floatingLabel.textColor = self.tintColor;
    }
}

- (void)showFloatingLabelAnimated:(BOOL)animated
{
    [self setLabelOriginForTextAlignment];

    _floatingLabel.hidden = NO;
    if (animated)
    {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^
         {
             _floatingLabel.alpha = 1.0f;
             _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x, 7.0f, _floatingLabel.frame.size.width, _floatingLabel.frame.size.height);
         } completion:nil];
    }
    else
    {
        _floatingLabel.alpha = 1.0f;
        _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x, 7.0f, _floatingLabel.frame.size.width, _floatingLabel.frame.size.height);
    }

}

- (void)hideFloatingLabelAnimated:(BOOL)animated
{
    [self setLabelOriginForTextAlignment];

    if (animated)
    {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn animations:^
         {
             _floatingLabel.alpha = 0.0f;
         } completion:^(BOOL finished)
         {
             _floatingLabel.hidden = YES;
             _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x, _floatingLabel.font.lineHeight, _floatingLabel.frame.size.width, _floatingLabel.frame.size.height);
         }];
    }
    else
    {
        _floatingLabel.alpha = 0.0f;
        _floatingLabel.hidden = YES;
        _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x, _floatingLabel.font.lineHeight, _floatingLabel.frame.size.width, _floatingLabel.frame.size.height);
    }
}

- (void)setLabelOriginForTextAlignment
{
    CGFloat originX = _floatingLabel.frame.origin.x;

    if (self.textAlignment == NSTextAlignmentCenter) {
        originX = (self.frame.size.width/2) - (_floatingLabel.frame.size.width/2);
    }
    else if (self.textAlignment == NSTextAlignmentRight) {
        originX = self.frame.size.width - _floatingLabel.frame.size.width;
    }

    _floatingLabel.frame = CGRectMake(originX, _floatingLabel.frame.origin.y, _floatingLabel.frame.size.width, _floatingLabel.frame.size.height);
}

@end
