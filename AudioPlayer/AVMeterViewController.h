//
//  AVMeterViewController.h
//  AudioPlayer
//
//  Created by Yang ziJ on 2017/11/27.
//  Copyright © 2017年 Yang ziJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AVMeterViewController : UIViewController

@property(nonatomic,strong)UIBarButtonItem *item;
@property(nonatomic,strong)AVAudioPlayer *player;

@end
