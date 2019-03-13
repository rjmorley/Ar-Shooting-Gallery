//
//  ViewController.swift
//  ARcher
//
//  Created by rj morley on 8/2/18.
//  Copyright © 2018 ___rickjames___. All rights reserved.
//

import UIKit
import ARKit
import FBAudienceNetwork
//import Each

enum BitMaskCategory: Int {
    case arrow = 2
    case target = 3
}

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, FBInterstitialAdDelegate {
    @IBOutlet weak var testLabel: UILabel!
    var interstitialAdView: FBInterstitialAd!
    var TargetIsAdded: Bool = true
    let configuration = ARWorldTrackingConfiguration()
    @IBOutlet weak var ArScene: ARSCNView!
    @IBOutlet weak var TimeLabel: UILabel!
    var power:Float = 1.0
    //let ShotTimer = Each(0.05).seconds
    var playing = true
    var enemyTimer = Timer()
    var TargetTimer = Timer()
    var GameTime = Timer()
    var PlayerHealth = 100
    var Target: SCNNode?
    var score = Int()
    var shots = Int()
    var Time = Int()

    @IBOutlet weak var PointLabel: UILabel!
    
    @IBOutlet weak var playAgainLab: UIButton!
    @IBOutlet weak var GameOverLab: UILabel!
    
    @IBOutlet weak var PlaneDetectionLabel: UILabel!
    @IBAction func PlayAgainButton(_ sender: Any) {
        playAgainLab.isHidden = true
        GameOverLab.isHidden = true
        playing = true
        score = 0
        GamePlay()
        
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.ArScene.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        configuration.planeDetection = .horizontal
        //configuration.worldAlignment = .gravityAndHeading
        self.ArScene.session.run(configuration)
        self.ArScene.autoenablesDefaultLighting = true
        self.ArScene.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.ArScene.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        //self.GenerateEnemy()
        //self.GamePlay()
        self.ArScene.scene.physicsWorld.contactDelegate = self
        
      //  self.interstitialAd = [[FBInterstitialAd alloc] initW
        
        //self.AddTarget(x: 0, y: 0, z: 10)
        self.GameOverLab.isHidden = true
        self.playAgainLab.isHidden = true
        //self.GamePlay()
        self.PlaneDetectionLabel.isHidden = false
        //self.showAd()
        
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        interstitialAdView.show(fromRootViewController: self)
    }
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        print(error)
    }
    func showAd() {
        interstitialAdView = FBInterstitialAd(placementID: "1933990313575698_1934280316880031")
        interstitialAdView.delegate = self
        interstitialAdView.load()
    }
    
  
    
    // Below functions are used for the archer game
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if self.TargetIsAdded == true {
//            ShotTimer.perform { () -> NextStep in
//                self.power = self.power+25
//                return .continue
//            }
//
//        }
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.ShotTimer.stop()
//        self.shootArrow()
//        self.power = 1
//    }
    
    func DisplayGameoverAlert() {
        GameOverLab.isHidden = false
        playAgainLab.isHidden = false
        
        
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact){
        print("contact")
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        DispatchQueue.main.async {
            self.score += 1
            self.PointLabel.text = String(self.score)
        }
        if nodeA.physicsBody?.categoryBitMask == BitMaskCategory.target.rawValue{
           self.Target = nodeA
        }
        else if nodeB.physicsBody?.categoryBitMask == BitMaskCategory.target.rawValue{
           self.Target = nodeB
        }
//        let smoke = SCNParticleSystem(named: "art.scnassets/MyParticle.sks", inDirectory: nil)
//        //smoke?.loops = false
//        smoke?.particleLifeSpan = 1
//        smoke?.emitterShape = Target?.geometry
//        let smokeNode = SCNNode()
//        smokeNode.addParticleSystem(smoke!)
//        smokeNode.position = contact.contactPoint
        //self.ArScene.scene.rootNode.addChildNode(smokeNode)

        Target?.removeFromParentNode()

    }


    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else {return}
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let position = orientation + location
        let bullet = SCNNode(geometry: SCNSphere(radius: 0.08))
        bullet.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        bullet.position = position
        let bulletBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: bullet, options: nil))
        bullet.physicsBody = bulletBody
        var power: Float = 70
        bulletBody.isAffectedByGravity = false
        bullet.physicsBody?.applyForce(SCNVector3(power*orientation.x, power*orientation.y, power*orientation.z), asImpulse: true)
        bullet.physicsBody?.categoryBitMask = BitMaskCategory.arrow.rawValue
        bullet.physicsBody?.contactTestBitMask = BitMaskCategory.target.rawValue
        self.ArScene.scene.rootNode.addChildNode(bullet)
        bullet.runAction(
            SCNAction.sequence([SCNAction.wait(duration: 2.0), SCNAction.removeFromParentNode()])
        )
        shots += 1
        // below is for setting target for v2
//        print("in handle tap")
//        guard let ARScene = sender.view as? ARSCNView else {return}
//        let touchLocation = sender.location(in: ARScene)
//        //print(touchLocation)
//        let hitTestResult = ARScene.hitTest(touchLocation, types: [.existingPlaneUsingExtent])
//        print(hitTestResult)
//        if !hitTestResult.isEmpty {
//            print("tap found")
//           // self.AddTarget(hitTestResult: hitTestResult.first!)
//        }
//        else {
//            print("empty")
//        }
    }
    
    
    
    func AddTarget(x: Float, y: Float, z: Float) {
//        let TargetScene = SCNScene(named: "art.scnassets/TargetScene.scn")
//        let targetNode = (TargetScene?.rootNode.childNode(withName: "Target", recursively: false))!
//        targetNode.position = SCNVector3(x, y, z)
//        targetNode.physicsBody = SCNPhysicsBody.static()
//        targetNode.physicsBody?.categoryBitMask = BitMaskCategory.target.rawValue
//        targetNode.physicsBody?.contactTestBitMask = BitMaskCategory.arrow.rawValue
//        self.ArScene.scene.rootNode.addChildNode(targetNode)
        
        
        let Balloon = SCNNode(geometry: SCNSphere(radius: 0.5))
        Balloon.position = SCNVector3(x, y, z)
        Balloon.physicsBody = SCNPhysicsBody.static()
        Balloon.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        Balloon.physicsBody?.categoryBitMask = BitMaskCategory.target.rawValue
        Balloon.physicsBody?.contactTestBitMask = BitMaskCategory.arrow.rawValue
        self.ArScene.scene.rootNode.addChildNode(Balloon)
        
    }
    
//    func AddTarget(hitTestResult: ARHitTestResult){
//        let TargetScene = SCNScene(named: "art.scnassets/TargetScene.scn")
//        let targetNode = TargetScene?.rootNode.childNode(withName: "Target", recursively: false)
//        let positionOfPlane = hitTestResult.worldTransform.columns.3
//        let xPos = positionOfPlane.x
//        let yPos = positionOfPlane.y
//        let zPos = positionOfPlane.z
//        targetNode?.position = SCNVector3(xPos, yPos, zPos)
//        targetNode?.physicsBody = SCNPhysicsBody.static()
//        self.ArScene.scene.rootNode.addChildNode(targetNode!)
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.TargetIsAdded = true
//        }
//
//    }
//
//    func GenerateEnemy() {
//        let position = SCNVector3(x: 0, y: 0, z: -11)
////        let enemy = SCNNode(geometry: SCNCylinder(radius: 1, height: 3))
////        enemy.geometry?.firstMaterial?.diffuse.contents = UIColor.red
////        enemy.position = position
////        self.ArScene.scene.rootNode.addChildNode(enemy)
//        let archerScene = SCNScene(named: "art.scnassets/Archer.scn")
//        let archerNode = archerScene?.rootNode.childNode(withName: "Archer", recursively: false)
//        archerNode?.position = position
//        self.ArScene.scene.rootNode.addChildNode(archerNode!)
//    }
    @objc func randomizeTargets() {
        print("making target")
        
        var disp = arc4random_uniform(7)
        var sign = arc4random_uniform(2)
        if sign % 2 == 0 {
            let x = Float(disp)
            AddTarget(x: -x, y: 0, z: -10)
        }
        else {
            let x = Float(disp)
            AddTarget(x: x, y: 0, z: -10)
        }
        
    }
    
    @objc func RunGame() {
        if Time == 30 {
            playing = false
            TargetTimer.invalidate()
            GameTime.invalidate()
            Time = 0
            var adRand = arc4random_uniform(2)
            if adRand % 2 == 0 {
                showAd()
            }
            else{
                DisplayGameoverAlert()
            }
        }
        else {
            Time += 1
        }
        TimeLabel.text = String(Time)
    }
    func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
        DisplayGameoverAlert()
    }
    
    func GamePlay() {
        if playing == true {
            TargetTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(randomizeTargets), userInfo: nil, repeats: true)
            GameTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RunGame), userInfo: nil, repeats: true)
            
//          enemyTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector:          #selector(EnemyShoot), userInfo: nil, repeats: true)
        }
    }
    
    // Below function is used in version where enemy shoots back
//    @objc func EnemyShoot() {
//        // called from a timer where it shoots projectiles back at the user
//        var RandomizedHit = arc4random_uniform(2)
//        // find way to animate projectiles coming towards user
//        if RandomizedHit % 2 == 0 {
//            // drop users health by 33%
//            PlayerHealth -= 33
//            if PlayerHealth < 0 {
//                playing = false
//                // call function displaying a message saying you died
//
//            }
//
//            // sets of .5 second timer where the user cant shoot??
//
//        }
//    }
//
    func shoot() {
        guard let pointOfView = self.ArScene.pointOfView else {return}
        
        let transform = pointOfView.transform
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let orientaion = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let position = SCNVector3(x: 0, y: 0, z: 0.1)
        let ball = SCNNode(geometry: SCNSphere(radius: 0.3))
        
        ball.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        ball.position = position
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball))
        ball.physicsBody = body
        ball.physicsBody?.applyForce(SCNVector3(orientaion.x*power, orientaion.y*power, orientaion.z*power), asImpulse: true)
        self.ArScene.scene.rootNode.addChildNode(ball)
        
        
        // Archery block
//        let arrowScene = SCNScene(named: "art.scnassets/arrow.scn")
//        let arrowNode = arrowScene?.rootNode.childNode(withName: "arrow-obj", recursively: false)
//        arrowNode?.position = position
//        //self.ArScene.scene.rootNode.addChildNode(arrowNode!)
//        let arrowBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: SCNCylinder(radius: 0.1, height: 0.6)))
//        arrowNode?.physicsBody = arrowBody
//        arrowNode?.physicsBody?.applyForce(SCNVector3(orientaion.x*power, orientaion.y*power, orientaion.z*power), asImpulse: true)
//        arrowNode?.physicsBody?.categoryBitMask = BitMaskCategory.arrow.rawValue
//        arrowNode?.physicsBody?.contactTestBitMask = BitMaskCategory.target.rawValue
//        if arrowNode != nil {
//            self.ArScene.scene.rootNode.addChildNode(arrowNode!)
//
//        }
    
        
        
        
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        
        DispatchQueue.main.async {
            self.PlaneDetectionLabel.isHidden = false
        }
       self.GamePlay()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        //self.ShotTimer.stop()
    }

}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}


