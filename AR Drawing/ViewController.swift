//
//  ViewController.swift
//  AR Drawing
//
//  Created by Dongcheng Deng on 2018-03-24.
//  Copyright © 2018 Showpass. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

  @IBOutlet weak var sceneView: ARSCNView!
  @IBOutlet weak var button: UIButton!
  let configuration = ARWorldTrackingConfiguration()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
    sceneView.showsStatistics = true
    sceneView.session.run(configuration)
    
    sceneView.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
    guard let pointOfView = sceneView.pointOfView else { return }
    
    let transform = pointOfView.transform
    let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
    let location = SCNVector3(transform.m41, transform.m42, transform.m43)
    
    let currentPositionOfCamera = orientation + location
    
    DispatchQueue.main.async {
      if self.button.isHighlighted {
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
        sphereNode.position = currentPositionOfCamera
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
      } else {
        self.sceneView.scene.rootNode.enumerateChildNodes( { (node, _) in
          if node.name == "pointer" {
            node.removeFromParentNode()
          }
        })
        
        let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
        pointer.name = "pointer"
        pointer.position = currentPositionOfCamera
        pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        self.sceneView.scene.rootNode.addChildNode(pointer)
      }
    }
    
    
  }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
