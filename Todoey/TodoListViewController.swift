//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, 
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = itemArray[indexPath.row]

        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            var content = cell?.defaultContentConfiguration()
            let attributes = [
                NSAttributedString.Key.strikethroughStyle : 0]
            content?.attributedText = NSAttributedString(string: itemArray[indexPath.row], attributes: attributes)
            cell?.contentConfiguration = content
        } else {
            var content = cell?.defaultContentConfiguration()
            let attributes = [
                NSAttributedString.Key.strikethroughStyle : 2]
            content?.attributedText = NSAttributedString(string: itemArray[indexPath.row], attributes: attributes)
            cell?.contentConfiguration = content

            cell?.accessoryType = .checkmark
        }
        // To get select/deselect appearance
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { [weak self] action in
            if let text = textField.text, !text.isEmpty {
                self?.itemArray.append(text)
            }
        }

        alert.addTextField { alertTextField in
            textField = alertTextField
            alertTextField.placeholder = "Create new item"
        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
}

