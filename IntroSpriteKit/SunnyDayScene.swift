//
//  SunnyDayScene.swift
//  IntroSpriteKit
//
//  Created by Louis Tur on 3/6/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import SpriteKit

struct SceneCategories {
  static let fish: UInt32 = 0x1 << 0 // 0
  static let cat: UInt32 = 0x1 << 1  // 1
  static let dog: UInt32 = 0x1 << 2 // 2
  static let bird: UInt32 = 0x1 << 3 // 4
}

class SunnyDayScene: SKScene, SKPhysicsContactDelegate {
  
  let backgroundTexture: SKTexture = SKTexture(imageNamed: "bkgd_sunnyday")
  let catStandingTexture: SKTexture = SKTexture(imageNamed: "moving_kitty_1")
  let catStridingTexture: SKTexture = SKTexture(imageNamed: "moving_kitty_2")
  let fishTexture: SKTexture = SKTexture(imageNamed: "fish")
  
  var backgroundNode: SKSpriteNode?
  var catNode: SKSpriteNode?
  var fishNode: SKSpriteNode?

  override init(size: CGSize) {
    super.init(size: size)
//    print("init")
    self.backgroundColor = .gray
    self.physicsWorld.contactDelegate = self
  }
  
  override func didMove(to view: SKView) {
//    print("DidMove")
    // initializing and setting the background node's texture
    self.backgroundNode = SKSpriteNode(texture: backgroundTexture)
    self.backgroundNode?.anchorPoint = self.anchorPoint
    
    // Cat Texture Atlas
//    let catTextureAtlas: SKTextureAtlas = SKTextureAtlas(dictionary:
//      [ "cat1": UIImage(named: "moving_kitty_1")!,
//        "cat2" : UIImage(named: "moving_kitty_2")!]
//    )
    
    let catTextureAtlas: SKTextureAtlas = SKTextureAtlas(named: "moving_kitty")
    print(catTextureAtlas.textureNames)
    let catStanding = catTextureAtlas.textureNamed("moving_kitty_1")
    let catStriding = catTextureAtlas.textureNamed("moving_kitty_2")
    
//    self.catNode = SKSpriteNode(texture: catTextureAtlas.textureNamed("cat1") )
    self.catNode = SKSpriteNode(texture: catStanding )
    
    self.fishNode = SKSpriteNode(texture: fishTexture)
    self.fishNode?.zPosition = 99
    self.fishNode?.setScale(0.2)
    self.fishNode?.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 100.0)
    
    let fishPhysics = SKPhysicsBody(texture: self.fishTexture, size: self.fishNode!.size)
    fishPhysics.collisionBitMask = SceneCategories.fish
    fishPhysics.contactTestBitMask = SceneCategories.fish
    self.fishNode?.physicsBody = fishPhysics
    self.fishNode?.physicsBody?.affectedByGravity = false // true
    
//    self.catNode = SKSpriteNode(texture: catStandingTexture)
    //    self.catNode!.anchorPoint = self.backgroundNode!.anchorPoint
    self.catNode!.setScale(0.2)
    self.catNode!.zPosition = 100
    self.catNode!.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
    
    self.addChild(self.backgroundNode!)
    self.backgroundNode!.addChild(self.catNode!)
    self.backgroundNode!.addChild(self.fishNode!)
    
    let walkingAnimation = SKAction.animate(with: [catStanding, catStriding], timePerFrame: 0.5)
//    let walkingAnimation = SKAction.animate(with: catTextureAtlas.textureNames.map{ catTextureAtlas.textureNamed($0) }, timePerFrame: 0.5)
    let infiniteAnimation = SKAction.repeatForever(walkingAnimation)
    
    catNode?.run(infiniteAnimation)
    
    let xRange = SKRange(lowerLimit: catNode!.size.width / 2.0, upperLimit: self.frame.maxX - (catNode!.size.width / 2.0))
    let yRange = SKRange(lowerLimit: catNode!.size.height / 2.0, upperLimit: 300 - (catNode!.size.height / 2.0))
    let grassConstraints = SKConstraint.positionX(xRange, y: yRange)
    catNode?.constraints = [grassConstraints]
    fishNode?.constraints = [grassConstraints]
    
    // Particle Effects
    let emitterNode: SKEmitterNode = SKEmitterNode(fileNamed: "MagicKitty.sks")!
    emitterNode.targetNode = self.catNode
    self.catNode?.addChild(emitterNode)
    
    // Physics
    let catPhysicsBody = SKPhysicsBody(texture: self.catNode!.texture!, size: self.catNode!.size)
    catPhysicsBody.collisionBitMask = SceneCategories.fish
    catPhysicsBody.contactTestBitMask = SceneCategories.cat
    catNode?.physicsBody = catPhysicsBody
    catNode!.physicsBody!.affectedByGravity = false // true
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Contact Delegate - 
  func didEnd(_ contact: SKPhysicsContact) {
    print("Did end touching")
    
    
    
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    print("Did start touching")
    
    
  }
  
  
  // MARK: - Touches -
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let validTouch = touches.first else { return }
    
    let catXPosition = self.catNode!.position.x
    if catXPosition < validTouch.location(in: self).x {
      catNode?.xScale = fabs(catNode!.xScale) * -1.0
    }
    else {
      catNode?.xScale = fabs(catNode!.xScale)
    }
    
    
    let moveAction = SKAction.move(to: validTouch.location(in: self), duration: 1.0)
    let catTwit = SKAction.playSoundFileNamed("cat_twit.wav", waitForCompletion: false)
    let groupAction = SKAction.group([moveAction, catTwit])
    self.catNode?.run(groupAction)
  }
  
}
