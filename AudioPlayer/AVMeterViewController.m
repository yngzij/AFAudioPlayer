//
//  AVMeterViewController.m
//  AudioPlayer
//
//  Created by Yang ziJ on 2017/11/27.
//  Copyright © 2017年 Yang ziJ. All rights reserved.
//

#import "AVMeterViewController.h"
#import "AVMeterView.h"
@interface AVMeterViewController ()
@property(nonatomic,strong)AVMeterView *meterView;

@end

@implementation AVMeterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame=self.view.frame;

    _meterView=[[AVMeterView alloc] initWithFrame:frame];

    _meterView.player=_player;
    NSString *path=[[NSBundle mainBundle]pathForResource:@"11" ofType:@"png"];

    UIImage *peak=[[UIImage alloc] initWithContentsOfFile:path];
 path=[[NSBundle mainBundle]pathForResource:@"12" ofType:@"png"];
    UIImage *avg=[[UIImage alloc]initWithContentsOfFile:path];
    _meterView.meterPeakPowerImage=peak;
    _meterView.meterAveragePowerImage=avg;
    [self.view addSubview:_meterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(instancetype)init
{
    NSError *err;
    self=[super init];
    if(self)
    {
        
        NSString *path=[[NSBundle mainBundle]pathForResource:@"1" ofType:@"mp3"];
        NSURL *url=[[NSURL alloc] initWithString:path];
        _player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
        
        if(err)
            NSLog(@"Failed to initialize %@",err);
        [self setNavProperties];
        [_player prepareToPlay];
        
    }
    return self;
}

-(void)setNavProperties
{
    _item=[[UIBarButtonItem alloc]initWithTitle:(_player.playing==YES?@"STOT":@"play") style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    self.navigationItem.rightBarButtonItem=_item;
    if(_player.playing==YES)
    {
        self.title=@"Playing";
    }
    else self.title=@"Stoped";
}
-(void)click
{
    if(_player.playing==YES)
    {
        [_player stop];
        [_meterView stopUpdating];
    }
    else
    {
        [_player play];
        [_meterView startUpdating];
    }
    [self setNavProperties];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
