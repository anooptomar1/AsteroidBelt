//
//  InteractionScene.swift
//  Interaction
//
//  Created by Nadia Yudina on 3/13/16.
//  Copyright © 2016 Nadia. All rights reserved.
//

import UIKit
import SceneKit
import GameplayKit

enum CollisionCategory: Int {
    /*
    Logical categories of bodies to provide physics collision detection
    */
    case
    Asteroid = 2,
    Ship = 3
    
}

class GameScene: SCNScene {
    /*
    This class is the scene class, which serves as a container for other nodes.
    The scene is a graph of nodes, where self.rootNode serves as a root node.
    Each node in the scene can have it's own children.
    */
    
    let spaceshipEntity = SpaceshipEntity()
    
    var isShowingShip = true
    var isShowingAsteroids = false
    
    let moveAction: SCNAction = SCNAction.moveBy(SCNVector3(0, 0, 60), duration: 5)
    
    override init() {
        super.init()
        self.createStar()
        self.setupWorld()
        self.setupSpaceship()
        self.physicsWorld.gravity = SCNVector3Zero
    }
    
    func startGame() {
        /*
        Function to start the asteroid spawn
        */
        
        if (!self.isShowingAsteroids) {
            
            //create the node to run spawn action from
            let emptyActionNode = SCNNode()
            self.rootNode.addChildNode(emptyActionNode)
            
            //creates SCNAction from spawn asteroids function
            let blockAction = SCNAction.runBlock { (node) -> Void in
                self.spawnAsteroids()
            }
            
            let waitAction = SCNAction.waitForDuration(0.5) //creates waiting action
            let actionSequence = SCNAction.sequence([blockAction, waitAction]) //creates sequence of block and wait acitons
            let repeatSequence = SCNAction.repeatActionForever(actionSequence) //repeats the sequence indefinetely
            
            emptyActionNode.runAction(repeatSequence) //run repeate action on empty node
            self.isShowingAsteroids = true
        }
        
        if (!self.isShowingShip) {
            self.setupSpaceship()
        }
    }
    
    func stopGame() {
        self.spaceshipEntity.node?.removeFromParentNode()
        self.isShowingShip = false
    }
    
    private func setupSpaceship() {
        /*
        Function to add spaceship node to the scene
        */
        
        guard let node = self.spaceshipEntity.node else {
            return
        }
        
        node.position = SCNVector3(0, 0, 0) //position it at the center of the scene
        node.rotation = SCNVector4(x: 0, y: 1, z: 0, w: Float(M_PI)) //crete a tilt to look at the node from above
        self.rootNode.addChildNode(node)
    }
    
    private func setupWorld() {
        /*
        Setup the scene with light and camera
        */
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera() //defines a point of view
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0) //position camera at the center of the scene
        cameraNode.pivot = SCNMatrix4MakeTranslation(0, -0.5, -5) //we ancor the camera at -0.5 y and -5 z coordinate
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient //set type of the light to ambient
        ambientLightNode.light!.color = UIColor.whiteColor() //set color of the light to white
        self.rootNode.addChildNode(ambientLightNode) //add ambient light to scene
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = SCNLightTypeSpot //create spotlight
        lightNodeSpot.position = SCNVector3(x: 30, y: 30, z: 30) //position the light
        
        let empty = SCNNode()
        empty.position = SCNVector3Zero
        
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: empty)] //spotlight should always look at this empty node
        
        //add nodes to the scene
        self.rootNode.addChildNode(empty)
        self.rootNode.addChildNode(cameraNode)
        self.rootNode.addChildNode(lightNodeSpot)
        
        //initialize particle system from StarsSystem.scnp file
        if let stars = SCNParticleSystem(named: "StarsSystem.scnp", inDirectory: nil) {
            self.rootNode.addParticleSystem(stars)
        }
    }
    
    private func spawnAsteroids() {
        /*
        Function to spawn asteroids in the center of the scene
        */
        
        let asteroid = AsteroidEntity() //create asteroid entity
        
        guard let asteroidNode = asteroid.renderComponent?.node, let position = asteroid.spawnComponent?.positionVector else {
            return
        }
        
        asteroidNode.position = position
        self.rootNode.addChildNode(asteroidNode)
        //reference move object function from move component
        asteroid.moveComponent?.moveObjectPastCamera()
        
    }
    
    private func createStar() {
        /*
        Function to create a star on top of the scene
        */
        
        let star = SCNSphere(radius: 1) //create a spheric geometry
        let starNode = SCNNode(geometry: star) //create a node with star geometry
        starNode.position = SCNVector3(0, 7, -10) //specify the position of the node
        self.rootNode.addChildNode(starNode) //add node to the scene's root node
        
        star.firstMaterial?.diffuse.contents = UIColor.starRedColor() //set diffuse material property to the color
        star.firstMaterial?.normal.contents = UIImage(named: "star_normal_map") //use normal map from project's directory as normal map for star material
        star.firstMaterial?.specular.contents = UIImage(named: "star_specular_map") //use specular map from project's directory as specular map
        star.firstMaterial?.emission.contents = UIColor.starRedColor() //emission property gives the material a shiny appearance, but does not light other nodes in the scene
        
        let starLight = SCNLight() //default is omnilight
        starNode.light = starLight //add omnilight to the star node
        
        //rotate action turns the node around the axis:
        //first argument - is the radians to turn 
        //second argument - vector of x, y and z coordinates, the axis to rotate around is set to 1
        //third argument - duration of the turn
        let rotateAction = SCNAction.rotateByAngle(CGFloat(M_PI * 2), aroundAxis: SCNVector3(0, 1, 0), duration: 60)

        //create action as repetition of rotate action
        let repeatedAction = SCNAction.repeatActionForever(rotateAction)
        starNode.runAction(repeatedAction) //add repeated action to the star node
        
        if let starFire = SCNParticleSystem(named: "StarFire.scnp", inDirectory: nil) {
            starNode.addParticleSystem(starFire)
        }
    }
    
    //this function is required to properly initialize a scene subclass
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}










