//
//  AddPostViewController.swift
//  eARth
//
//  Created by rj morley on 6/5/18.
//  Copyright © 2018 ___rickjames___. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {
    
    
    
    @IBOutlet weak var PostTextTF: UITextField!
    
    @IBAction func AddPost(_ sender: Any) {
        newpostText = PostTextTF.text!
        postMode = 1
        performSegue(withIdentifier: "PostToMain", sender: self)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
