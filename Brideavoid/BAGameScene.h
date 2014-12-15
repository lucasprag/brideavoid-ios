//
//  BAGameScene.h
//  Brideavoid
//
//  Created by Lucas Oliveira on 7/25/14.
//  Copyright (c) 2014 pingdiff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BAGameScene : SKScene
@end

@interface SKEmitterNode (fromFile)
+ (instancetype)orb_emitterNamed:(NSString*)name ofType:(NSString*)type;
@end
