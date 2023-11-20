//
//  TasksViewController.swift
//  ToDoFIRE
//
//  Created by mac on 16.11.2023.
//

import UIKit
import Firebase

class TasksViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    //MARK: - Internal variables
    private var user: UserModel!
    private var ref: DatabaseReference!
    private var tasks = Array<TaskModel>()

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserModel(user: currentUser)
        ref = Database.database().reference().child("users").child(String(user.uid)).child("tasks")
    }

    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "This is cell number \(indexPath.row)"
        cell.textLabel?.textColor = .white

        return cell
    }

    //MARK: - @IBActions
    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        alert.addTextField()

        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first, textField.text != "" else { return }

            let task = TaskModel(title: textField.text!, userId: (self?.user.uid)!)
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDictionary())
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)

        [cancel, save].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }

    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Error: ", error.localizedDescription)
        }
        dismiss(animated: true)
    }
}
