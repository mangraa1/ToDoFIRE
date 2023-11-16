//
//  ViewController.swift
//  ToDoFIRE
//
//  Created by mac on 15.11.2023.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: - @IBActions
    @IBAction func loginTapped(_ sender: UIButton) {
    }
    
    @IBAction func registerTapped(_ sender: Any) {
    }
}

