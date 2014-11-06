//
//  BAMenuScene.m
//  Orbivoid
//
//  Created by Lucas Oliveira on 15/07/14.
//  Copyright (c) 2014 pingdiff. All rights reserved.
//

#import "BAMenuScene.h"
#import "BAGameScene.h"

@implementation BAMenuScene
- (instancetype)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size]) {
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height >= 1136) {
            SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"lauch1136x640.png"];
            background.size = size;
            background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            [self addChild:background];
        } else {
            SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"lauch.png"];
            background.size = size;
            background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            [self addChild:background];
        }
        
        SKLabelNode *tapToPlay = [SKLabelNode labelNodeWithFontNamed:@"Avenir-Black"];
        
        tapToPlay.text = @"Tap to play";
        tapToPlay.fontSize = 30;
        tapToPlay.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+80);
        tapToPlay.fontColor = [SKColor colorWithHue:0 saturation:0 brightness:1 alpha:0.9];
        
        [self addChild:tapToPlay];
        
        SKLabelNode *subtitle = [SKLabelNode labelNodeWithFontNamed:@"Avenir-Black"];
        subtitle.text = @"Drag the groom and avoid the brides";
        subtitle.fontSize = 12;
        subtitle.position = CGPointMake(CGRectGetMidX(self.frame),
                                     CGRectGetMinY(self.frame)+50);
        subtitle.fontColor = [SKColor colorWithHue:0 saturation:0 brightness:1 alpha:1.0];
        [self addChild:subtitle];
        
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BAGameScene *game = [[BAGameScene alloc] initWithSize:self.size];
    game.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:game transition:[SKTransition doorwayWithDuration:0.5]];
}
@end
