/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2013年 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BeK0sukeTisdwebimageView.h"

@implementation BeK0sukeTisdwebimageView

-(void)initializeState
{
    [super initializeState];
    
    if (self)
    {
        imageview = [[UIImageView alloc] initWithFrame:[self frame]];
        [imageview setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [imageview setContentMode:[self contentModeForImageView]];
        [self addSubview:imageview];
    }
}

-(CGFloat)contentWidthForWidth:(CGFloat)suggestedWidth
{
    if (autoWidth > 0)
    {
        return autoWidth;
    }
    
    CGFloat calculatedWidth = TiDimensionCalculateValue(width, autoWidth);
    if (calculatedWidth > 0)
    {
        return calculatedWidth;
    }
    
    return 0;
}

-(CGFloat)contentHeightForWidth:(CGFloat)width_
{
    if (width_ != autoWidth && autoWidth>0 && autoHeight > 0) {
        return (width_*autoHeight/autoWidth);
    }
    
    if (autoHeight > 0)
    {
        return autoHeight;
    }
    
    CGFloat calculatedHeight = TiDimensionCalculateValue(height, autoHeight);
    if (calculatedHeight > 0)
    {
        return calculatedHeight;
    }
    
    return 0;
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    for (UIView *child in [self subviews])
    {
        [TiUtils setView:child
            positionRect:bounds];
    }
    
    [super frameSizeChanged:frame bounds:bounds];
}

-(void)setWidth_:(id)args
{
    width = TiDimensionFromObject(args);
    [self updateContentMode];
}

-(void)setHeight_:(id)args
{
    height = TiDimensionFromObject(args);
    [self updateContentMode];
}

-(void)setImage_:(id)args
{
    __weak BeK0sukeTisdwebimageView *_self = self;
    __block TiDimension _width = width;
    __block TiDimension _height = height;
    __block CGFloat _autoWidth = autoWidth;
    __block CGFloat _autoHeight = autoHeight;
    __weak UIImageView *_imageview = imageview;
    
    NSURL *url = [NSURL URLWithString:[TiUtils stringValue:[self.proxy valueForKey:@"image"]]];
    
    UIImage *placeholder;
    if ([TiUtils stringValue:[self.proxy valueForKey:@"defaultImage"]] == nil)
    {
        placeholder = [UIImage imageNamed:@"modules/be.k0suke.tisdwebimage/photoDefault.png"];
    }
    
    [imageview setImageWithURL:url
                   placeholderImage:placeholder
                            options:[TiUtils intValue:[self.proxy valueForKey:@"options"] def:0]
                           progress:^(NSUInteger receivedSize, long long expectedSize) {
                               if ([_self.proxy _hasListeners:@"progress"])
                               {
                                   NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [NSNumber numberWithInt:receivedSize], @"received",
                                                               [NSNumber numberWithLongLong:expectedSize], @"expected",
                                                               nil];
                                   [_self.proxy fireEvent:@"progress"
                                               withObject:properties];
                               }
                           }
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              if (error == nil)
                              {
                                  if ([_self.proxy _hasListeners:@"completed"])
                                  {
                                      NSInteger hires = 1;
                                      if ([TiUtils boolValue:[_self.proxy valueForKey:@"hires"]])
                                      {
                                          hires = 2;
                                      }
                                      
                                      _autoWidth = image.size.width / hires;
                                      _autoHeight = image.size.width / hires;
                                      
                                      [_imageview setFrame:CGRectMake(0.0, 0.0,
                                                                      TiDimensionCalculateValue(_width, _autoWidth),
                                                                      TiDimensionCalculateValue(_height, _autoHeight))];
                                      
                                      NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [[TiBlob alloc] initWithImage:image], @"image",
                                                                  nil];
                                      [_self.proxy fireEvent:@"completed"
                                                  withObject:properties];
                                  }
                              }
                              else
                              {
                                  if ([_self.proxy _hasListeners:@"error"])
                                  {
                                      [_self.proxy fireEvent:@"error"];
                                  }
                              }
                          }
     ];
}

-(UIViewContentMode)contentModeForImageView
{
    if (TiDimensionIsAuto(width) || TiDimensionIsAutoSize(width) || TiDimensionIsUndefined(width) ||
        TiDimensionIsAuto(height) || TiDimensionIsAutoSize(height) || TiDimensionIsUndefined(height))
    {
        return UIViewContentModeScaleAspectFit;
    }
    else
    {
        return UIViewContentModeScaleToFill;
    }
}

-(void)updateContentMode
{
    UIViewContentMode curMode = [self contentModeForImageView];
    
    if (imageview != nil)
    {
        imageview.contentMode = curMode;
    }
    
    if (self != nil) {
        for (UIView *view in [self subviews]) {
            UIView *child = [[view subviews] count] > 0 ? [[view subviews] objectAtIndex:0] : nil;
            if (child!=nil && [child isKindOfClass:[UIImageView class]])
            {
                child.contentMode = curMode;
            }
        }
    }
}

@end
