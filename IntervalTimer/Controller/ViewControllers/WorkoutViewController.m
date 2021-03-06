//
//  WorkoutViewController.m
//  IntervalTimer
//
//  Created by Tim Sawtell on 14/02/13.
//
//

#import "WorkoutViewController.h"
#import "TimerHelper.h"
#import <AudioToolbox/AudioServices.h>


@interface WorkoutViewController ()
@property (nonatomic, assign) BOOL timerRunning;
@property (nonatomic, assign) LastIntervalType lastInterval;
@property (nonatomic, assign) NSUInteger lastRestFinishedAtSecondsElapsed;
@property (nonatomic, assign) NSUInteger lastWorkFinishedAtSecondsElapsed;
@property (nonatomic, assign) SystemSoundID completedSound;
@end

@implementation WorkoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bgView.layer.cornerRadius = self.workTextField.layer.cornerRadius = self.restTextField.layer.cornerRadius = self.timeBgView.layer.cornerRadius = self.toggleButton.layer.cornerRadius = self.statusBgView.layer.cornerRadius = kSizeOfCornerRounding;
    self.workTextField.inputAccessoryView = [self accessoryView];
    self.restTextField.inputAccessoryView = [self accessoryView];
    self.lastInterval = LastIntervalTypeRest;
    
    NSString *soundPath =  [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"aif"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &_completedSound);
    
    [self reloadData];
}

- (void)reloadData
{
    self.workTextField.text = self.timer.workInterval.stringValue;
    self.restTextField.text = self.timer.restInterval.stringValue;
    self.soundButton.alpha = self.timer.playAlertSoundValue ? 1 : kAlphaForHighlightedButtons;
    self.vibrateButton.alpha = self.timer.vibrateValue ? 1 : kAlphaForHighlightedButtons;
    [self resetRunningTimer];
    self.runningTimeLabel.text = [TimerHelper stringForTimeInterval:0];
}

- (void)resetRunningTimer
{
    [[Model sharedModel].runningTimer invalidate];
    [Model sharedModel].runningTimer = nil;
}

- (void)endEditing
{
    [self.view endEditing:YES];
}

- (void)viewDidUnload
{
    [self setToggleButton:nil];
    [self setTimeBgView:nil];
    [self setWorkTextField:nil];
    [self setRestTextField:nil];
    [self setRunningTimeLabel:nil];
    [self setWorkoutStatusLabel:nil];
    [self setStatusBgView:nil];
    [self setSoundButton:nil];
    [self setVibrateButton:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self setBgView:nil];
}

- (IBAction)toggleButtonPressed:(id)sender
{
    if (self.timerRunning) {
        [self stopTimer];
        [self.toggleButton setTitle:@"Begin" forState:UIControlStateNormal];
        self.toggleButton.backgroundColor = [Appearances colorForWorking];
    } else {
        [self startTimer];
        [self.toggleButton setTitle:@"End" forState:UIControlStateNormal];
        self.toggleButton.backgroundColor =  [Appearances colorForWorking];
    }
}


- (IBAction)soundToggled:(id)sender
{
    [Model sharedModel].timer.playAlertSoundValue = ![Model sharedModel].timer.playAlertSoundValue;
    if (![Model sharedModel].timer.playAlertSoundValue) {
        self.soundButton.alpha = kAlphaForHighlightedButtons;
    } else {
        self.soundButton.alpha = 1;
    }
}

- (IBAction)vibrateToggled:(id)sender
{
    [Model sharedModel].timer.vibrateValue = ![Model sharedModel].timer.vibrateValue;
    if (![Model sharedModel].timer.vibrateValue) {
        self.vibrateButton.alpha = kAlphaForHighlightedButtons;
    } else {
        self.vibrateButton.alpha = 1;
    }
}

- (void)startTimer
{
    self.timerRunning = YES;
    self.timer.startTime = [NSDate date];
    self.workTextField.userInteractionEnabled = NO;
    self.restTextField.userInteractionEnabled = NO;
    self.workoutStatusLabel.text = @"Working";
    [Model sharedModel].runningTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                        target:self
                                                                      selector:@selector(timerTicked)
                                                                      userInfo:nil
                                                                       repeats:YES];
    [self addScaleAnimation];
}

- (void)stopTimer
{
    [self resetRunningTimer];
    self.lastWorkFinishedAtSecondsElapsed = 0;
    self.lastRestFinishedAtSecondsElapsed = 0;
    self.workTextField.userInteractionEnabled = YES;
    self.restTextField.userInteractionEnabled = YES;
    self.workoutStatusLabel.text = @"--";
    self.timerRunning = NO;
    self.lastInterval = LastIntervalTypeRest;
    [self removeScaleAnimation];
}

- (void)addScaleAnimation
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.repeatDuration = HUGE_VALF;
    scaleAnimation.duration = 0.85;
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue= @1.2;
    [self.workoutStatusLabel.layer addAnimation:scaleAnimation forKey:@"appDeleteShakeAnimation"];
}

- (void)removeScaleAnimation
{
    [self.workoutStatusLabel.layer removeAllAnimations];
}

- (void)timerTicked
{
    NSTimeInterval timeDiff = [[NSDate date] timeIntervalSinceDate:self.timer.startTime];
    self.runningTimeLabel.text = [TimerHelper stringForTimeInterval:timeDiff];
    
    NSUInteger timeDiffInt = (int)timeDiff;
    switch (self.lastInterval) {
        case LastIntervalTypeRest:
        {
            if (timeDiffInt >= self.lastRestFinishedAtSecondsElapsed + self.timer.workIntervalValue) {
                self.lastInterval = LastIntervalTypeWork;
                self.lastWorkFinishedAtSecondsElapsed = timeDiffInt;
                if (self.timer.vibrateValue) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
                if (self.timer.playAlertSoundValue) {
                    AudioServicesPlaySystemSound(self.completedSound);
                }
                self.workoutStatusLabel.text = @"Resting";
                self.toggleButton.backgroundColor =  [Appearances colorForResting];
            }
        }
            break;
        case LastIntervalTypeWork:
        {
            if (timeDiffInt >= self.lastWorkFinishedAtSecondsElapsed + self.timer.restIntervalValue) {
                self.lastInterval = LastIntervalTypeRest;
                self.lastRestFinishedAtSecondsElapsed = timeDiffInt;
                if (self.timer.vibrateValue) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
                if (self.timer.playAlertSoundValue) {
                    AudioServicesPlaySystemSound(self.completedSound);
                }
                self.workoutStatusLabel.text = @"Working";
                self.toggleButton.backgroundColor =  [Appearances colorForWorking];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSNumber *value = [[[NSNumberFormatter alloc] init] numberFromString:textField.text];
    if (value.integerValue <= 0) {
        value = @1;
    }
    if (textField == self.workTextField) {
        self.timer.workInterval = value;
    } else {
        self.timer.restInterval = value;
    }
    [self reloadData];
}

#pragma mark - helper

- (Timer *)timer
{
    return [Model sharedModel].timer;
}

- (NSTimer *)runningTimer
{
    return [Model sharedModel].runningTimer;
}

- (UIView *)accessoryView
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *btn  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing)];
    toolbar.items = [NSArray arrayWithObject:btn];
    return toolbar;
}

- (void)dealloc
{
    AudioServicesRemoveSystemSoundCompletion(self.completedSound);
}

@end
