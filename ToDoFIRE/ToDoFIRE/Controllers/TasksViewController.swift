//
//  TasksViewController.swift
//  ToDoFIRE
//
//  Created by mac on 16.11.2023.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
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

    //MARK: - @IBAction
    @IBAction func addTapped(_ sender: Any) {
    }
}
