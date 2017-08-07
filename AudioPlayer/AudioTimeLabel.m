//
//  AudioTimeLabel.m
//  newydl
//
//  Created by 黄黎雯 on 16-1-21.
//  Copyright (c) 2016年 黄黎雯. All rights reserved.
//

#import "AudioTimeLabel.h"

@implementation AudioTimeLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment=NSTextAlignmentRight;
        self.font=[UIFont systemFontOfSize:12];
        strtime=@"00:00''";
        self.text = strtime;
    }
    
    return self;
}

-(NSString*)strtime{
    return strtime;
}

-(void)setStrtime:(NSString *)newstrtime{
    strtime=newstrtime;
    self.text=strtime;
}

@end
