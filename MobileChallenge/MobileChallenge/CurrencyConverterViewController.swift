//
//  CurrencyConverterViewController.swift
//  MobileChallenge
//
//  Created by Orla on 17/01/2017.
//  Copyright © 2017 Orla. All rights reserved.
//

import UIKit

class CurrencyConverterViewController: UIViewController {

    @IBOutlet weak var currentCurrencyView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedCurrencyType: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!

    
    var tableViewVC: CurrencySelectionViewController?
    
    var baseValue: Double = 0
    
    var dataModel = CurrencyModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentCurrencyView.layer.cornerRadius = 6
        currentCurrencyView.layer.borderColor = UIColor.lightGray.cgColor
        currentCurrencyView.layer.borderWidth = 1
        
        inputTextField.layer.cornerRadius = 6
        inputTextField.layer.borderColor = UIColor.lightGray.cgColor
        inputTextField.layer.borderWidth = 1
        
        containerViewHeight.constant = 0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CurrencyConverterViewController.updateCollectionView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        CurrencyService.getCurrencyData("USD") { (result: CurrencyModel) in
            self.dataModel = result
            self.updateCurrencySelectionTableView()
            return
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let currencySelection = segue.destination as? CurrencySelectionViewController {
            tableViewVC = currencySelection
            tableViewVC?.delegate = self
        }
    }

    func updateCollectionView() {
        if let text = inputTextField.text {
            baseValue = Double(text) ?? 0
            collectionView.reloadData()
        }
        
        inputTextField.resignFirstResponder()
    }
    
    @IBAction func currencyTypeButtonSelected(_ sender: Any) {
        guard let tableViewVC = tableViewVC else {
            return
        }
        
        if tableViewVC.isOpen {
            containerViewHeight.constant = 0
            
            UIView.animate(withDuration: 0.25) {
                self.containerView.layoutIfNeeded()
            }
            tableViewVC.isOpen = false
        }
        else {
            containerViewHeight.constant = 100
            
            UIView.animate(withDuration: 0.25) {
                self.containerView.layoutIfNeeded()
            }
            tableViewVC.isOpen = true
        }
    }

    func updateCurrencySelectionTableView() {
        DispatchQueue.main.sync {
            guard let tableViewVC = tableViewVC else {
                return
            }
            
            for value in dataModel.rates {
                tableViewVC.currencyTypes.append(value.currencyType)
            }
            
            tableViewVC.tableView.reloadData()
        }
    }
}

extension CurrencyConverterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.updateCollectionView()
        return true
    }
}

extension CurrencyConverterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (inputTextField.text?.characters.count ?? 0) > 0 {
            return dataModel.rates.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let currencyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CurrencyCollectionViewCell else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            return cell
        }
        
        currencyCell.updateContent()
        
        
        currencyCell.currencyValueLabel.text = String(format: "%.2f", dataModel.rates[indexPath.row].amount * baseValue)
        currencyCell.currencyTypeLabel.text = dataModel.rates[indexPath.row].currencyType
        
        return currencyCell
        
    }
}

extension CurrencyConverterViewController: CurrencySelectionDelegate {
    func selectedCurrency(currencyType: String) {
        self.selectedCurrencyType.text = currencyType
        self.currencyTypeButtonSelected(self)
        
        CurrencyService.getCurrencyData(currencyType) { (result: CurrencyModel) in
            self.dataModel = result
            self.updateCurrencySelectionTableView()
            DispatchQueue.main.sync {
                self.collectionView.reloadData()
            }
            return
        }
    }
}

