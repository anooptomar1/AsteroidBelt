//
//  SpawnComponent.swift
//  Interaction
//
//  Created by Nadia Yudina on 3/13/16.
//  Copyright © 2016 Nadia. All rights reserved.
//

import UIKit
import GameplayKit
import SceneKit

class SpawnComponent: GKComponent {
    /*
    This subclass of GameplayKit component is responsible for creating a position for node spawn
    */
    
    private let zPosition: Float = -50 //z coordinate is always far from the viewer
    var positionVector = SCNVector3Zero
    
    override init() {
        /*
        When component is initialized, it creates a 3 coordinate vector position, 
        where x and y coordinates are random between 
        */
        
        super.init()
        
        //creates random position across x axis
        var xPosition:Float = (Float(arc4random_uniform(5)) * -2.0) + 2.0
        if xPosition == 0 {
            xPosition = 2
        }
        
        //creates random position across y axis
        let yPosition:Float = (Float(arc4random_uniform(4)) * -2.0) + 2.0
        
        //vector with random x and y positions
        self.positionVector = SCNVector3(xPosition, yPosition, self.zPosition)
    }
    
}
