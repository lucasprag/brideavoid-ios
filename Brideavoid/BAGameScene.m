//
//  BAGameScene.m
//  Brideavoid
//
//  Created by Lucas Oliveira on 7/25/14.
//  Copyright (c) 2014 pingdiff. All rights reserved.
//

#import "BAGameScene.h"
#import "CGVector+TC.h"
#import "BAScore.h"

enum {
    CollisionPlayer = 1<<1,
    CollisionEnemy = 1<<2,
};

@implementation BAGameScene
{
    BOOL _dead;
    SKNode *_player;
    NSMutableArray *_enemies;
    SKLabelNode *_scoreLabel;
    CGSize _players_sizes;
    CGSize _body_players_sizes;
}

-(id)initWithSize:(CGSize)size {
    _players_sizes = CGSizeMake(50,50);
    _body_players_sizes = CGSizeMake(30,30);
    
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"backgroud.png"];
        bg.size = self.frame.size;
        bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:bg];
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        _enemies = [NSMutableArray new];
        _player = [SKNode node];
        SKShapeNode *circle = [SKShapeNode node];
        circle.position = CGPointMake(size.width/2, size.height/2);
        circle.fillColor = [UIColor blueColor];
        circle.strokeColor = [UIColor blueColor];
        circle.glowWidth = 2;
        
        SKSpriteNode *groom = [SKSpriteNode spriteNodeWithImageNamed:@"groom.png"];
        groom.size = _players_sizes;
        groom.position = CGPointMake(0, 0);
        
        _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: _body_players_sizes];
        _player.physicsBody.mass = 100000;
        _player.physicsBody.categoryBitMask = CollisionPlayer;
        _player.physicsBody.contactTestBitMask = CollisionEnemy;
        
        [_player addChild:groom];
        
        _player.position = CGPointMake(size.width/2, size.height-90);
        
        [self addChild:_player];
    }
    return self;
}


-(void)didMoveToView:(SKView *)view{
    [self performSelector:@selector(spawnEnemy) withObject:nil afterDelay:1];
}

-(void)spawnEnemy{
//    adicionar um som bem legal
//    [self runAction:[SKAction playSoundFileNamed:@"Spawn.wav" waitForCompletion:NO]];
    
    SKNode *enemy = [SKNode node];
    SKSpriteNode *bride = [SKSpriteNode spriteNodeWithImageNamed:@"bride.png"];
    bride.size = _players_sizes;
    bride.position = CGPointMake(0, 10);
    
    [enemy addChild:bride];
    enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: _body_players_sizes];
    enemy.physicsBody.categoryBitMask = CollisionEnemy;
    enemy.physicsBody.allowsRotation = NO;
    
    enemy.position = CGPointMake(self.frame.size.width/2, 30);
    
    [_enemies addObject:enemy];
    [self addChild:enemy];
    
    if(!_scoreLabel){
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        _scoreLabel.fontSize = 400;
        _scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100);
        _scoreLabel.fontColor = [SKColor colorWithHue:0 saturation:0 brightness:1 alpha:0.2];
        [self addChild:_scoreLabel];
    }
    
    _scoreLabel.text = [NSString stringWithFormat:@"%02d", _enemies.count];
    
    [self runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:5],
                                         [SKAction performSelector:@selector(spawnEnemy) onTarget:self]
                                         ]]];
}

SKAction *explosionAction(SKEmitterNode *explosion, CGFloat duration, dispatch_block_t removal)
{
    return [SKAction sequence:@[
                                [SKAction waitForDuration:duration/2],
                                [SKAction runBlock:removal],
                                [SKAction waitForDuration:duration/2],
                                [SKAction runBlock:^{
        explosion.particleBirthRate = 0;
    }],
                                [SKAction waitForDuration:duration]
                                ]];
}

- (void)dieFrom:(SKNode*)killingEnemy
{
    _dead = YES;
    
    [_player runAction:[SKAction sequence:@[
        [SKAction runBlock: ^{
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setInteger:_enemies.count forKey:@"score"];
            BAScore *score = [[BAScore alloc] initWithSize:self.size];
            score.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:score transition:[SKTransition revealWithDirection:SKTransitionDirectionDown duration:0.5]];
        }]]]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [_player runAction:[SKAction moveTo:[[touches anyObject] locationInNode:self] duration:.1]];
}

-(void)update:(CFTimeInterval) currentTime {
    CGPoint playerPos = _player.position;
    
    for(SKNode *enemyNode in _enemies){
        CGPoint enemyPos = enemyNode.position;
        
        /* uniform speed */
        CGVector diff = TCVectorMinus(playerPos, enemyPos);
        CGVector normalized = TCVectorUnit(diff);
        CGVector force = TCVectorMultiply(normalized, 4);
        
        [enemyNode.physicsBody applyForce:force];
    }
    _player.physicsBody.velocity = CGVectorMake(0, 0);
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if(_dead)
        return;
    
    [self dieFrom:contact.bodyB.node];
    contact.bodyB.node.physicsBody = nil;
}

@end

@implementation SKEmitterNode (fromFile)
+ (instancetype)orb_emitterNamed:(NSString*)name ofType:(NSString*)type {
    return [NSKeyedUnarchiver unarchiveObjectWithFile: [[NSBundle mainBundle] pathForResource:name ofType:type]];
}
@end