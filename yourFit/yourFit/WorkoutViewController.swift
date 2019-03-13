//
//  WorkoutViewController.swift
//  yourFit
//
//  Created by rj morley on 9/30/18.
//  Copyright © 2018 ___rickjames___. All rights reserved.
//

import UIKit
import Firebase

var NumSets = Int()
var ExName = String()
var currSet = Int()

class WorkoutViewController: UIViewController {
    @IBOutlet weak var ExerciseName: UITextField!
    @IBOutlet weak var NextBTN: UIButton!
    
    @IBOutlet weak var NumberOfSets: UITextField!
    

    
    
    @IBAction func WorkoutButton(_ sender: Any) {
        
        if ExerciseName.text == ""{
            let alertController = UIAlertController(title: "No Exercise Name Provided", message: "Please Provide Exercise Name", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else if NumberOfSets.text == "" {
            let alertController = UIAlertController(title: "Number of Sets Not Provided", message: "Please Provide Number of Sets", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else {
            ExName = ExerciseName.text!
            NumSets = Int(NumberOfSets.text!)!
            currSet = 1
            self.performSegue(withIdentifier: "WoToSet", sender: self)
            // upload values to database and pass number of sets to table view
        }
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NextBTN.layer.cornerRadius = 10
        NextBTN.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
