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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ref.observe(.value) { [weak self] dataSnapshot in
            var _tasks = Array<TaskModel>()

            for item in dataSnapshot.children {
                let task = TaskModel(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }

            self?.tasks = _tasks
            self?.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserModel(user: currentUser)
        ref = Database.database().reference().child("users").child(String(user.uid)).child("tasks")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        ref.removeAllObservers()
    }

    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = tasks[indexPath.row]
        let taskTitile = task.title
        let isCompleted = task.completed

        cell.textLabel?.text = taskTitile
        cell.textLabel?.textColor = .white

        toogleCompletion(cell: cell, isCompleted: isCompleted)

        return cell
    }

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed // change the state of the task

        toogleCompletion(cell: cell, isCompleted: isCompleted)
        task.ref?.updateChildValues(["completed": isCompleted])
    }

    //MARK: - Internal logic
    private func toogleCompletion(cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
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
