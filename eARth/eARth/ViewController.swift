//
//  ViewController.swift
//  eARth
//
//  Created by rj morley on 5/11/18.
//  Copyright © 2018 ___rickjames___. All rights reserved.
// still need to add a log in screen will be done in next day or two

import UIKit
import ARKit
import ARCL
import CoreLocation
import Firebase
//import FirebaseDatabase
//import FirebaseAuth

// need to import geotracking, firebase database
var newpostText = String()
var postMode = 0
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var ArScene: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var locationManager: CLLocationManager!
   // var sceneLocationView = SceneLocationView()
    // latitude and longitude
    var Lat = Double()
    var Lon = Double()
    var CamX = Float()
    var CamY = Float()
    var CamZ = Float()
    var TestPost = String()
    var MyPostLat = Double()
    var MYPostLon = Double()
    var UserPostLats = [Double]()
    var NearbyPosts = [[String: Any]]()
    // add image post and video post thinking use texture for photo and url for video
    
    
    @IBAction func NewPostButton(_ sender: Any) {
        createPost()
        //print(lat)
        //print(lon)
       // locationManager.requestLocation()
        //createPost()
        //performSegue(withIdentifier: "MainToPostSetup", sender: self)
        // make it so when returning from post page we create the new post with the text, image or video as the material
    }
    
    // functions for determining location
    func determineLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let UserLocation: CLLocation = locations[0] as CLLocation
        
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            print("\(lat),\(long)")
            Lon = long
            Lat = lat
        } else {
            print("No coordinates")
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func Post() {
        // takes in lat lon x y z as well all post info post id will be randomly generated
        // upload new post node to data base with lat and lon as well as camera orientation
        
    }
    func createPost() -> SCNNode? {
        print("in create post")
        let ref = Database.database().reference().root
        let userTouch = ArScene.center
        let test = ArScene.hitTest(userTouch, types: .featurePoint)
        
      /*  // code for posting free standing text
        let text = SCNText(string: newpostText, extrusionDepth: 1)
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIColor.purple
        text.materials = [textMaterial]
        let textNode = SCNNode()
        textNode.position = SCNVector3(x: textNode.worldTransform.columns.3.x, y: textNode.worldTransform.columns.3.y, z: textNode.worldTransform.columns.3.z)
        textNode.geometry = text
        
        CamX = textNode.worldTransform.columns.3.x
        CamY = textNode.worldTransform.columns.3.y
        CamZ = textNode.worldTransform.columns.3.z
        
        
        MYPostLon = Lon
        MyPostLat = Lat
        
        
       var user = Firebase.Auth.auth().currentUser
       
        if (user != nil) {
            print(MyPostLat)
            ref.child("Users").child((user?.uid)!).child("Posts").child("Post").child("Location").child("Lat").setValue(MyPostLat)
            
            ref.child("Users").child((user?.uid)!).child("Posts").child("Post").child("Location").child("Lon").setValue(MYPostLon)
            
                ref.child("Users").child((user?.uid)!).child("Posts").child("Post").child("text").setValue(newpostText)
        }
        else {
            print("cant upload post")
        }
        
        ArScene.scene.rootNode.addChildNode(textNode)
        */
        
        if let postframe = test.first {
            print("in if let")
            // below is the test frame need to create a separate post class which uses a template made in photoshop that can be filled with info for the actual post
            let frame = SCNPlane(width: 1.0, height: 0.6)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.white
            frame.firstMaterial = material
            let currPost = SCNNode(geometry: frame)
            currPost.position = SCNVector3(postframe.worldTransform.columns.3.x, postframe.worldTransform.columns.3.y, postframe.worldTransform.columns.3.y)
            ArScene.scene.rootNode.addChildNode(currPost)
            
            // Capture Camera position
            CamX = postframe.worldTransform.columns.3.x
            CamY = postframe.worldTransform.columns.3.y
            CamZ = postframe.worldTransform.columns.3.z
            print("\(Lat), \(Lon)")
            MYPostLon = Lon
            MyPostLat = Lat
            
            // upload post info to firebase
            var user = Firebase.Auth.auth().currentUser
            if user != nil {
                let key = ref.child("Users").child((user?.uid)!).child("Posts").childByAutoId().key
                let post = ["uid": user?.uid, "Lat": MyPostLat, "Lon": MYPostLon, "x": CamX, "y": CamY, "z": CamZ] as [String : Any]
                let childUpdates = ["/Users/\((user?.uid)!)/Posts/\(key)": post, "/Posts/\(key)/": post]
                ref.updateChildValues(childUpdates)
                print("Under update child values")
            }
            
            /*if user != nil {
                ref.child("Users").child((user?.uid)!).child("Posts").childByAutoId().child("Location").child("Lat").setValue(MyPostLat)
                
                ref.child("Users").child((user?.uid)!).child("Posts").childByAutoId().child("Location").child("Lon").setValue(MYPostLon)
                
                ref.child("Users").child((user?.uid)!).child("Posts").childByAutoId().child("Cam Position").child("x").setValue(CamX)
                
                ref.child("Users").child((user?.uid)!).child("Posts").childByAutoId().child("Cam Position").child("y").setValue(CamY)
                
                ref.child("Users").child((user?.uid)!).child("Posts").childByAutoId().child("Cam Position").child("z").setValue(CamZ)
            }*/
            
            
            // find a way to capture users text or video here need to import photoKit and AvKit
            // need to promt users with a text field and or camera option/video option
            
            
            
            
       
            return currPost
        }
        return nil
    }
    
   
    func recursLoadPosts(Latitude: Double, Longitude: Double, X: Float, Y: Float, Z: Float) -> SCNNode? {
        // takes in post meta data such as post id, lat, lon, camx, camy, camz as well as user id and post meta cache these "local" posts
        // firebase query needed here to retrieve post info
        print("in recurse Post")
        let frame = SCNPlane(width: 1.0, height: 0.6)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        frame.firstMaterial = material
        let recursePost = SCNNode(geometry: frame)
        recursePost.position = SCNVector3(X, Y, Z)
        ArScene.scene.rootNode.addChildNode(recursePost)
        print("under add child node")
        
        
//        var currAltitude: CLLocationDistance { get }
//        let coordinate = CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude)
//        let location = CLLocation(coordinate: coordinate, altitude: currAltitude)
//        let image = UIImage(named: "Logo")!
//        let annotationNode = LocationAnnotationNode(location: location, image: image)
//
//        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
//
        
        return recursePost
    }
    
    func SelectPost(){
        // takes in post id then uses database to show full post
        // firebase query needed here to retrieve post content
    }
    
    
    func retrievePosts() {
        //  have constant running firebase query
        // retirve posts withing certain lat lon distance
        // have a function that appends post id to lat and lon var names
    
        // do .0005 for approx 50 yards
        //change path to users
        Database.database().reference().child("Posts").observe(.value, with: { (snapshot) in
            print(snapshot)
            let post = snapshot.value as? NSDictionary
            let postLat = post?["Lat"] as? Double
            let postLon = post?["Lon"] as? Double
            let Xpos = post?["x"] as? Float
            let Ypos = post?["y"] as? Float
            let Zpos = post?["z"] as? Float
            
            if let newpostLat = postLat {
                if let newpostLon = postLon{
                    if newpostLat <= (self.MyPostLat + 0.0005) && newpostLat >= (self.MyPostLat - 0.0005){
                        if newpostLon <= (self.MYPostLon + 0.0005) && newpostLon >= (self.MYPostLon - 0.0005){
                            print(post)
                            self.recursLoadPosts(Latitude: newpostLat, Longitude: newpostLon, X: Xpos!, Y: Ypos!, Z: Zpos!)
                        }
                    }
                }
                
            }
            
            // print(postLat)
        }, withCancel: nil)
    }
    func segueToProfile() {
        
    }
    func segueToFavorites() {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval){
        
        // finds cameras relative location and orientation
        guard let pointOfView = ArScene.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPositionOfCamera = plus(left: orientation, right: location)
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor){
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        let postPlane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let postNode = SCNNode(geometry: postPlane)
        postNode.opacity = 0.5
        node.addChildNode(postNode)
    }
    
    // used for linear algebra transformations
    func plus(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x+right.x, left.y+right.y, left.z+right.z)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        /*if postMode == 1 {
            postMode = 0
            createPost()
        }*/
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // sceneLocationView.run()
       // view.addSubview(sceneLocationView)
        // setting up arKit functionality
        self.ArScene.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
       // configuration.worldAlignment = .gravityAndHeading
        ArScene.session.run(configuration)
        
        //locationManager.delegate = self
        //locationManager.requestWhenInUseAuthorization()
        determineLocation()
        
        retrievePosts()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //sceneLocationView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }


}

