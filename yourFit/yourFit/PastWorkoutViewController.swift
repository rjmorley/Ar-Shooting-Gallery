//
//  PastWorkoutViewController.swift
//  yourFit
//
//  Created by rj morley on 9/30/18.
//  Copyright © 2018 ___rickjames___. All rights reserved.
//

import UIKit
import Firebase


var SelectedWorkout = DataSnapshot()

class PastWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var Workouts = [DataSnapshot]()
    var dates = [String]()
    
    @IBOutlet weak var PastWorkOutTV: UITableView!
    
    
    func LoadWorkOuts() {
        let user = Firebase.Auth.auth().currentUser
        Database.database().reference().child("Users").child((user?.uid)!).child("Workouts").observe(.value) { (snapshot) in
            //print(snapshot)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        //var tmp = Workouts[indexPath.row]
        cell.textLabel?.text = dates[indexPath.row]
        //print(dates)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedWorkout = Workouts[indexPath.row]
        self.performSegue(withIdentifier: "TableToWorkout", sender: self)
    }
    
    @IBOutlet weak var PastWorkOutTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveWorkouts()

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveWorkouts() {
        var User = Firebase.Auth.auth().currentUser
        Database.database().reference().child("Users").child((User?.uid)!).child("Workouts").observe(.value) { (snapshot) in
            //print(snapshot)
            print(snapshot.childrenCount)
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                //print(child.key)
                var exercise = child as? NSDictionary
                //print(exercise)
                var date = child.key
                //print(date)
                var name = exercise?["Exercise"] as? String
                //print(name)
                var set = exercise?["Set"] as? Int
                var weigt = exercise?["Weight"] as? Int
                self.Workouts.append(child)
                self.dates.append(date)
                print(self.dates)
                self.PastWorkOutTV.reloadData()
                
            }

//            self.dates.append(date)
            
            
            //print(self.Workouts)
            // based on results parse out dates and set as keys for the table
            
        }
        
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
