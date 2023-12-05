//
//  ViewController.swift
//  ToDoFIRE
//
//  Created by mac on 15.11.2023.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    //MARK: - Internal variables
    private let tasksSegueIdentifier = "tasksSegue"
    private var ref: DatabaseReference!

    //MARK: - @IBOutlets
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        emailTextField.text = ""
        passwordTextField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        warningLabel.alpha = 0

        ref = Database.database().reference(withPath: "users")

        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.tasksSegueIdentifier)!, sender: nil)
            }
        }

        emailTextField.delegate = self
        passwordTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //MARK: - NotificationCenter
    @objc private func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + kbFrameSize.height)
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }

    @objc private func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }

    //MARK: - Internal logic
    func displayWarningLabel(with text: String) {
        warningLabel.text = text

        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.warningLabel.alpha = 1
        }) { [weak self] complete in
            self?.warningLabel.alpha = 0
        }
    }

    //MARK: - @IBActions
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(with: "Info is incorrect")
            return
        }

        // Firebase authentication
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if error != nil {
                self?.displayWarningLabel(with: "Error occurred")
                return
            }

            if user != nil {
                self?.performSegue(withIdentifier: (self?.tasksSegueIdentifier)!, sender: nil)
            }

            self?.displayWarningLabel(with: "No such user")
        }
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(with: "Info is incorrect")
            return
        }

        // Firebase create user
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in

            guard error == nil, user != nil else {
                print("Error: ", error!.localizedDescription)
                self?.displayWarningLabel(with: "User is not created")
                return
            }

            let userRef = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["email": user?.user.email])
        }
    }

    //MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }

        return true
    }
}
