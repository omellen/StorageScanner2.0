//
//  ItemsViewController.swift
//  StorageScanner2.0
//
//  Created by Olivia Mellen on 4/20/22.
//

import UIKit

class ItemsViewController: UIViewController {

    var storageTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = storageTitle
    }
    
}
