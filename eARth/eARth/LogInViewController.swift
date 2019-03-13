//
//  LogInViewController.swift
//  eARth
//
//  Created by rj morley on 5/15/18.
//  Copyright © 2018 ___rickjames___. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class LogInViewController: UIViewController {
    
    @IBOutlet weak var LoginOutlet: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        
        guard let email = emailTextField.text, let password = PasswordTextField.text else { return}
        Firebase.Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let user = Firebase.Auth.auth().currentUser {
                print("logged in!")
                self.performSegue(withIdentifier: "LogInToMain", sender: self)
            }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
