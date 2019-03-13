//
//  SignUpViewController.swift
//  yourFit
//
//  Created by rj morley on 9/24/18.
//  Copyright © 2018 ___rickjames___. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var CreateAcctOut: UIButton!
    
    @IBAction func createAccountAction(_ sender: AnyObject) {
        let ref = Database.database().reference().root
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            
            
            Firebase.Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    print("making new user")
                    //ref.child("User").childByAutoId()
//                    ref.child("Users").child("User").child("email").setValue(email)
//                    ref.child("Users").child("User").child("uid").childByAutoId()
                    let user = Firebase.Auth.auth().currentUser
                    ref.child("Users").child((user?.uid)!).child("Info").child("Email").setValue(email)
                    self.performSegue(withIdentifier: "SignUpToHome", sender: self)
                    
                
                    
                }
            })
            
            /*if error == nil {
             print("You have successfully signed up")
             
             ref.child("users").child((user?.uid)!).setValue(email)
             
             //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
             self.performSegue(withIdentifier: "SignUpToHome", sender: self)
             
             //let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
             // self.present(vc!, animated: true, completion: nil)
             
             } else {
             let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
             
             let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
             alertController.addAction(defaultAction)
             
             self.present(alertController, animated: true, completion: nil)
             }*/
        }
        //}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
