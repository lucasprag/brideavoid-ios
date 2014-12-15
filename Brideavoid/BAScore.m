//
//  BAScore.m
//  Brideavoid
//
//  Created by Lucas Oliveira on 7/25/14.
//  Copyright (c) 2014 pingdiff. All rights reserved.
//

#import "BAScore.h"
#import "BAMenuScene.h"

@implementation BAScore
{
    SKLabelNode *_label;
}

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"backgroud.png"];
        bg.size = self.frame.size;
        bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:bg];
        
        _label = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        _label.fontSize = 40;
        _label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+150);
        _label.fontColor = [SKColor colorWithHue:0 saturation:0 brightness:1 alpha:1];
        _label.text = [NSString stringWithFormat:@"You got"];
        [self addChild:_label];
        
        _label = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        _label.fontSize = 45;
        _label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+100);
        _label.fontColor = [SKColor colorWithHue:0 saturation:0 brightness:1 alpha:1];
        _label.text = [NSString stringWithFormat:@"marriage!"];
        [self addChild:_label];
        
        _label = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        _label.fontSize = 30;
        _label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-30);
        _label.fontColor = [SKColor colorWithHue:0 saturation:0 brightness:1 alpha:1];
        _label.text = [NSString stringWithFormat:@"You skipped"];
        [self addChild:_label];
        
        _label = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        _label.fontSize = 50;
        _label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-75);
        _label.fontColor = [SKColor colorWithHue:0 saturation:0 brightness:1 alpha:1];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        int score = [prefs integerForKey:@"score"];
        
        int bestscore = [prefs integerForKey:@"best-score"];
        if(bestscore > score){
            [prefs setInteger:score forKey:@"best-score"];
        }
        
        _label.text = [NSString stringWithFormat:@"%02d", score];
        [self addChild:_label];
        
        _label = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        _label.fontSize = 30;
        _label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-105);
        _label.fontColor = [SKColor colorWithHue:0 saturation:0 brightness:1 alpha:1];
        if(score > 1){
            _label.text = [NSString stringWithFormat:@"brides"];
        }else{
            _label.text = [NSString stringWithFormat:@"bride =("];
        }
        [self addChild:_label];
        
        _label = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        _label.text = @"You also got a mother-in-law.";
        _label.fontSize = 15;
        _label.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMinY(self.frame)+50);
        _label.fontColor = [SKColor colorWithHue:0 saturation:0 brightness:1 alpha:1.0];
        [self addChild:_label];
        
        _label = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        _label.text = @"Better try again.";
        _label.fontSize = 20;
        _label.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMinY(self.frame)+30);
        _label.fontColor = [SKColor colorWithHue:0 saturation:0 brightness:1 alpha:1.0];
        [self addChild:_label];
        
        [self runAction:[SKAction playSoundFileNamed:@"marcha.mp3" waitForCompletion:NO]];

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
    [self runAction:[SKAction sequence:@[
                                         [SKAction runBlock: ^{
        BAMenuScene *menu = [[BAMenuScene alloc] initWithSize:self.size];
        [self.view presentScene:menu transition:[SKTransition doorsCloseHorizontalWithDuration:0.5]];
    }]
                                         ]]];
}

@end
