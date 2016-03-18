//
//  GameViewController.swift
//  Interaction
//
//  Created by Nadia Yudina on 3/13/16.
//  Copyright (c) 2016 Nadia. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import GameplayKit


class GameViewController: UIViewController, SCNPhysicsContactDelegate {
    /*
    Subclass of UIViewController which manages a set of views that make up a portion of your app’s user interface
    */

    //references to UI elements from view
    @IBOutlet weak var sceneView: SCNView?
    @IBOutlet weak var gameOverLabel: UILabel?
    @IBOutlet weak var healthLabel: UILabel?
    @IBOutlet weak var scoreLabel: UILabel?
    @IBOutlet weak var playButton: UIButton?
    
    //initialize an instance of game scene
    let scene = GameScene()
    
    //inititialize particle system from file
    let explosionSystem = SCNParticleSystem(named: "ExplosionSystem.scnp", inDirectory: nil)
    
    //variables to manage the state of the game
    private var isPlaying = false
    private var step = 1
    
    //variable which manages score label
    private var score: Int = 0 {
        didSet {
            self.scoreLabel?.text = "Score: \(self.score)"
        }
    }
    
    //variable to manage health
    private var health: Int = 100 {
        didSet {
            self.healthLabel?.text = "Health: \(self.health)"
            if self.health <= 0 {
                self.scene.stopGame()
                self.playButton?.hidden = false
                self.playButton?.enabled = true
                self.gameOverLabel?.hidden = false
                guard let explosion = self.explosionSystem else {
                    return
                }
                self.scene.rootNode.addParticleSystem(explosion)
            }
        }
    }

    override func viewDidLoad() {
        /*
        App's lifecycle method, configure initial state here
        */
        
        super.viewDidLoad()
        self.sceneView?.scene = self.scene
        self.scene.physicsWorld.contactDelegate = self
        self.score = 0
        self.health = 100
        self.gameOverLabel?.hidden = true
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.sceneView?.addGestureRecognizer(tapGesture)
        
    }
    
    func handleTap(sender: UIGestureRecognizer) {
        /*
        Function to handle the tap action
        */
        
        let location = sender.locationInView(sender.view)
        //if there is a node at hit location
        guard let hitResults = self.sceneView?.hitTest(location, options: nil), let result = hitResults.first else {
            return
        }
        
        //add code to process touched node
        if result.node.name == "asteroid" { //if the name of this node is "asteroid"
            result.node.removeFromParentNode() //remove node from scene
            self.score += 10 //icrease the score
        }
    }
    
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {
        /*
        A delegate method, which is called when there is a contact event in physics world
        */
        
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            //decrease health
            self?.health -= 1
        })
    }
    
    @IBAction func didTapStartButton(sender: AnyObject) {
        /*
        This function is called when the button is tapped
        */
        
        if !self.isPlaying {
            self.scene.startGame()
            self.health = 100
            self.score = 0
            self.playButton?.hidden = true
            self.playButton?.enabled = false
            self.gameOverLabel?.hidden = true
        }
    }
    
    
    /*
    Functions to configure the behavior of the app
    */
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

}
