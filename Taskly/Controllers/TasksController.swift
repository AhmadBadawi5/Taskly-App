//
//  TasksController.swift
//  Taskly
//
//  Created by Ahmed Badawi on 30/01/2019.
//  Copyright © 2021 Badawi. All rights reserved.
//

import UIKit

class TasksController: UITableViewController{
    var taskStore: TaskStore! {
        didSet{
            // Reload table view
            // Get data
            tableView.reloadData()
            taskStore.tasks = TasksUtillity.fetch() ?? [[Task](),[Task]()]
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Reload table view
        tableView.reloadData()
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func addTheTask(_ sender: UIBarButtonItem) {
        // Setting up alert controller
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        // Set up the action
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            // Grab text filed text
            guard let name = alertController.textFields?.first?.text else { return }
            // Create Create task
            let newTask = Task(name: name)
            
            // Add task
            self.taskStore.add(newTask, at: 0)
            
            // Reload data in table view
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
            // Save
            TasksUtillity.save(self.taskStore.tasks)
            
        }
        
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        // Add the text field
        alertController.addTextField { textField in
            textField.placeholder = "Enter task name..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        // Add the actions
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        // Present
        present(alertController, animated: true)
    }
    @objc private func handleTextChanged(_ sender: UITextField) {
        
        // Grab the alert controller and add action
        guard let alertController = presentedViewController as? UIAlertController,
        let addAction = alertController.actions.first,
        let text = sender.text
            else {return}
        
        // Enable add action base on if empty or contains whitespace
    addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    
    }
}
extension TasksController {
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
//        if section == 0 {
//            return "To-Do"
//        }
//        else {
//            return "Done"
//        }
         return section == 0 ? "To-do" : "Done"
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name
        // Mark: - DataSource
        return cell
    }
    
    // MARK: - Delegate
}
extension TasksController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            
            // Determine whether the task `isDone`
            guard let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone else { return }
            
            // Remove the task from the appropriate array
            self.taskStore.removeTask(at: indexPath.row, isDone: isDone)
            
            // Reload table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Indicate that the action was performed
            completionHandler(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1450980392, blue: 0.168627451, alpha: 1)
        TasksUtillity.save(self.taskStore.tasks)
        tableView.reloadData()
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completionHandler) in
            // Toggle that the task is done
            self.taskStore.tasks[0][indexPath.row].isDone = true
            // Remove the task from the array containing to do tasks
            let doneTask = self.taskStore.removeTask(at: indexPath.row)
            // Reload table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            // Add the task to the array containing Done tasks
            self.taskStore.add(doneTask, at: 0, isDone: true)
            // Reload table view
            tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            // Indicate the action was performed
            
            
            completionHandler(true)
        }
        
        doneAction.image = #imageLiteral(resourceName: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.7529411765, blue: 0.2901960784, alpha: 1)
        tableView.reloadData()
        // Save
        TasksUtillity.save(self.taskStore.tasks)
        tableView.reloadData()
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
}

