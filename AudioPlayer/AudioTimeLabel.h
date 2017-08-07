//
//  AudioTimeLabel.h
//  newydl
//
//  Created by 黄黎雯 on 16-1-21.
//  Copyright (c) 2016年 黄黎雯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioTimeLabel : UILabel{

    NSString*strtime;
}

- (id)initWithFrame:(CGRect)frame;
-(NSString*)strtime;
-(void)setStrtime:(NSString *)newstrtime;
@end
