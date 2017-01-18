//
//  CurrencyTableViewCell.swift
//  MobileChallenge
//
//  Created by Orla on 17/01/2017.
//  Copyright © 2017 Orla. All rights reserved.
//

import UIKit

class CurrencyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var currencyValueLabel: UILabel!
    @IBOutlet weak var currencyTypeLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func updateContent() {
        containerView.layer.cornerRadius = 6
    }
}
