//
//  CurrencySelectionViewController.swift
//  MobileChallenge
//
//  Created by Orla on 17/01/2017.
//  Copyright © 2017 Orla. All rights reserved.
//

import UIKit

protocol CurrencySelectionDelegate {
    func selectedCurrency(currencyType: String)
}

class CurrencySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var currencyTypes = Array<String>()
    var delegate:CurrencySelectionDelegate! = nil
    var isOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.layer.borderColor = UIColor.lightGray.cgColor
        self.view.layer.borderWidth = 1
        self.view.layer.cornerRadius = 6
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let currencyCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? BaseCurrencyTableViewCell else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
            return cell
        }
        
        currencyCell.currencyType.text = currencyTypes[indexPath.row]
        
        return currencyCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selectedCurrency(currencyType: currencyTypes[indexPath.row])
    }
    
}
