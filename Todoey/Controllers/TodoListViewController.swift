//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Priyal PORWAL on 22/03/24.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!

    lazy var coreDataContext: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        searchBar.delegate = self
        /*
         /Users/priyalporwal/Library/Developer/CoreSimulator/Devices/4FA3F427-A7D1-4552-B942-E3491BB14A09/data/Containers/Data/Application/4E1D8E45-7F75-4D4D-A36C-59A7029090CA/Library/Application\ Support/DataModel.sqlite
         */
        print("CoreData DB Location", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
            content.attributedText = NSAttributedString(string: itemArray[indexPath.row].title ?? "", attributes: attributes)
            cell.contentConfiguration = content
        } else {
            let attributes = [
                NSAttributedString.Key.strikethroughStyle : 0]
            content.attributedText = NSAttributedString(string: itemArray[indexPath.row].title ?? "", attributes: attributes)
        }

        cell.contentConfiguration = content
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
/*
 Deleting item from Core Data (order of statements very important

 context.delete(itemArray[indexPath.row])
 itemArray.remove(at: indexPath.row
 */

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
        let action = UIAlertAction(title: "Add Item",
                                   style: .default) { [weak self] action in
            guard let self,
                  let text = textField.text, !text.isEmpty
            else { return }

            let item = Item(context: self.coreDataContext)
            item.title = text
            item.completionStatus = false

            self.itemArray.append(item)

            // Update persistence storage with new item
            self.saveItems()

            self.tableView.reloadData()
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    private func saveItems() {
        do {
            try coreDataContext.save()
        } catch {
            print("❌ Error saving context", error.localizedDescription)
        }
    }

    private func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        itemArray = fetchData(with: request)
    }

    private func fetchData<T>(with request: NSFetchRequest<T>) -> [T] {
        do {
            return try coreDataContext.fetch(request)
        } catch {
            print("Error fetching data from context", error)
            return []
        }
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
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        if let text = searchBar.text, !text.isEmpty {
            // Ref: NSPredicate Cheetsheet, NSPredicate from NSHipster
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
            request.predicate = predicate

            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            request.sortDescriptors = [sortDescriptor]

            itemArray = fetchData(with: request)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, text.isEmpty || text.count == 0 {
            loadItems()
            dismissSearchBarKeyboard()
        }
    }
}
