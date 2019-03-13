//
//  ViewController.swift
//  yourFit
//
//  Created by rj morley on 9/24/18.
//  Copyright © 2018 ___rickjames___. All rights reserved.
//

import UIKit
//import FirebaseAuth
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var PasswordTF: UITextField!
    
    @IBAction func LogIn(_ sender: Any) {
        guard let email = emailTF.text, let password = PasswordTF.text else { return}
        Firebase.Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let user = Firebase.Auth.auth().currentUser {
                print("logged in!")
                self.performSegue(withIdentifier: "LogInToHome", sender: self)
            }
            
        }
    }
    
    @IBAction func SignUp(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PasswordTF.isSecureTextEntry = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

