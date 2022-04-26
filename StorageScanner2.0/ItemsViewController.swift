//
//  ItemsViewController.swift
//  StorageScanner2.0
//
//  Created by Olivia Mellen on 4/20/22.
//

import UIKit

class ItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var storageTitle: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    var items: [Item] = []
    var thisStorage: [Item] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = storageTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getData()
        for x in items {
            if x.location == storageTitle {
                thisStorage.append(x)
            }
        }
        tableView.reloadData()
    }
    
    
    @IBAction func whenButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Item", message: "List the name of your new item", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Item Name"
        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Quantity"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let item = Item(context: context)
            
            let nameTFT = alert.textFields?[0].text
            item.name = nameTFT
            
            let quantityTFT = alert.textFields?[1].text
            item.quantity = quantityTFT
            
            item.location = self.storageTitle
            
            self.items.append(item)
            self.thisStorage.append(item)
            self.tableView.reloadData()
            appDelegate.saveContext()
        }
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getData(){
        if let myItems = try? appDelegate.persistentContainer.viewContext.fetch(Item.fetchRequest()) {
            items = myItems
        } else {
            printContent("error in fetching data")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.thisStorage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "myCell")
        cell.textLabel?.text = self.thisStorage[indexPath.row].name
        cell.detailTextLabel?.text = self.thisStorage[indexPath.row].quantity
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
            let item = self.thisStorage[indexPath.row]
            self.appDelegate.persistentContainer.viewContext.delete(item)
            try! self.appDelegate.persistentContainer.viewContext.save()
            self.getData()
            
            self.thisStorage.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        return [deleteAction]
    }
}
