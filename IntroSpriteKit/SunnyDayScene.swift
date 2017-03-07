//
//  SunnyDayScene.swift
//  IntroSpriteKit
//
//  Created by Louis Tur on 3/6/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import SpriteKit

struct CollisionMasks {
  static let cat: UInt32 = 0x1 << 0
  static let fish: UInt32 = 0x1 << 1
}

class SunnyDayScene: SKScene, SKPhysicsContactDelegate {
  
  let backgroundTexture: SKTexture = SKTexture(imageNamed: "bkgd_sunnyday")
  let catStandingTexture: SKTexture = SKTexture(imageNamed: "moving_kitty_1")
  let catStridingTexture: SKTexture = SKTexture(imageNamed: "moving_kitty_2")
  let fishTexture: SKTexture = SKTexture(imageNamed: "fish")
  
  let scoreLabel: SKLabelNode = SKLabelNode(text: "Score")
  let scorePointsLabel: SKLabelNode = SKLabelNode(text: "0")
  let flameParticleEmitter: SKEmitterNode = SKEmitterNode(fileNamed: "fireball.sks")!
  
  var catTextureAtlas: SKTextureAtlas?
  
  var backgroundNode: SKSpriteNode?
  var catNode: SKSpriteNode?
  var fishNode: SKSpriteNode?

  override init(size: CGSize) {
    super.init(size: size)
    
    print("init")
    self.backgroundColor = .gray
    self.physicsWorld.contactDelegate = self
  }
  
  override func didMove(to view: SKView) {
    print("DidMove")
    
//    guard
//      let cat1: UIImage = UIImage(named: "moving_kitty_1"),
//      let cat2: UIImage = UIImage(named: "moving_kitty_2")
//      else { return }
    
//    self.catTextureAtlas = SKTextureAtlas(dictionary: [ "cat1" : cat1, "cat2" : cat2])
    
    
    self.catTextureAtlas = SKTextureAtlas(named: "moving_kitty")
    let catStand = self.catTextureAtlas!.textureNamed("moving_kitty_1")
    let catStride = self.catTextureAtlas!.textureNamed("moving_kitty_2")
    
    // initializing and setting the background node's texture
    self.backgroundNode = SKSpriteNode(texture: backgroundTexture)
    self.backgroundNode?.anchorPoint = self.anchorPoint
    self.backgroundNode?.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
    
    
//    self.catNode = SKSpriteNode(texture: self.catTextureAtlas!.textureNamed("cat1"))
    self.catNode = SKSpriteNode(texture: catStand)
    self.catNode!.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
//    self.catNode!.anchorPoint = self.backgroundNode!.anchorPoint
    self.catNode!.setScale(0.2)
    
    self.fishNode = SKSpriteNode(texture: self.fishTexture)
    self.fishNode?.setScale(0.2)
    self.fishNode?.zPosition = 101
    self.fishNode?.position = CGPoint(x: self.view!.frame.midX, y: 90.0)
    
    let fishPhysics = SKPhysicsBody(texture: self.fishNode!.texture!, size: self.fishNode!.size)
    fishPhysics.affectedByGravity = false
    fishPhysics.categoryBitMask = CollisionMasks.fish
    fishPhysics.collisionBitMask = CollisionMasks.cat
    fishPhysics.contactTestBitMask = CollisionMasks.cat
    fishNode?.physicsBody = fishPhysics
    
    self.addChild(self.backgroundNode!)
    self.addChild(self.catNode!)
    self.addChild(self.fishNode!)
    
//    let walkingAnimation = SKAction.animate(with: catTextureAtlas!.textureNames.map{ catTextureAtlas!.textureNamed($0) }, timePerFrame: 0.5)
    let walkingAnimation = SKAction.animate(with: [catStand, catStride], timePerFrame: 0.5)
    let infiniteAnimation = SKAction.repeatForever(walkingAnimation)
    
    self.catNode?.zPosition = 100
    

    catNode?.run(infiniteAnimation)
    
    
    let catPhysicsBody: SKPhysicsBody = SKPhysicsBody(texture: self.catNode!.texture!, size: self.catNode!.size)
    catPhysicsBody.affectedByGravity = false
    catPhysicsBody.categoryBitMask = CollisionMasks.cat
    catPhysicsBody.contactTestBitMask = CollisionMasks.cat
    catPhysicsBody.collisionBitMask = CollisionMasks.cat
    
    catNode?.physicsBody = catPhysicsBody
    
    let constraintY = SKConstraint.positionY(SKRange(lowerLimit: 0.0 + (0.5 * self.catNode!.size.height), upperLimit: 300.0))
    let constraintX = SKConstraint.positionX(SKRange(lowerLimit: 0.0 + (0.5 * self.catNode!.size.width),
                                                     upperLimit: self.view!.frame.maxX - (0.5 * self.catNode!.size.width)))
    catNode?.constraints = [constraintY, constraintX]
    
    flameParticleEmitter.name = "kitty_on_fire"
    flameParticleEmitter.targetNode = self.catNode
    flameParticleEmitter.position = CGPoint(x: 0.0, y: -50.0)
    catNode?.addChild(flameParticleEmitter)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Touches -
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let validTouch = touches.first else { return }
    let touchLocation = validTouch.location(in: self)
    
    let moveAction = SKAction.move(to: touchLocation, duration: 1.0)
    let catTwit = SKAction.playSoundFileNamed("cat_twit.wav", waitForCompletion: false)
    
    let currentCatXPos = self.catNode!.position.x
    if currentCatXPos < touchLocation.x {
      // turn right
      self.catNode?.xScale = fabs(self.catNode!.xScale) * -1.0
    }
    else {
      // turn left
      self.catNode?.xScale = fabs(self.catNode!.xScale) * 1.0
    }
    
    let groupAction = SKAction.group([moveAction, catTwit])
    self.catNode?.run(groupAction)
  }
  
  // MARK: - Contact - 
  
  func didBegin(_ contact: SKPhysicsContact) {
    print("Sprites touching!!")

  }
  
  func didEnd(_ contact: SKPhysicsContact) {
    print("Not touching!")
  }
}
