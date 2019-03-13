//
//  SetViewController.swift
//  yourFit
//
//  Created by rj morley on 10/4/18.
//  Copyright © 2018 ___rickjames___. All rights reserved.
//

import UIKit
//import FirebaseDatabase
import Firebase
import FBAudienceNetwork


class SetViewController: UIViewController, FBAdViewDelegate {

    @IBOutlet weak var RepsTF: UITextField!
    
    @IBOutlet weak var WeightTF: UITextField!
   
    @IBOutlet weak var ExLabel: UILabel!
    
    
    var Weight = Int()
    var Reps = Int()
    var Time = Int()
    var bannerADView: FBAdView!
   
    @IBOutlet weak var Submit: UIButton!
    
    
    @IBAction func SubmitButton(_ sender: Any) {
        
        if WeightTF.text == ""{
            let alertController = UIAlertController(title: "Weight Not Provided", message: "Please Provide Weight", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else if RepsTF.text == "" {
            let alertController = UIAlertController(title: "Number of Reps Not Provided", message: "Please Provide Number of Reps", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else {
            if currSet < NumSets {
                Weight = Int(WeightTF.text!)!
                Reps = Int(RepsTF.text!)!
                PostToDB()
                currSet += 1
                WeightTF.text = ""
                RepsTF.text = ""
                
            }
            else {
                Weight = Int(WeightTF.text!)!
                Reps = Int(RepsTF.text!)!
                PostToDB()
                currSet = 1
                self.performSegue(withIdentifier: "SetsToExercise", sender: self)
            }
        }
        
    }
    
    func PostToDB() {
        print("in post to DB")
        let ref = Database.database().reference().root
        var user = Firebase.Auth.auth().currentUser
        if user != nil {
            let key = ref.child("Users").child((user?.uid)!).child("Workouts").childByAutoId().key
            let Set = ["Reps": Reps, "Weight": Weight] as [String: Any]
            let childUpdates = ["/Users/\((user?.uid)!)/Workouts/\(today)/Exercise/\(ExName)/Set/\(currSet)": Set]
            ref.updateChildValues(childUpdates)
            print("Under update child values")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var currSet = 1
        // Do any additional setup after loading the view.
        ExLabel.text = ExName
        Submit.layer.cornerRadius = 10
        Submit.clipsToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func loadFaceBookBanner() {
        bannerADView = FBAdView(placementID: "179879002896973_179879379563602", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        bannerADView.frame = CGRect(x: 0, y: view.bounds.height - bannerADView.frame.size.height, width: bannerADView.frame.size.width, height: bannerADView.frame.size.height)
        bannerADView.delegate = self
        bannerADView.isHidden = true
        self.view.addSubview(bannerADView)
        bannerADView.loadAd()
    }
    
    
    func adViewDidLoad(_ adView: FBAdView) {
        bannerADView.isHidden = false
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print(error)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
