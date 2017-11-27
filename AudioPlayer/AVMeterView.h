//
//  AVMeterView.h
//  AudioPlayer
//
//  Created by Yang ziJ on 2017/11/27.
//  Copyright © 2017年 Yang ziJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AVMeterView : UIView
@property(nonatomic,strong)AVAudioPlayer *player;
@property(nonatomic,strong)UIImage *meterAveragePowerImage;
@property(nonatomic,strong)UIImage *meterPeakPowerImage;
@property(nonatomic,assign)float meterSpacing;
@property(nonatomic,assign)float meterHorizontalBorder;
@property(nonatomic,assign)float meterVerticalBorder;
-(void)startUpdating;
-(void)stopUpdating;

@end
