/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2013年 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import "TiDimension.h"
#import <UIImageView+WebCache.h>

@interface BeK0sukeTisdwebimageView : TiUIView {
@private
    TiDimension width;
    TiDimension height;
    CGFloat autoWidth;
    CGFloat autoHeight;
    UIImageView *imageview;
}

-(void)setWidth_:(id)args;
-(void)setHeight_:(id)args;
-(void)setImage_:(id)args;

@end
