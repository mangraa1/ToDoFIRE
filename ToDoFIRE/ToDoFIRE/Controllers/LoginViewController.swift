//
//  ViewController.swift
//  ToDoFIRE
//
//  Created by mac on 15.11.2023.
//

import UIKit

class LoginViewController: UIViewController {

    //TODO: - Проблема с аутлетом в LoginVC, скорее всего нужно пересоздать. Когда ставишь InitialVC на navController, проблема уходит  tasksSegue

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

