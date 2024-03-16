//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray: [Item] = [Item(title: "Find Mike"),
                             Item(title: "Buy Eggs"),
                             Item(title: "Destroy Demogorgon"),
                             Item(title: "a"),
                             Item(title: "b"),
                             Item(title: "c"),
                             Item(title: "d"),
                             Item(title: "e"),
                             Item(title: "f"),
                             Item(title: "g"),
                             Item(title: "h"),
                             Item(title: "i"),
                             Item(title: "j"),
                             Item(title: "k"),
                             Item(title: "l"),
                             Item(title: "m"),
                             Item(title: "n"),
                             Item(title: "o"),
                             Item(title: "p"),
                             Item(title: "q"),
                             Item(title: "r"),
                             Item(title: "s"),
                             Item(title: "t"),
                             Item(title: "u"),
                             Item(title: "v"),
                             Item(title: "w"),
                             Item(title: "x"),
                             Item(title: "y"),
                             Item(title: "z")]

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if let data = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = data
        }
    }

    override func tableView(_ tableView: UITableView, 
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
//        content.text = itemArray[indexPath.row].title

        // Update checkmark appearance
        cell.accessoryType = itemArray[indexPath.row].completionStatus ? .checkmark : .none

        // Update text appearance
        if itemArray[indexPath.row].completionStatus {
            let attributes = [
                NSAttributedString.Key.strikethroughStyle : 2]
            content.attributedText = NSAttributedString(string: itemArray[indexPath.row].title, attributes: attributes)
            cell.contentConfiguration = content
        } else {
            let attributes = [
                NSAttributedString.Key.strikethroughStyle : 0]
            content.attributedText = NSAttributedString(string: itemArray[indexPath.row].title, attributes: attributes)
        }

        cell.contentConfiguration = content
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let cell = tableView.cellForRow(at: indexPath)
        itemArray[indexPath.row].completionStatus.toggle()

        // To update UI with updated task appearance.
        tableView.reloadData()

//        defaults.set(itemArray, forKey: "TodoListArray")

        // To get select/deselect appearance
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { [weak self] action in
            if let text = textField.text, !text.isEmpty {
                self?.itemArray.append(Item(title: text))
                self?.defaults.set(self?.itemArray, forKey: "TodoListArray")
                self?.tableView.reloadData()
            }
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
}

