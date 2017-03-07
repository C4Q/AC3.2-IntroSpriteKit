//
//  SunnyDayScene.swift
//  IntroSpriteKit
//
//  Created by Louis Tur on 3/6/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import SpriteKit

class SunnyDayScene: SKScene {
  
  let backgroundTexture: SKTexture = SKTexture(imageNamed: "bkgd_sunnyday")
  let catStandingTexture: SKTexture = SKTexture(imageNamed: "moving_kitty_1")
  let catStridingTexture: SKTexture = SKTexture(imageNamed: "moving_kitty_2")
  
  var catTextureAtlas: SKTextureAtlas?
  
  var backgroundNode: SKSpriteNode?
  var catNode: SKSpriteNode?

  override init(size: CGSize) {
    super.init(size: size)
    
    print("init")
    self.backgroundColor = .gray

      }
  
  override func didMove(to view: SKView) {
    print("DidMove")
    
    guard
      let cat1: UIImage = UIImage(named: "moving_kitty_1"),
      let cat2: UIImage = UIImage(named: "moving_kitty_2")
      else { return }
    
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
    self.catNode!.anchorPoint = self.backgroundNode!.anchorPoint
    self.catNode!.setScale(0.2)
    
    self.addChild(self.backgroundNode!)
    self.addChild(self.catNode!)

    
//    let walkingAnimation = SKAction.animate(with: catTextureAtlas!.textureNames.map{ catTextureAtlas!.textureNamed($0) }, timePerFrame: 0.5)
    let walkingAnimation = SKAction.animate(with: [catStand, catStride], timePerFrame: 0.5)
    let infiniteAnimation = SKAction.repeatForever(walkingAnimation)
    
    self.catNode?.zPosition = 100
    

    catNode?.run(infiniteAnimation)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Touches -
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let validTouch = touches.first else { return }
    
    let moveAction = SKAction.move(to: validTouch.location(in: self), duration: 1.0)
//    self.catNode?.run(moveAction)
    
    let catTwit = SKAction.playSoundFileNamed("cat_twit.wav", waitForCompletion: false)
//    self.catNode?.run(catTwit)
    
    let groupAction = SKAction.group([moveAction, catTwit])
    self.catNode?.run(groupAction)
  }
  
}
