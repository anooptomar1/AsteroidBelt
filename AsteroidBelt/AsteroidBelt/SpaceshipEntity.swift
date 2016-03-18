//
//  SpaceshipEntity.swift
//  Interaction
//
//  Created by Nadia Yudina on 3/13/16.
//  Copyright © 2016 Nadia. All rights reserved.
//

import UIKit
import GameplayKit
import SceneKit


class SpaceshipEntity: GKEntity {
    /*
    This subclass of GKEntity manages components for spaceship
    */
    
    weak var node: SCNNode?
    
    var renderComponent: RenderComponent?
    
    override init() {
        /*
        Initialize spaceship entity
        */

        super.init()
        
        //create render component
        self.renderComponent = RenderComponent(fromSceneNamed: "art.scnassets/ship.scn", nodeNamed: "ship", scale: 0.25)
        
        //create reference to render component's node
        self.node = self.renderComponent?.node
        
        //set node's position
        self.node?.position = SCNVector3(0, 0, 0)
        self.node?.rotation = SCNVector4(x: 0, y: 1, z: 0, w: Float(M_PI))
        
        //setup physics body
        self.node?.physicsBody = SCNPhysicsBody.kinematicBody()
        self.node?.physicsBody?.categoryBitMask = CollisionCategory.Ship.rawValue
        self.node?.physicsBody?.contactTestBitMask = CollisionCategory.Asteroid.rawValue
    }

}










