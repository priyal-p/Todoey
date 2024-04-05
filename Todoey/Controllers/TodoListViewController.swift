//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Priyal PORWAL on 22/03/24.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>? {
        didSet {
            tableView.reloadData()
        }
    }

    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!

    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        searchBar.delegate = self
    }

    override func tableView(_ tableView: UITableView, 
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        // Update checkmark appearance
        cell.accessoryType = (todoItems?[indexPath.row].completionStatus ?? false) ? .checkmark : .none

        // Update text appearance
        if todoItems?[indexPath.row].completionStatus ?? false{
            let attributes = [
                NSAttributedString.Key.strikethroughStyle : 2]
            content.attributedText = NSAttributedString(string: todoItems?[indexPath.row].title ?? "", attributes: attributes)
            cell.contentConfiguration = content
        } else {
            let attributes = [
                NSAttributedString.Key.strikethroughStyle : 0]
            content.attributedText = NSAttributedString(string: todoItems?[indexPath.row].title ?? "", attributes: attributes)
        }

        cell.contentConfiguration = content
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    // Delete item with Realm
//                    realm.delete(item)
                    item.completionStatus.toggle()
                }
            } catch {
                print("❌ Error updating item status for category \(self.selectedCategory?.name ?? "")", error.localizedDescription)
            }
        }

        // To update UI with updated task appearance.
        tableView.reloadData()

        // To get select/deselect appearance
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item",
                                   style: .default) { [weak self] action in
            guard let self,
                  let text = textField.text, !text.isEmpty
            else { return }

            do {
                try realm.write {
                    let item = Item()
                    item.title = text
                    item.dateCreated = Date()
                    self.selectedCategory?.items.append(item)
                }
            } catch {
                print("❌ Error saving items for category \(self.selectedCategory?.name ?? "")", error.localizedDescription)
            }

            self.tableView.reloadData()
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    private func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }

    private func dismissSearchBarKeyboard() {
        DispatchQueue.main.async { [weak self] in
            self?.searchBar.resignFirstResponder()
        }
    }
}

extension TodoListViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissSearchBarKeyboard()
    }
}

// MARK: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?
            .filter("title CONTAINS[cd] %@", searchBar.text)
            .sorted(byKeyPath: "dateCreated", ascending: true)
    }

    private func getCategoryPredicate() -> NSPredicate? {
        if let parentCategory = selectedCategory?.name {
            let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", parentCategory)
            return predicate
        }
        return nil
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, text.isEmpty || text.count == 0 {
            loadItems()
            dismissSearchBarKeyboard()
        }
    }
}
