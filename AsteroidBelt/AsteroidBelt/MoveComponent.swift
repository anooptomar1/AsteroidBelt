//
//  ActionComponent.swift
//  Interaction
//
//  Created by Nadia Yudina on 3/13/16.
//  Copyright © 2016 Nadia. All rights reserved.
//

import UIKit
import GameplayKit
import SceneKit

class MoveComponent: GKComponent {
    /*
    This subclass of GameplayKit component provides the method to move the object
    */
    
    var node: SCNNode?
    
    init(node: SCNNode?) {
        super.init()
        if let node = node {
            self.node = node
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveObjectPastCamera() {
        /*
        Function to move the object past camera position. 
        Using this funciton will move the entity's node towards the viewer
        */
        
        let moveAction: SCNAction = SCNAction.move(by: SCNVector3(0, 0, 60), duration: 5)
        let opacityAction = SCNAction.fadeOpacity(to: 1, duration: 0.5)
        let groupAction = SCNAction.group([moveAction, opacityAction])
        let moveRemoveSequence = SCNAction.sequence([groupAction, SCNAction.removeFromParentNode()])
        self.node?.runAction(moveRemoveSequence)
    }

}
