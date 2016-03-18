//
//  RenderComponent.swift
//  Interaction
//
//  Created by Nadia Yudina on 3/13/16.
//  Copyright © 2016 Nadia. All rights reserved.
//

import UIKit
import GameplayKit
import SceneKit

class RenderComponent: GKComponent {
    /*
    This subclass of GameplayKit component is responsible for rendering of the nodes
    */
    
    var node: SCNNode?
    
    init(fromSceneNamed: String, nodeNamed: String, scale: CGFloat) {
        /*
        The function to initialize RenderComponent using the model from 3D scene
        */
        
        guard let scene = SCNScene(named: fromSceneNamed), let node = scene.rootNode.childNodeWithName(nodeNamed, recursively: true) else {
            return
        }
        
        node.scale = SCNVector3(scale, scale, scale)
        self.node = node
    }
    
    init(geometry: SCNGeometry) {
        /*
        The function to initialize RenderComponent using the geometry
        */
        
        super.init()
        
        /*
        The maps are located in Resources group in Assets.xcassets.
        The name of each map is consists of  map's number and ending with map type (diffuse, normal or specular). Example: "1_diffuse"
        */
        
        let randomMap = randomInt(1, highest: 5)
        
        geometry.firstMaterial?.diffuse.contents = self.fetchDiffuseMap(randomMap)
        geometry.firstMaterial?.normal.contents = self.fetchNormalMap(randomMap)
        geometry.firstMaterial?.specular.contents = self.fetchSpecularMap(randomMap)
        self.node = SCNNode(geometry: geometry)
        self.node?.opacity = 0
    }
    
    private func fetchDiffuseMap(number: Int) -> UIImage? {
        /*
        Creates diffuse map image for number of the map
        */

        return UIImage(named: String(number) + "_diffuse")
    }
    
    private func fetchNormalMap(number: Int) -> UIImage? {
        /*
        Creates normal map image for number of the map
        */
        
        return UIImage(named: String(number) + "_norm")
    }
    
    private func fetchSpecularMap(number: Int) -> UIImage? {
        /*
        Creates specular map image for number of the map
        */
        
        return UIImage(named: String(number) + "_specular")
    }
    

}
