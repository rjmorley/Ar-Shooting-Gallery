//
//  PastWorkoutSummaryViewController.swift
//  yourFit
//
//  Created by rj morley on 9/30/18.
//  Copyright © 2018 ___rickjames___. All rights reserved.
//

import UIKit
import Firebase

class PastWorkoutSummaryViewController: UIViewController {

    @IBOutlet weak var WorkOutDes: UITextView!
    @IBOutlet weak var ScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //WorkOutDescLabel.text = SelectedWorkout as! String
        //print(SelectedWorkout)
        parseSnapshot()

        // Do any additional setup after loading the view.
    }
    func parseSnapshot() {
        var info = SelectedWorkout.childSnapshot(forPath: "Exercise")
        for exercise in info.children.allObjects as! [DataSnapshot]{
            var num = 1
            //print(exercise.value)
            var name = exercise.key
            //var ex = exercise.value as! String
            
           // var set = exercise.value
            WorkOutDes.text = WorkOutDes.text! + " \(name):\n \n"
            for sets in exercise.children.allObjects as! [DataSnapshot]{
                //print(sets.value)
                
                
                for set in sets.children.allObjects as! [DataSnapshot]{
                    //print(set.value)
                    //var repsWeight = set.value as! String
                    WorkOutDes.text = WorkOutDes.text! + " set \(num): \n"
                    for reps in set.children.allObjects as! [DataSnapshot]{
                        print(reps)
                        var rep = reps.key
                        var weight = reps.value as! Int // change to Pounds
                        WorkOutDes.text = WorkOutDes.text! + " \(rep) = \(weight) \n"
                    }
                    
                    num += 1
                    WorkOutDes.text = WorkOutDes.text! + "\n"
                }
               // WorkOutDescLabel.text = WorkOutDescLabel.text! + "\n"
                
            }
            
        }
        //print(info)
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
