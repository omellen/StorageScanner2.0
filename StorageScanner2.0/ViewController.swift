//
//  ViewController.swift
//  StorageScanner2.0
//
//  Created by Olivia Mellen on 4/20/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var storages: [Storage] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var selectedStorage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
    }

    override func viewWillAppear(_ animated: Bool)
    {
        getData()
        tableView.reloadData()
    }
    
    @IBAction func whenButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Storage Area", message: "List the name of your new storage area", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Storage Name"
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let storage = Storage(context: context)
            
            let nameTFT = alert.textFields?[0].text
            storage.name = nameTFT
            
            self.storages.append(storage)
            self.tableView.reloadData()
            appDelegate.saveContext()
        }
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getData()
    {
        if let myStorages = try? appDelegate.persistentContainer.viewContext.fetch(Storage.fetchRequest())
        {
            storages = myStorages
        }
        else
        {
            printContent("error in fetching data")
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = self.storages[indexPath.row].name
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedStorage = "\(storages[indexPath.row].name!)"
        self.performSegue(withIdentifier: "ItemsSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! ItemsViewController
        vc.storageTitle = selectedStorage
    }
}

