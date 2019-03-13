//
//  HomeViewController.swift
//  yourFit
//
//  Created by rj morley on 9/24/18.
//  Copyright © 2018 ___rickjames___. All rights reserved.
//

import UIKit
import Firebase

var WorkingOut = Bool()
var today = String()
var WorkOutTimer = Timer()
var seconds = Int()
var Minutes = Int()
var Hours = Int()
class HomeViewController: UIViewController {

    @IBOutlet weak var StartWorkoutButton: UIButton!
    
    @IBOutlet weak var StopWorkOut: UIButton!
    
    @IBAction func LogOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "LogOutSegue", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    @IBAction func StopWO(_ sender: Any) {
        if WorkingOut == true {
            WorkOutTimer.invalidate()
            WorkingOut = false
            let alertController = UIAlertController(title: "Work Out Commplete!", message: "Congradulations on a great work out!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            StopWorkOut.isHidden = true
            StartWorkoutButton.setTitle("Start Work Out", for: [])
            EndTimer()
        }
    }
    
    @IBAction func StartWorkout(_ sender: Any) {
        if WorkingOut == true {
            StartWorkoutButton.setTitle("Back To Work Out", for: [])
            performSegue(withIdentifier: "HomeToWorkOut", sender: self)
        }
        
        else {
            findDate()
            WorkingOut = true
            WorkOutTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(KeepTime), userInfo: nil, repeats: true)
            performSegue(withIdentifier: "HomeToWorkOut", sender: self)
            StartWorkoutButton.isHidden = false
        }
        
        
    }
    
    @objc func KeepTime() {
        seconds += 1
        if seconds == 60 {
            Minutes += 1
            seconds = 0
        }
        if Minutes == 60 {
            Hours += 1
            Minutes = 0
        }
    }
    
    func EndTimer() {
        seconds = 0
        Minutes = 0
        Hours = 0
        // set up alert displaying time user worked out 
    }
    
    
    func findDate() {
        let MyDateFormatter = DateFormatter()
        MyDateFormatter.dateStyle = .medium
        MyDateFormatter.timeStyle = .none
        MyDateFormatter.locale = Locale(identifier: "en_US")
        //var TmpToday = Date() as String
        today = MyDateFormatter.string(from: Date())
        
        print("today")
        print(today)
    }
    
    override func viewDidLoad() {
        StartWorkoutButton.layer.cornerRadius = 10
        StartWorkoutButton.clipsToBounds = true
        StopWorkOut.layer.cornerRadius = 10
        StopWorkOut.clipsToBounds = true
        
        
        super.viewDidLoad()
        if WorkingOut == true {
            StartWorkoutButton.setTitle("Back To Work Out", for: [])
            StopWorkOut.isHidden = false
        }
        else {
            StopWorkOut.isHidden = true
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
