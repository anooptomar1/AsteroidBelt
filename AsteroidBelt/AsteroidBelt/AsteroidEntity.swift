//
//  AsteroidEntity.swift
//  Interaction
//
//  Created by Nadia Yudina on 3/13/16.
//  Copyright © 2016 Nadia. All rights reserved.
//

import UIKit
import GameplayKit
import SceneKit


class AsteroidEntity: GKEntity {
    /*
    This subclass of GKEntity manages components for asteroid
    */
    
    weak var node: SCNNode? //refernce to SCNNode associated with this entity
    
    //references to components
    var renderComponent: RenderComponent?
    var spawnComponent: SpawnComponent?
    var moveComponent: MoveComponent?
    
    override init() {
        /*
        Initialize asteroid entity
        */
        
        super.init()
        
        //create sphere geometry with random radius
        let randomRadius = randomFloat(1.0, secondNum: 2.5)
        let sphere = SCNSphere(radius: randomRadius)
        
        //initialize components
        self.renderComponent = RenderComponent(geometry: sphere)
        self.spawnComponent = SpawnComponent()
        
        //create reference to a node from render component
        self.node = self.renderComponent?.node
        self.node?.name = "asteroid"
        
        self.moveComponent = MoveComponent(node: self.node)
        
        //add physics body
        self.node?.physicsBody = SCNPhysicsBody.dynamicBody()
        self.node?.physicsBody?.categoryBitMask = CollisionCategory.Asteroid.rawValue
        self.node?.physicsBody?.contactTestBitMask = CollisionCategory.Ship.rawValue
        
    }

}
