//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Priyal PORWAL on 22/03/24.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray: [Item] = []

    let defaultFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        loadItems()
    }

    override func tableView(_ tableView: UITableView, 
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

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
        itemArray[indexPath.row].completionStatus.toggle()

        // To update UI with updated task appearance.
        tableView.reloadData()

        // Update persistence storage with updated item status
        saveItems()

        // To get select/deselect appearance
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { [weak self] action in
            if let text = textField.text, !text.isEmpty {
                self?.itemArray.append(Item(title: text))

                // Update persistence storage with new item
                self?.saveItems()

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

    private func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            if let urlPath = defaultFilePath {
                try data.write(to: urlPath)
            }
        } catch {
            print("Error encoding item array.", error)
        }
    }

    private func loadItems() {
        if let urlPath = defaultFilePath {
            do {
                let data = try Data(contentsOf: urlPath)
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error to load items from storage", error)
            }
        }
    }
}

