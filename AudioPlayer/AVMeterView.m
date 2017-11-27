//
//  AVMeterView.m
//  AudioPlayer
//
//  Created by Yang ziJ on 2017/11/27.
//  Copyright © 2017年 Yang ziJ. All rights reserved.
//

#import "AVMeterView.h"
#import <AVFoundation/AVFoundation.h>
@interface AVMeterView()
{

    float cachedAveragePowerForChannel[2];
    float cachedPeakPowerForChannel[2];
    CGRect avgMeterFrame[2],peakMeterFrame[2];
    bool updating;
}


@end


@implementation AVMeterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {

        _player=nil;
        updating=NO;
        _meterAveragePowerImage=nil;
        _meterPeakPowerImage=nil;
        _meterSpacing=40.0;
        _meterHorizontalBorder=20.0;
        _meterVerticalBorder=20.0;
        
        for(int i=0;i<2;++i)
        {
            cachedPeakPowerForChannel[i]=0.0;
            cachedAveragePowerForChannel[i]=0.0;
        }
        avgMeterFrame[0]=CGRectMake(_meterHorizontalBorder, _meterVerticalBorder, (frame.size.width/2-(_meterSpacing/2)-_meterHorizontalBorder), frame.size.height-_meterVerticalBorder);
        avgMeterFrame[1]=CGRectMake(_meterHorizontalBorder+(frame.size.width/2), _meterVerticalBorder, (frame.size.width/2)-(_meterSpacing/2)-_meterHorizontalBorder, frame.size.height-_meterVerticalBorder);
        peakMeterFrame[0]=CGRectMake(avgMeterFrame[0].origin.x, avgMeterFrame[0].origin.y, avgMeterFrame[0].size.width, avgMeterFrame[0].size.height);
        
                peakMeterFrame[1]=CGRectMake(avgMeterFrame[1].origin.x, avgMeterFrame[1].origin.y, avgMeterFrame[1].size.width, avgMeterFrame[1].size.height);
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    float averagePowerForChanner[2],peakPowerForChannel[2];
    BOOL renderedBottom;
    if(_player.numberOfChannels<1)
    {
        return ;
    }
    if(!_player||_player.meteringEnabled==NO)
    {
        cachedAveragePowerForChannel[0]=averagePowerForChanner[1]=0.0;
        peakPowerForChannel[0]=cachedAveragePowerForChannel[0];
                peakPowerForChannel[1]=cachedAveragePowerForChannel[1];
    }
    else
    {
        NSInteger channels=_player.numberOfChannels;
        if(channels>2)
            channels=2;
        for(int i=0;i<2;++i)
        {
            float db;
            [_player updateMeters];
            db=[_player peakPowerForChannel:i];
            averagePowerForChanner[i]=(50.0+db)/50.0;
        }
        if(channels==1)
        {
            peakPowerForChannel[1]=peakPowerForChannel[0];
            averagePowerForChanner[1]=averagePowerForChanner[0];
        }
    }
    
    renderedBottom=YES;
    for(int i=0;i<2;++i)
    {
     if(averagePowerForChanner[i]>cachedAveragePowerForChannel[i])
     {
         cachedAveragePowerForChannel[i]=averagePowerForChanner[i];
     }
        cachedAveragePowerForChannel[i]-=0.02;
        if(cachedAveragePowerForChannel[i]<0)
        {
            cachedAveragePowerForChannel[i]= 0;
            
        }
        if(peakPowerForChannel[i]>cachedPeakPowerForChannel[i])
        {
            cachedPeakPowerForChannel[i]=peakPowerForChannel[i];
        }
        
        cachedPeakPowerForChannel[i]-=0.01;
        if(cachedPeakPowerForChannel[i]<0.0)
            cachedPeakPowerForChannel[i]=0.0;

        if(cachedPeakPowerForChannel[i]!=0.0||cachedAveragePowerForChannel[i]!=0.0)
        {
            renderedBottom=NO;
        }
        if(_meterAveragePowerImage)
        {
            [_meterPeakPowerImage drawAsPatternInRect:CGRectMake(avgMeterFrame[i].origin.x, avgMeterFrame[i].origin.y+(avgMeterFrame[i].size.height-(avgMeterFrame[i].size.height*cachedAveragePowerForChannel[i])), avgMeterFrame[i].size.width, avgMeterFrame[i].size.height-(avgMeterFrame[i].size.height-(avgMeterFrame[i].size.height*cachedPeakPowerForChannel[i])))];
        }
        if(_meterPeakPowerImage)
        {
            [_meterPeakPowerImage drawAsPatternInRect:CGRectMake(peakMeterFrame[i].origin.x, peakMeterFrame[i].origin.y+avgMeterFrame[i].size.height-(avgMeterFrame[i].size.height*cachedPeakPowerForChannel[i]),peakMeterFrame[i].size.width , _meterPeakPowerImage.size.height)];
        }
        
    }
    if(updating==YES||renderedBottom==NO)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(handleTime:) userInfo:nil repeats:NO];
    }
}

-(void)handleTime:(NSTimer *)timer
{
    [self setNeedsDisplay];
}
-(void)startUpdating
{
    updating=YES;
    _player.meteringEnabled=YES;
    [self setNeedsDisplay];
}

-(void)stopUpdating
{
    updating=NO;
    _player.meteringEnabled=NO;
    [self setNeedsDisplay];
    
}
@end
